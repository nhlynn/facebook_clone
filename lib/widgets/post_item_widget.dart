import '../controllers/post_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/icon_text_button.dart';
import '../widgets/post_info_widget.dart';
import '../widgets/post_photo_video_widget.dart';
import '../widgets/rounded_like_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../models/post_vo.dart';
import '../page/comment_page.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({super.key, required this.post});

  final PostVO post;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostInfoWidget(
            pushedDate: post.createdAt,
            userId: post.posterId,
          ),
          // Post Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(post.content),
          ),
          // Post Video / Image
          PostPhotoVideoWidget(
            fileUrl: post.fileUrl,
            fileType: post.postType,
          ),
          // Post Stats and Buttons
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            child: Column(
              children: [
                // Post stats
                PostStats(
                  likes: post.likes,
                ),
                const Divider(),
                // Post Buttons
                PostButtons(post: post),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PostButtons extends ConsumerWidget {
  const PostButtons({
    super.key,
    required this.post,
  });

  final PostVO post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = post.likes.contains(FirebaseAuth.instance.currentUser!.uid);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconTextButton(
          icon: isLiked
              ? FontAwesomeIcons.solidThumbsUp
              : FontAwesomeIcons.thumbsUp,
          color: isLiked ? AppColors.blueColor : AppColors.blackColor,
          label: 'Like',
          onPressed: () {
            ref
                .read(postControllerProvider.notifier)
                .likeDislikePost(postId: post.postId, likes: post.likes);
          },
        ),
        IconTextButton(
          icon: FontAwesomeIcons.solidMessage,
          label: 'Comment',
          onPressed: () {
            context.push(CommentPage.routeName, extra: post.postId);
          },
        ),
        const IconTextButton(
          icon: FontAwesomeIcons.share,
          label: 'Share',
        ),
      ],
    );
  }
}

class PostStats extends StatelessWidget {
  const PostStats({
    super.key,
    required this.likes,
  });

  final List<String> likes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const RoundLikeIcon(),
        const SizedBox(width: 5),
        Text('${likes.length}'),
      ],
    );
  }
}
