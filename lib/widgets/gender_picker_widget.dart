import '../utils/constants.dart';
import '../widgets/gender_radio_title_widget.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class GenderPickerWidget extends StatelessWidget {
  const GenderPickerWidget({
    super.key,
    required this.gender,
    required this.onChanged,
  });

  final String gender;
  final Function(String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Constants.defaultPadding,
      decoration: BoxDecoration(
        color: AppColors.darkWhiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GenderRadioTitleWidget(
            title: 'Male',
            value: 'male',
            selectedValue: gender,
            onChanged: onChanged,
          ),
          GenderRadioTitleWidget(
            title: 'Female',
            value: 'female',
            selectedValue: gender,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
