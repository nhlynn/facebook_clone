import '../repositorys/post_repository.dart';
import '../utils/extensions.dart';
import '../widgets/round_profile_tile.dart';
import '../widgets/rounded_like_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_vo.dart';
import '../page/error_page.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';

class CommentItemWidget extends StatelessWidget {
  const CommentItemWidget({
    super.key,
    required this.comment,
  });

  final CommentVO comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Comment header
          CommentHeader(
            comment: comment,
          ),

          // Comment Footer
          CommentFooter(
            comment: comment,
          ),
        ],
      ),
    );
  }
}

class CommentHeader extends ConsumerWidget {
  const CommentHeader({
    super.key,
    required this.comment,
  });

  final CommentVO comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo =
        ref.read(authProvider).getUserInfo(userId: comment.authorId);

    return FutureBuilder(
      future: userInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final user = snapshot.data;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundProfileTile(url: user!.profilePicUrl),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(comment.text),
                    ],
                  ),
                ),
              )
            ],
          );
        }

        return ErrorPage(
          errorMessage: snapshot.error.toString(),
        );
      },
    );
  }
}

class CommentFooter extends StatelessWidget {
  const CommentFooter({
    super.key,
    required this.comment,
  });

  final CommentVO comment;

  @override
  Widget build(BuildContext context) {
    final isLiked =
        comment.likes.contains(FirebaseAuth.instance.currentUser!.uid);

    return Consumer(
      builder: (context, ref, child) {
        return Row(
          children: [
            Text(
              comment.createdAt.fromNow(),
            ),
            TextButton(
              onPressed: () {
                ref.read(postRepositoryProvider).likeDislikeComment(
                      commentId: comment.commentId,
                      likes: comment.likes,
                    );
              },
              child: Text(
                'like',
                style: TextStyle(
                  color:
                      isLiked ? AppColors.blueColor : AppColors.darkGreyColor,
                ),
              ),
            ),
            const SizedBox(width: 15),
            const RoundLikeIcon(),
            const SizedBox(width: 5),
            Text(comment.likes.length.toString()),
          ],
        );
      },
    );
  }
}
