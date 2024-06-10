import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '/utils/extensions.dart';

class BirthdayPickerWidget extends StatelessWidget {
  const BirthdayPickerWidget({
    super.key,
    required this.dateTime,
    required this.onPressed,
  });

  final DateTime dateTime;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.blackColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Birthday (${DateTime.now().year - dateTime.year} years old)',
              style: const TextStyle(
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              dateTime.yMMMEd(),
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
