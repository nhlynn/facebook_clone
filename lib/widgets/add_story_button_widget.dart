import '../page/create_story_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';

class AddStoryButtonWidget extends StatelessWidget {
  const AddStoryButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            context.push(CreateStoryPage.routeName);
          },
          child: Container(
            color: AppColors.darkWhiteColor,
            height: 180,
            width: 100,
            child: Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.network(
                    Constants.profilePicBlank,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const Positioned(
                  top: 100,
                  left: 10,
                  right: 10,
                  child: CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.add),
                  ),
                ),
                const Positioned(
                  left: 10,
                  right: 10,
                  bottom: 5,
                  child: Column(
                    children: [
                      Text('Create'),
                      Text('Story'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
