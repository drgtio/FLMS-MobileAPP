/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $LibGen {
  const $LibGen();

  $LibCoreGen get core => const $LibCoreGen();
}

class $LibCoreGen {
  const $LibCoreGen();

  $LibCoreAssetsGen get assets => const $LibCoreAssetsGen();
}

class $LibCoreAssetsGen {
  const $LibCoreAssetsGen();

  $LibCoreAssetsLocalizationsGen get localizations =>
      const $LibCoreAssetsLocalizationsGen();
}

class $LibCoreAssetsLocalizationsGen {
  const $LibCoreAssetsLocalizationsGen();

  $LibCoreAssetsLocalizationsArGen get ar =>
      const $LibCoreAssetsLocalizationsArGen();
  $LibCoreAssetsLocalizationsEnGen get en =>
      const $LibCoreAssetsLocalizationsEnGen();
}

class $LibCoreAssetsLocalizationsArGen {
  const $LibCoreAssetsLocalizationsArGen();

  /// File path: lib/core/assets/localizations/ar/auth.json
  String get auth => 'lib/core/assets/localizations/ar/auth.json';

  /// File path: lib/core/assets/localizations/ar/common.json
  String get common => 'lib/core/assets/localizations/ar/common.json';

  /// File path: lib/core/assets/localizations/ar/drivers.json
  String get drivers => 'lib/core/assets/localizations/ar/drivers.json';

  /// File path: lib/core/assets/localizations/ar/main.json
  String get main => 'lib/core/assets/localizations/ar/main.json';

  /// File path: lib/core/assets/localizations/ar/vehicles.json
  String get vehicles => 'lib/core/assets/localizations/ar/vehicles.json';

  /// List of all assets
  List<String> get values => [auth, common, drivers, main, vehicles];
}

class $LibCoreAssetsLocalizationsEnGen {
  const $LibCoreAssetsLocalizationsEnGen();

  /// File path: lib/core/assets/localizations/en/auth.json
  String get auth => 'lib/core/assets/localizations/en/auth.json';

  /// File path: lib/core/assets/localizations/en/common.json
  String get common => 'lib/core/assets/localizations/en/common.json';

  /// File path: lib/core/assets/localizations/en/drivers.json
  String get drivers => 'lib/core/assets/localizations/en/drivers.json';

  /// File path: lib/core/assets/localizations/en/main.json
  String get main => 'lib/core/assets/localizations/en/main.json';

  /// File path: lib/core/assets/localizations/en/vehicles.json
  String get vehicles => 'lib/core/assets/localizations/en/vehicles.json';

  /// List of all assets
  List<String> get values => [auth, common, drivers, main, vehicles];
}

class Assets {
  Assets._();

  static const $LibGen lib = $LibGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
