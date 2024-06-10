import '../providers/all_friend_provider.dart';
import '../widgets/friend_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../page/error_page.dart';

class FriendListWidget extends ConsumerStatefulWidget {
  const FriendListWidget({super.key});

  @override
  ConsumerState<FriendListWidget> createState() => _FriendListWidgetState();
}

class _FriendListWidgetState extends ConsumerState<FriendListWidget> {
  @override
  Widget build(BuildContext context) {
    final friendsList = ref.watch(getAllFriendsProvider);

    return friendsList.when(
      data: (friends) {
        return friends.isEmpty
            ? SliverToBoxAdapter(
                child: Container(),
              )
            : SliverList.builder(
                itemCount: friends.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Text(
                      'Friends',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    );
                  }
                  final userId = friends.elementAt(index - 1);
                  return FriendItemWidget(
                    userId: userId,
                  );
                },
              );
      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(
          child: ErrorPage(errorMessage: error.toString()),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
