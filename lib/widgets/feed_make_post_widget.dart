import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/post_controller.dart';
import '../page/create_post_page.dart';
import '../utils/app_colors.dart';
import '../widgets/round_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';

class FeedMakePostWidget extends ConsumerWidget {
  const FeedMakePostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          ref.read(postControllerProvider.notifier).isPosted();
          context.push(CreatePostPage.routeName);
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const RoundProfileTile(
                  url: Constants.maleProfilePic,
                ),
                _buildPostTextField(),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    FontAwesomeIcons.solidImages,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildPostTextField() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.darkGreyColor),
        ),
        child: const Text('What\'s on your mind?'),
      ),
    );
  }
}
