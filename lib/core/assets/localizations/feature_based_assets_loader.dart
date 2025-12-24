import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class FeatureBasedAssetLoader extends AssetLoader {
  const FeatureBasedAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final basePath = '$path/${locale.languageCode}';

    // ✅ New way: use AssetManifest instead of AssetManifest.json
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final List<String> allAssets = assetManifest.listAssets();

    // Filter all JSON files under the current locale folder
    final files = allAssets
        .where((String key) =>
            key.startsWith(basePath) && key.endsWith('.json'))
        .toList();

    final Map<String, dynamic> result = {};

    for (final file in files) {
      final jsonStr = await rootBundle.loadString(file);
      final Map<String, dynamic> map = json.decode(jsonStr);
      result.addAll(map);
    }

    return result;
  }
}
