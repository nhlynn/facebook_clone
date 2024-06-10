import '../repositorys/friend_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../page/error_page.dart';
import '../page/profile_page.dart';
import '../providers/user_info_by_id_provider.dart';

class FriendRequestItemWidget extends ConsumerWidget {
  const FriendRequestItemWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(getUserInfoAsStreamByIdProvider(userId));
    final myId = FirebaseAuth.instance.currentUser!.uid;

    return userData.when(
      data: (user) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    context.push(ProfilePage.routeName, extra: user.uid);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.profilePicUrl),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              debugPrint(
                                  "My Current Id is ${FirebaseAuth.instance.currentUser!.uid}");
                              ref
                                  .read(friendRepositoryProvider)
                                  .acceptFriendRequest(
                                      userId: userId, myId: myId);
                            },
                            child: const Text('Accept'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              ref
                                  .read(friendRepositoryProvider)
                                  .removeFriendRequest(
                                      userId: userId, myId: myId);
                            },
                            child: const Text('Reject'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return ErrorPage(errorMessage: error.toString());
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
