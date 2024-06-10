import '../widgets/friend_request_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../page/error_page.dart';
import '../providers/all_friend_request_provider.dart';

class FriendRequestListWidget extends ConsumerStatefulWidget {
  const FriendRequestListWidget({super.key});

  @override
  ConsumerState<FriendRequestListWidget> createState() =>
      _FriendRequestListWidgetState();
}

class _FriendRequestListWidgetState
    extends ConsumerState<FriendRequestListWidget> {
  @override
  Widget build(BuildContext context) {
    final requestList = ref.watch(getAllFriendRequestsProvider);

    return requestList.when(
      data: (requests) {
        if (requests.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(),
          );
        }
        return SliverList.builder(
          itemCount: requests.length + 2,
          itemBuilder: (context, index) {
            debugPrint('Current Index is $index');
            if (index == 0) {
              return const Text(
                'Friend Requests',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              );
            }

            if (index <= requests.length) {
              final userId = requests.elementAt(index - 1);
              debugPrint('Current Index is $userId');
              return FriendRequestItemWidget(
                userId: userId,
              );
            }
            return const Divider(
              height: 50,
              thickness: 0.5,
              color: Colors.grey,
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
