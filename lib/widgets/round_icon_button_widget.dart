import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_colors.dart';

class RoundIconButtonWidget extends StatelessWidget {
  const RoundIconButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: CircleAvatar(
          backgroundColor: AppColors.greyColor,
          radius: 20,
          child: FaIcon(
            icon,
            color: AppColors.blackColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}
