import 'package:firebase_auth/firebase_auth.dart';

import '../providers/controller_provider.dart';
import '../utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../page/profile_page.dart';
import '../providers/auth_provider.dart';

class PostInfoWidget extends ConsumerWidget {
  const PostInfoWidget(
      {super.key, required this.userId, required this.pushedDate});

  final String userId;
  final DateTime pushedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.read(authProvider).getUserInfo(userId: userId);
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder(
      future: userInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final user = snapshot.data;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (myUid == user.uid) {
                      ref.read(controllerProvider.notifier).state = 3;
                    } else {
                      context.push(ProfilePage.routeName, extra: user.uid);
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user!.profilePicUrl),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      pushedDate.fromNow(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_horiz),
              ],
            ),
          );
        }

        return Text(snapshot.error.toString());
      },
    );
  }
}
