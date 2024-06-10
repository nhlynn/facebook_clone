import '../widgets/friend_request_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/friend_list_widget.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class FriendPage extends ConsumerWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: Constants.defaultPadding,
        child: CustomScrollView(
          slivers: [
            FriendRequestListWidget(),
            FriendListWidget(),
          ],
        ),
      ),
    );
  }
}
