import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../page/error_page.dart';
import '../../../providers/user_info_by_id_provider.dart';
import '../../../utils/app_colors.dart';

class ChatUserInfo extends ConsumerWidget {
  const ChatUserInfo({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoByIdProvider(userId),
    );

    return userInfo.when(
      data: (user) {
        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.profilePicUrl),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                const Text(
                  'Messenger',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.greyColor,
                  ),
                )
              ],
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        return ErrorPage(errorMessage: error.toString());
      },
      loading: () {
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}