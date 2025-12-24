import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';

Widget svgImage(
  String svgPath, {
  Color svgColor = AppColors.primaryDark,
  double width = 24,
  double height = 24,
  bool autoFlip = false,
  BuildContext? context,
}) {
  final isRtl =
      context != null && Directionality.of(context) == TextDirection.rtl;

  final image = SvgPicture.asset(
    svgPath,
    width: width,
    height: height,
    colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
  );

  if (autoFlip && isRtl) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(-1.0, 1.0),
      child: image,
    );
  } else {
    return image;
  }
}

Image imageUrl(String? url,
    {BoxFit boxfit = BoxFit.cover, width = double.infinity}) {
  return Image.network(
    url ?? '',
    fit: boxfit,
    width: width,
    errorBuilder: (_, __, ___) => Container(
      width: width,
      height: width,
      color: AppColors.neutral10,
      child: Image.asset('lib/core/assets/res/png/logo_placeholder.png', width: 42, height: 42),
    ),
  );
}
