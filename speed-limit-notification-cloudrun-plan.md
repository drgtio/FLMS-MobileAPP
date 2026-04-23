# Speed Limit Notification System Plan

## Goal

Build a reliable speed limit notification feature where:

- DRGT consumer continues decoding and storing telemetry as the source of truth.
- A dedicated Cloud Run service performs speed-limit verification and violation logic.
- Notifications are sent **directly to end users through FCM** without routing through the Fleet notification path.

This plan prioritizes reliability, cost control, and clean integration with existing DRGT and Fleet systems.

---

## Scope

### In Scope

- Cloud Run service for speed-limit verification and violation processing.
- Integration contract from DRGT consumer to the new service (including driver/vehicle identity resolution).
- Data persistence for violation workflow state.
- Dedupe, cooldown, retry, and idempotency design.
- Direct FCM push notification delivery from Cloud Run.
- Fleet internal endpoint for resolving FCM push recipients by device/vehicle.

### Out of Scope (Phase 1)

- Replacing all existing notification features in Fleet.
- Full historical analytics dashboards.
- Multi-channel delivery (SMS/email) beyond push notifications.
- Persisting inbox notifications to Fleet's `UserNotification` table (deferred to Phase 4).

---

## High-Level Architecture

## Components

1. **DRGT Consumer (existing, minimal change)**
   Decodes incoming telemetry, stores it in DRGT DB, and publishes speed sample events containing
   only what DRGT knows: `DeviceId`, `AccountId`, GPS data, and packet metadata.
   DRGT has no knowledge of `VehicleId` — identity resolution is Fleet's responsibility.

2. **Speed Event Publisher (integration in DRGT consumer path)**
   Publishes normalized speed sample events keyed by `DeviceId` for asynchronous processing.

3. **Cloud Run Speed Service (existing, updated)**
   Main processing service:
   - validates event / idempotency
   - resolves speed limit via provider(s)
   - evaluates violation rules
   - resolves FCM recipients via Fleet internal endpoint
   - sends FCM push directly
   - persists results to Firestore

4. **Firestore (service-owned persistent storage)**
   Stores violations, status, processing metadata, retries, and audit trail.

5. **Valkey on DigitalOcean Droplet (ephemeral runtime state)**
   Replaces Google Memorystore. Self-managed Valkey instance provisioned on a DigitalOcean droplet.
   Stores dedupe keys, cooldown windows, hysteresis counters, and short-lived recipient cache.
   Valkey is wire-compatible with Redis; no code changes required — only `REDIS_URL` reconfiguration.

6. **Fleet Internal Recipients Endpoint (new)**
   A new internal API endpoint in Fleet that resolves **all identity and recipient data** for a given
   `DeviceId` (IMEI). Fleet is the single source of truth: it resolves `VehicleId`, `VehicleName`,
   current driver assignment, account owners, and FCM tokens. Cloud Run passes only `deviceId`;
   Fleet returns everything needed to send a notification.

7. **FCM (Google Firebase Cloud Messaging)**
   Cloud Run sends push notifications directly using the FCM HTTP v1 API or legacy API,
   bypassing the Fleet notification service entirely.

8. **Pub/Sub (recommended)**
   Decouples DRGT from heavy processing and provides retry semantics.

---

## Why This Shape

- DRGT ingestion is not blocked by map provider latency or FCM latency.
- Firestore provides durable workflow state and traceability.
- Valkey (DigitalOcean) provides cheap fast suppression/dedupe — no GCP Memorystore cost.
- Cloud Run autoscaling fits bursty telemetry traffic.
- Pub/Sub gives resilient async buffering and retries.
- Direct FCM push removes the Fleet notification path as a hard dependency and failure point.
- Fleet remains the source of truth for user/device/vehicle data, accessed via a lightweight internal endpoint.

---

## End-to-End Workflow

1. DRGT consumer receives and decodes packet.
2. DRGT consumer stores decoded packet/alarm in DRGT DB.
3. DRGT publishes `SpeedSampleReceived` event with `DeviceId`, `AccountId`, GPS data, and packet metadata. No `VehicleId` — DRGT does not know it.
4. Cloud Run speed service consumes event.
5. Service checks idempotency (Firestore + Valkey key).
6. Service resolves road + speed limit from provider chain.
7. Service applies violation policy (buffer, hysteresis, cooldown).
8. If confirmed violation:
   - Call Fleet internal `/api/internal/recipients/by-device?deviceId={imei}`.
   - Fleet resolves `DeviceId → VehicleId + VehicleName + driver + account owners + FCM tokens`.
   - Fleet returns `[{userId, role, registrationId, platform}]` along with `vehicleId` and `vehicleName`.
   - Cache result in Valkey (`recipients:{deviceId}` TTL 5 min) to avoid repeated Fleet calls.
   - Persist violation in Firestore (`pending_notify`), now enriched with `vehicleId` and `vehicleName` from Fleet response.
   - Send FCM push directly to all eligible recipients.
   - Update Firestore status to `sent` or `failed`.
9. Observability data (latency, provider hit rate, failures) is logged and exported.

---

## Driver / Vehicle Identity Resolution

### Design Decision

DRGT only knows `DeviceId` (hardware IMEI). It has **no `VehicleId` in its Device table** — vehicle
and user identity is entirely Fleet's domain. DRGT never resolves or enriches identity data.

The full identity chain is:

```
DeviceId (DRGT publishes)
    ↓
Fleet: GET /api/internal/recipients/by-device?deviceId={imei}
    → VehicleId, VehicleName
    → CurrentDriver (active VehicleAssignment → OperatorId) → FCM RegistrationId
    → AccountOwners (UserType == Owner, Active)             → FCM RegistrationId
```

Cloud Run passes `deviceId` to the Fleet endpoint and receives everything it needs in one call.
`vehicleId` and `vehicleName` in violation records and FCM payloads are populated from the Fleet
response — never from the DRGT event.

### Fleet Recipients Endpoint

Fleet is the source of truth for:
- `Device.SerialNumber` → `Device.VehicleId` and `IntegrationTool.AccountId`
- `VehicleAssignment` → current `OperatorId` (driver with active assignment)
- Account owners: `User` where `AccountId` matches and `UserType == Owner`
- FCM fields: `RegistrationId`, `AuthenticationPlatform`, `AllowNotifications`

```
GET /api/internal/recipients/by-device?deviceId={imei}
```

Response:

```json
{
  "vehicleId": 1204,
  "vehicleName": "Toyota Hilux",
  "recipients": [
    {
      "userId": "8c20b8c2-...",
      "role": "driver",
      "registrationId": "fcm-token-abc",
      "platform": "Android",
      "allowNotifications": true
    },
    {
      "userId": "a1b2c3...",
      "role": "owner",
      "registrationId": "fcm-token-xyz",
      "platform": "IOS",
      "allowNotifications": true
    }
  ]
}
```

Fleet resolves this using:
1. Look up `Device` by `SerialNumber == deviceId` → `VehicleId`, `IntegrationTool.AccountId`
2. Look up active `VehicleAssignment` where `VehicleId` matches and `EndDate IS NULL or > now` → `OperatorId`
3. Look up account owners: `User` where `AccountId == device.account` and `UserType == Owner` and `Active`
4. Filter all recipients to those with `AllowNotifications == true` and non-empty `RegistrationId`

### Recipient Cache in Valkey

Cache recipient data to avoid a Fleet HTTP call on every violation:

- Key: `recipients:{deviceId}`
- TTL: 5 minutes (recipients change infrequently; short TTL ensures assignment changes propagate quickly)
- On cache miss: call Fleet endpoint, cache result, proceed.

---

## Event Contract

### Topic/Event Name

`speed.sample.received.v1`

### Payload (`deviceId` is the only identifier DRGT publishes)

```json
{
  "eventId": "01JXYZ...ULID",
  "eventType": "speed.sample.received.v1",
  "occurredAt": "2026-03-17T10:15:30.123Z",
  "source": "drgt-consumer",
  "deviceId": "359587089999111",
  "accountId": "a1b2c3d4-...",
  "gps": {
    "lat": 24.7136,
    "lon": 46.6753,
    "speedKmh": 92.4,
    "heading": 120,
    "timestamp": "2026-03-17T10:15:29.950Z"
  },
  "metadata": {
    "packetId": 987654321,
    "protocol": "castel",
    "sequence": 44219
  }
}
```

`vehicleId` and `driverUserId` are **not** included in the event — DRGT has no access to vehicle
or user identity. These are resolved by Cloud Run via the Fleet recipients endpoint after a
violation is confirmed.

### Idempotency Key

Use deterministic key:

`deviceId + gps.timestamp + metadata.sequence`

Store as unique identifier in Firestore processing record.

---

## Integration with DRGT Consumer

## DRGT Consumer Changes

DRGT publishes only what it knows: `DeviceId` and `AccountId` from its Device table, plus GPS
and packet metadata. No changes to identity resolution are needed — DRGT has no `VehicleId`
and is not expected to supply one.

The existing `BuildSpeedSampleOutboxMessages` query is sufficient:

```csharp
var accountIdsByDeviceId = await devicesRepo.AsQueryable()
    .Where(d => deviceIds.Contains(d.Id))
    .Select(d => new { d.Id, d.AccountId })
    .ToDictionaryAsync(d => d.Id, d => d.AccountId);
```

### Minimum Speed Threshold Filter

GPS samples whose computed speed is below `MinSpeedKmhThreshold` (default: **5 km/h**) are
**not written to the outbox** and are never published downstream.

`MinSpeedKmhThreshold` is configurable in `SpeedEventPublisherConfigurations`.
Set to `0` to disable (e.g. for debugging).

### Producer Error Policy

- If publish fails: retry with short backoff, write to local outbox for replay.
- Consumer decode/store succeeds independently.

---

## Speed Limit Resolution Strategy

Use provider chain with graceful fallback:

1. **Google Roads API Speed Limits** (primary if license/coverage available)
2. **Secondary provider** (optional: GraphHopper / OSM-based service)
3. **Fleet area speed fallback** (`Area.AlarmSpeed` where available)
4. **Policy default** (urban fallback, e.g. 50 km/h)

### Caching Rules

- Cache road/place speed limit in Valkey:
  - key: `speedlimit:{provider}:{roadRef}`
  - TTL: 1 day (tune per provider update frequency)
- Do not call external provider on every sample.

---

## Violation Decision Rules

To reduce false positives and notification spam:

1. **Tolerance Buffer**
   Trigger only if `speedKmh > limitKmh + 5`.

2. **Hysteresis**
   Require N consecutive violating samples (e.g. 2-3) or M seconds sustained.

3. **Cooldown Window**
   For same vehicle+road, emit max one alert per 2-5 minutes.

4. **Dedupe Key**
   Valkey key: `overspeed:{deviceId}:{roadId}:{bucket}` TTL 5 minutes.

---

## FCM Direct Send

Cloud Run sends FCM notifications directly using the FCM legacy API (same approach currently
used by Fleet's `NotificationPusher`).

### Request shape (Android — data-only)

```json
{
  "registration_ids": ["token1", "token2"],
  "priority": "high",
  "data": {
    "type": "speed_limit_exceeded",
    "eventId": "...",
    "violationId": "...",
    "vehicleId": 1204,
    "vehicleName": "Toyota Hilux",
    "latitude": 24.7136,
    "longitude": 46.6753,
    "speedKmH": 92.4,
    "limitKmH": 80,
    "provider": "google",
    "roadRef": "...",
    "englishTitle": "Speed limit exceeded",
    "englishBody": "Vehicle 'Toyota Hilux' exceeded the speed limit (92 > 80 km/h).",
    "arabicTitle": "تجاوز حد السرعة",
    "arabicBody": "المركبة 'Toyota Hilux' تجاوزت حد السرعة (92 > 80 كم/س)."
  }
}
```

iOS receives an additional `notification` key for system-level display.

### FCM Key

Store FCM server key in **GCP Secret Manager** (or environment variable for local dev).
Do not share this key with DRGT or other services.

---

## Firestore Data Model (Service-Owned)

## Collection: `speed_violations`

Document fields:

- `violationId`
- `eventId`
- `accountId`
- `vehicleId`
- `vehicleName`
- `driverUserId` (null if unresolved)
- `deviceId`
- `lat`, `lon`, `speedKmh`, `limitKmh`
- `provider` (`google`, `osm`, `area_fallback`, `default_fallback`)
- `roadRef`
- `detectedAt`
- `status` (`pending_notify`, `sent`, `failed`, `suppressed`)
- `suppressionReason` (optional)
- `recipientCount` (number of FCM tokens targeted)

## Collection: `event_processing`

- `eventId` (doc id)
- `idempotencyKey`
- `receivedAt`
- `processedAt`
- `result` (`processed`, `duplicate`, `failed`)
- `error` (optional)

## Collection: `notification_attempts`

- `violationId`
- `attemptNo`
- `sentAt`
- `result` (`success`, `failed`)
- `errorCode`, `errorMessage`

---

## Valkey State Backend (DigitalOcean Droplet)

Valkey is a Redis-compatible open-source cache server. The existing `RedisRepository` in the
Python service requires **no code changes** — only the `REDIS_URL` environment variable needs to
point to the DigitalOcean droplet instead of a GCP Memorystore instance.

Valkey is used for:

| Key pattern | Purpose | TTL |
|---|---|---|
| `hysteresis:{deviceId}:{roadRef}` | Consecutive violation counter | 60s |
| `cooldown:{deviceId}:{roadRef}` | Suppress repeated alerts | 5 min |
| `overspeed:{deviceId}:{roadRef}:{bucket}` | Dedupe key | 5 min |
| `speedlimit:{provider}:{roadRef}` | Cached road speed limit | 1 day |
| `recipients:{deviceId}` | Cached FCM recipients from Fleet | 5 min |

Valkey is **not** the system-of-record for delivery status — that is Firestore.

### Droplet Sizing and Security

- Start with a small droplet (1 vCPU / 1 GB RAM); Valkey's memory footprint for ephemeral keys is minimal.
- Enable password authentication (`requirepass`).
- Bind to a private network interface, not the public internet.
- Use DigitalOcean's VPC or firewall rules to restrict access to Cloud Run's egress IP range.
- Store the Valkey password in GCP Secret Manager.

---

## Security and Auth

- OIDC/JWT or shared token between Cloud Run and Fleet's internal endpoints.
- FCM server key stored in GCP Secret Manager.
- Valkey password stored in GCP Secret Manager.
- Restrict Cloud Run ingress to Pub/Sub push or authenticated callers only.
- Encrypt all traffic over HTTPS/TLS.

---

## Cloud Run Deployment Model

## Services

1. `speed-ingest` (optional; receives HTTP and enqueues Pub/Sub)
2. `speed-processor` (Pub/Sub-triggered Cloud Run worker)

## New Environment Variables

| Variable | Purpose |
|---|---|
| `REDIS_URL` | Valkey connection string (e.g. `redis://:password@<droplet-ip>:6379/0`) |
| `FLEET_RECIPIENTS_URL` | Base URL for Fleet's internal API |
| `FLEET_INTERNAL_AUTH_VALUE` | Shared token for Fleet internal auth |
| `FCM_SERVER_KEY` | Firebase legacy server key for direct push |
| `FIRESTORE_PROJECT_ID` | GCP project for Firestore |

Remove: `FLEET_INTERNAL_SPEED_ALERT_PATH` (no longer calling Fleet for notification delivery).

---

## Observability and Ops

Track metrics:

- events consumed/sec
- provider lookup latency and error rate
- cache hit ratio (speed limit + recipients)
- confirmed violations count
- suppressed violations count
- Fleet recipients endpoint latency and error rate
- FCM push success/failure rate per platform (Android / iOS)

Add structured logs with:

- `eventId`, `vehicleId`, `deviceId`, `provider`, `decision`, `reason`, `recipientCount`

Set alerts for:

- Valkey connection failures
- Fleet recipients endpoint outage or high latency
- FCM delivery failure spikes
- Pub/Sub backlog growth
- provider outage

---

## Delivery Roadmap

## Phase 0 - Foundation ✅ Complete

- Contracts and status enums defined.
- Pub/Sub topic/subscription endpoint live.
- Cloud Run service skeleton deployed (FastAPI).
- Firestore and Valkey (previously Redis-backed) repositories wired.

## Phase 1 — DRGT Event Publishing (✅ No changes required)

DRGT has no `VehicleId` in its Device table — identity resolution is Fleet's responsibility entirely.
The existing `BuildSpeedSampleOutboxMessages` publishes `DeviceId` and `AccountId`, which is all
Cloud Run needs to call the Fleet recipients endpoint. No DRGT changes are required for Phase 1.

## Phase 2 — Speed Processor Core (remaining work, 2-3 days)

> **Decision:** Google Roads API integration is deferred to after Phase 4. The pilot will run on
> the area fallback + policy default chain. This is sufficient to validate the end-to-end
> notification pipeline before committing to provider licensing and integration cost.

- ~~**Wire Google Roads API**~~ — deferred to post-Phase 4 (see Phase 5 below).
- Fallback chain (area → default) is already implemented and working.
- Idempotency, hysteresis, cooldown, and Firestore persistence are already implemented.

## Phase 3 — Valkey Migration + Direct FCM (3-4 days)

### 3a: Valkey on DigitalOcean

- Provision Valkey droplet on DigitalOcean.
- Configure private networking and firewall rules.
- Set `STATE_BACKEND=redis` and point `REDIS_URL` to the Valkey droplet.
- Validate `RedisRepository` against Valkey (no code changes expected; confirm with smoke test).
- Remove Firestore state backend as the default once Valkey is stable.

### 3b: Fleet Recipients Endpoint

- Add `GET /api/internal/recipients/by-device?deviceId={imei}` to Fleet's internal controllers.
- Resolve: device serial → vehicle → current driver assignment + account owners.
- Filter to recipients with `AllowNotifications == true` and non-empty `RegistrationId`.
- Return `vehicleId`, `vehicleName`, and `[{userId, role, registrationId, platform}]`.
- Protect with the existing `InternalServiceConfigurations` shared token.

### How `RegistrationId` Gets Populated (Mobile App Responsibility)

The `RegistrationId` stored on the `User` entity **is** the FCM device token. It is written
exclusively by the mobile app via an existing Fleet endpoint — Cloud Run only reads it.

**Token lifecycle:**

1. **On app launch / login** — the Firebase SDK generates (or retrieves) the device's FCM token.
2. **After login** — the mobile app calls:

   ```
   PUT /api/users/device
   Authorization: Bearer <jwt>

   {
     "authenticationPlatform": "Android",   // or "IOS"
     "registrationId": "<fcm-token-from-firebase-sdk>",
     "allowNotifications": true
   }
   ```

   This saves `RegistrationId`, `AuthenticationPlatform`, and `AllowNotifications` to the
   authenticated user's row in `User` table (`UserController` → `UserService.UpdateDeviceRegistration`).

3. **On token refresh** — Firebase rotates tokens periodically or after certain events
   (app reinstall, device restore, etc.). The mobile app must listen to the
   `onTokenRefresh` / `onNewToken` callback and re-call `PUT /api/users/device` with the
   new token immediately. Without this, `User.RegistrationId` becomes stale and Cloud Run
   will receive FCM delivery failures for that recipient.

**Token freshness dependency:**

Cloud Run's `FleetRecipientsClient` retrieves tokens from `GET /api/internal/recipients/by-device`.
The quality of push delivery is therefore directly tied to the mobile app consistently
calling `PUT /api/users/device` on login and on every token rotation. A stale or null
`RegistrationId` causes the violation to be persisted in Firestore but the FCM push to fail
silently for that recipient.

**Recommendation:** during Phase 4 hardening, add a Cloud Run metric that tracks FCM
`NotRegistered` and `InvalidRegistration` error codes — these are the FCM responses that
indicate a stale token and help surface clients that are not refreshing tokens correctly.

### 3c: Python Service — Direct FCM

- Replace `FleetClient.send_speed_alert` with two new service clients:
  - `FleetRecipientsClient` — calls the new Fleet endpoint, caches result in Valkey.
  - `FcmClient` — sends FCM push directly using the Firebase legacy API (matching the format
    used by Fleet's existing `NotificationPusher`).
- Update `SpeedEventProcessor.process` to:
  1. On violation confirmed: call `FleetRecipientsClient.get_recipients(device_id)`.
  2. Build FCM payload with violation data and localized title/body.
  3. Call `FcmClient.send(recipients, payload)` for Android and iOS separately.
  4. Persist attempt result to `notification_attempts` collection in Firestore.
- Add `FCM_SERVER_KEY` to config and Secret Manager.

## Phase 4 - Hardening (2-4 days)

- Add metrics, dashboards, and alerts.
- Implement `notification_attempts` retry logic for FCM failures (currently missing).
- Load test with realistic telemetry bursts.
- Tune thresholds and cooldown parameters.
- Evaluate adding Fleet inbox persistence (`UserNotification`) as a secondary async write
  (optional, for in-app notification center parity).

## Phase 5 — Google Roads API Integration (post-Phase 4)

Deferred intentionally. The pilot runs on area fallback + policy default. Once real violation
data confirms the pipeline is healthy and the tenant/city scope justifies road-level precision:

- Replace `GoogleSpeedLimitProvider` stub with a real implementation calling the Google Roads API.
- Cache results in Valkey: `speedlimit:{provider}:{roadRef}` TTL 1 day.
- Confirm provider licensing and quota limits before enabling in production.
- Evaluate secondary provider (GraphHopper / OSM-based) as fallback to Google.

---

## Testing Strategy

## Unit Tests

- speed decision rule matrix
- hysteresis and cooldown behavior
- idempotency duplicate handling
- recipient cache hit/miss logic
- FCM payload construction (Android vs iOS shape)

## Integration Tests

- DRGT publish (`deviceId` only) → Cloud Run process → Firestore persisted
- Fleet recipients endpoint → returns driver + owners
- violation confirmed → FCM push → status updated
- provider timeout/failure fallback behavior
- Valkey connectivity failure → graceful degradation (Firestore fallback)

## Load/Chaos Tests

- high event throughput burst
- provider 429/5xx simulation
- Pub/Sub redelivery and duplicate events
- Valkey restart / connection loss

---

## Risks and Mitigations

1. **Provider coverage gaps**
   Mitigation: fallback chain + configurable defaults.

2. **Notification spam**
   Mitigation: hysteresis + cooldown + dedupe in Valkey.

3. **Ingestion coupling**
   Mitigation: async Pub/Sub + outbox fallback.

4. **Cost spikes from provider calls**
   Mitigation: Valkey cache + selective lookups + sampling controls.

5. **Valkey droplet as single point of failure**
   Mitigation: all Valkey keys are ephemeral — a restart causes at most one duplicate
   notification per vehicle per cooldown window. Firestore remains the durable system-of-record.
   If budget allows, add a DigitalOcean Valkey replica later.

6. **Fleet recipients endpoint latency adds to processing time**
   Mitigation: Valkey cache with 5-minute TTL means Fleet is called at most once per device
   per 5-minute window under steady traffic.

7. **Fleet recipients endpoint called with unknown `deviceId`**
   Mitigation: Fleet returns an empty recipients list; Cloud Run logs a warning and persists
   the violation as `suppressed` with reason `no_recipients_resolved`. No notification is sent.

---

## Open Decisions Before Build

1. Primary speed provider choice and licensing (Google vs alternatives).
2. Exact threshold policy per account/fleet type.
3. Retention period for Firestore violation records.
4. Whether to support multi-tenant configuration overrides from day 1.
5. Whether Fleet inbox persistence (`UserNotification`) should be a Phase 4 addition or dropped entirely.
6. Valkey droplet size and whether to enable AOF persistence for the recipient cache.

---

## Recommended First Increment

Start with one city/tenant and one alert type:

- overspeed only
- Area/default fallback for speed limit (Google Roads API deferred to Phase 5)
- Direct FCM push (driver + owners resolved by Fleet from `deviceId`)
- Strict cooldown and dedupe via Valkey

Validate quality and cost for 1-2 weeks, then scale gradually.
