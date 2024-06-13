import 'package:facebook_clone/widgets/round_icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../page/create_story_page.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/constants.dart';
import '../widget/chat_room_list.dart';
import '../widget/profile_pic.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  static const routeName = '/chats-room';

  const ChatRoomScreen({super.key});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.realWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: Constants.defaultPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // build chats app bar
                _buildChatsAppBar(),

                const SizedBox(height: 20),

                // Search widget
                _buildChatsSearchWidget(),

                const SizedBox(height: 30),

                // Chats List
                const SizedBox(
                  height: 600,
                  child: ChatRoomList(),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatsAppBar() => Row(
    children: [
      const MyProfilePic(),
      const SizedBox(width: 5),
      const Text(
        'Chats',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Spacer(),
      RoundIconButtonWidget(
        icon: FontAwesomeIcons.camera,
        onPressed: () {
          context.push(CreateStoryPage.routeName);
        },
      )
    ],
  );

  Widget _buildChatsSearchWidget() => Container(
    decoration: BoxDecoration(
      color: AppColors.greyColor.withOpacity(.5),
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 15),
        Icon(Icons.search),
        SizedBox(width: 15),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(),
            ),
          ),
        ),
      ],
    ),
  );
}