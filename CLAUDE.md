# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Analyze / lint
flutter analyze

# Code generation (after modifying models, DI, or API clients)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

There is no test suite currently in this project.

## Architecture

Clean Architecture with feature modules under `lib/features/`. Each feature follows:

```
features/feature_name/
├── data/
│   ├── di/                  # GetIt module for this feature
│   ├── remote/              # Retrofit API client + JSON-serializable response models
│   └── repository/          # Repository implementations
├── domain/
│   ├── models/              # Domain entities
│   ├── repository/          # Abstract repository interfaces
│   └── usecases/            # Business logic (one use case per action)
└── presentation/
    ├── *_screen.dart        # UI (Consumer of ChangeNotifier)
    └── *_view_model.dart    # ChangeNotifier VM with ValueNotifier<ResultState<T>>
```

## Key Patterns

**State management:** Provider + `ValueNotifier<ResultState<T>>`. `ResultState` is a sealed class: `Idle | Loading | Success<T> | Error`. ViewModels call `RequestStateHandler.run()` to execute async actions and update state. Screens use `ValueListenableBuilder` to react.

**Dependency injection:** GetIt + `injectable`. Add `@injectable` to classes; run build_runner to regenerate `injection.config.dart`. DI is configured in `lib/core/di/` and each feature's `data/di/` folder.

**API layer:** Dio + Retrofit. Define endpoints in `Remote{Feature}DataSource` with `@RestApi`. Response models use `@JsonSerializable`. Run build_runner after changing API clients or models.

**Navigation:** GoRouter with named routes as constants in `AppRoutes`. Use `context.goNamed()` / `context.pushNamed()`. Pass extra data via the `extra` parameter as a map.

**Localization:** EasyLocalization with en/ar JSON files in `lib/core/assets/localizations/`. Use `.tr()` extension on snake_case keys.

**Asset references:** FlutterGen generates typed accessors in `lib/gen/`. Reference assets via `Assets.images.foo` rather than raw strings.

## Naming Conventions

| Layer | Pattern | Example |
|---|---|---|
| Use case | `{Action}UseCase` | `GetVehiclesAreaUseCase` |
| Repository | `{Feature}Repository` / `{Feature}RepositoryImpl` | `DriversRepositoryImpl` |
| ViewModel | `{Feature}ViewModel` | `VehiclesViewModel` |
| Remote data source | `Remote{Feature}DataSource` | `RemoteVehiclesDataSource` |
| API models | `Remote{Entity}Model` | `RemoteVehicleModel` |
| Domain entities | `{Entity}Entity` | `VehicleEntity` |

## Backend

Base URL: `https://v2x-backend-app-yumyj.ondigitalocean.app/app/api/`

Auth uses JWT with a refresh token interceptor (`RefreshTokenInterceptor`). Tokens are stored in `flutter_secure_storage`.
