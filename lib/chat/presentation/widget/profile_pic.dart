
import 'package:facebook_clone/providers/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../page/error_page.dart';

class MyProfilePic extends ConsumerWidget {
  const MyProfilePic({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    return userInfo.when(
      data: (user) {
        return CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(
            user.profilePicUrl,
          ),
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