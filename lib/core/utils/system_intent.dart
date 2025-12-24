import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoolgeMap(double lat, double lng) async {
  final url =
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

Future<void> callPhoneNumber(String phoneNumber) async {
  if (phoneNumber.isEmpty) return;

  // Normalize: strip spaces and leading 0 if you’ll prefix country code
  final digits = phoneNumber.replaceAll(' ', '');
  final local = digits.startsWith('0') ? digits.substring(1) : digits;

  // Jordan example in E.164 (+962)
  final uri = Uri.parse('tel:+962$local');

  if (await canLaunchUrl(uri)) {
    await launchUrl(
        uri); // uses ACTION_VIEW, opens dialer (no CALL_PHONE permission needed)
  } else {
    // Fallback: try raw as-is (maybe it already includes +962)
    final alt = Uri.parse('tel:$digits');
    if (await canLaunchUrl(alt)) {
      await launchUrl(alt);
    } else {
      throw 'Could not launch $uri';
    }
  }
}

Future<void> openEmail(String email) async {
  final uri = Uri.parse('mailto:$email');
  await launchUrl(uri);
}

Future<void> openStore() async {
  final info = await PackageInfo.fromPlatform();
  final packageName = info.packageName;

  if (Platform.isAndroid) {
    final market = Uri.parse('market://details?id=$packageName');
    if (!await launchUrl(market)) {
      final web = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName');
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  } else if (Platform.isIOS) {
    // TODO: replace with your real App Store ID
    const appStoreId = '0000000000';
    final url = Uri.parse('https://apps.apple.com/app/id$appStoreId');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
