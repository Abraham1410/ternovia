import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class TernoviaLogo extends StatelessWidget {
  final double size;

  const TernoviaLogo({
    super.key,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConstants.logoTernovia,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class TernoviaLogoWithText extends StatelessWidget {
  final double iconSize;
  final TextStyle? textStyle;
  final double spacing;

  const TernoviaLogoWithText({
    super.key,
    this.iconSize = 60,
    this.textStyle,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TernoviaLogo(size: iconSize),
        SizedBox(width: spacing),
        Text(
          AppConstants.appName,
          style: textStyle ??
              TextStyle(
                fontSize: iconSize * 0.38,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.5,
              ),
        ),
      ],
    );
  }
}

class DinasLogo extends StatelessWidget {
  final double size;

  const DinasLogo({
    super.key,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConstants.logoDinas,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
