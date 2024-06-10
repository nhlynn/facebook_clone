import '../repositorys/friend_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_vo.dart';

class AddFriendButtonWidget extends ConsumerStatefulWidget {
  const AddFriendButtonWidget({
    super.key,
    required this.user,
  });

  final UserVO user;

  @override
  ConsumerState<AddFriendButtonWidget> createState() =>
      _AddFriendButtonWidgetState();
}

class _AddFriendButtonWidgetState extends ConsumerState<AddFriendButtonWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final requestSent = widget.user.receivedRequests.contains(myUid);
    final requestReceived = widget.user.sentRequests.contains(myUid);
    final alreadyFriend = widget.user.friends.contains(myUid);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : FilledButton(
            onPressed: requestReceived
                ? null
                : () async {
                    setState(() => isLoading = true);
                    final provider = ref.read(friendRepositoryProvider);
                    final userId = widget.user.uid;
                    if (requestSent) {
                      // cancel request
                      await provider.removeFriendRequest(
                          userId: userId, myId: myUid);
                    } else if (alreadyFriend) {
                      // remove friendship
                      await provider.removeFriend(userId: userId, myId: myUid);
                    } else {
                      // sent friend request
                      await provider.sendFriendRequest(
                          userId: userId, myId: myUid);
                    }
                    setState(() => isLoading = false);
                  },
            child: Text(requestSent
                ? 'Cancel Request'
                : alreadyFriend
                    ? 'Remove Friend'
                    : 'Add Friend'),
          );
  }
}
