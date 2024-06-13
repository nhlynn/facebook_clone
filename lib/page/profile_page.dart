import '../chat/presentation/view/chat_screen.dart';
import '../page/create_story_page.dart';
import 'package:go_router/go_router.dart';

import '../models/user_vo.dart';
import '../page/error_page.dart';
import '../page/post_page.dart';
import '../utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_info_by_id_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/add_friend_button_widget.dart';
import '../widgets/icon_text_button.dart';

class ProfilePage extends ConsumerWidget {
  static const routeName = '/profile';

  const ProfilePage({
    super.key,
    this.userId,
  });

  final String? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final uid = userId ?? myUid;
    final userInfo = ref.watch(getUserInfoAsStreamByIdProvider(uid));

    return userInfo.when(
      data: (user) {
        return SafeArea(
          child: Scaffold(
            appBar: userId != null
                ? AppBar(
                    title: const Text('Profile Screen'),
                  )
                : null,
            backgroundColor: AppColors.whiteColor,
            body: Padding(
                padding: Constants.defaultPadding,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildUserData(user, myUid, context),
                    ),
                    PostListWidget(
                      myUid: uid,
                    ),
                  ],
                )),
          ),
        );
      },
      error: (error, stackTrace) {
        return ErrorPage(errorMessage: error.toString());
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  _buildUserData(
    UserVO user,
    String myUid,
    BuildContext context,
  ) =>
      Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.profilePicUrl),
          ),
          const SizedBox(height: 10),
          Text(
            user.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 20),
          (userId == myUid || userId == null)
              ? _buildAddToStoryButton(context)
              : AddFriendButtonWidget(
                  user: user,
                ),
          const SizedBox(height: 10),
          (userId == myUid || userId == null)
              ? Container()
              : OutlinedButton(
                  onPressed: () {
                    context.push(ChatScreen.routeName,extra: userId);
                  },
                  child: const Text('Send Message'),
                ),
          const SizedBox(height: 20),
          _buildProfileInfo(
            email: user.email,
            gender: user.gender,
            birthday: user.birthDay,
          ),
          const SizedBox(height: 20),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          const Center(
            child: Text(
              'Posts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      );

  _buildAddToStoryButton(BuildContext context) => FilledButton(
        onPressed: () {
          context.push(CreateStoryPage.routeName);
        },
        child: const Text('Add to story'),
      );

  _buildProfileInfo({
    required String email,
    required String gender,
    required DateTime birthday,
  }) =>
      Column(
        children: [
          IconTextButton(
            icon: gender == 'male' ? Icons.male : Icons.female,
            label: gender,
          ),
          const SizedBox(height: 10),
          IconTextButton(
            icon: Icons.cake,
            label: birthday.yMMMEd(),
          ),
          const SizedBox(height: 10),
          IconTextButton(
            icon: Icons.email,
            label: email,
          ),
        ],
      );
}
