import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/utils.dart';
import '../../repository/chat_repository.dart';
import '../widget/chat_user_info.dart';
import '../widget/message_list.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  static const routeName = '/chat-screen';

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController messageController;
  late final String chatroomId;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myId = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder(
      future: ref
          .watch(chatProvider)
          .createChatroom(userId: widget.userId, myUid: myId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        chatroomId = snapshot.data ?? 'No chatroom Id';

        return Scaffold(
          backgroundColor: AppColors.realWhiteColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.messengerBlue,
              ),
            ),
            titleSpacing: 0,
            title: ChatUserInfo(
              userId: widget.userId,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: MessagesList(
                  chatroomId: chatroomId,
                ),
              ),
              const Divider(),
              _buildMessageInput(myId),
            ],
          ),
        );
      },
    );
  }

// Chat Text Field
  Widget _buildMessageInput(String myId) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.image,
              color: AppColors.messengerDarkGrey,
            ),
            onPressed: () async {
              final image = await pickImage();
              if (image == null) return;
              await ref.read(chatProvider).sendFileMessage(
                    file: File(image.path),
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    messageType: 'image',
                    myUid: myId,
                  );
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.video,
              color: AppColors.messengerDarkGrey,
              size: 20,
            ),
            onPressed: () async {
              final video = await pickVideo();
              if (video == null) return;
              await ref.read(chatProvider).sendFileMessage(
                    file: video,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    messageType: 'video',
                    myUid: myId,
                  );
            },
          ),
          // Text Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.messengerGrey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Aa',
                  hintStyle: TextStyle(),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: AppColors.messengerBlue,
            ),
            onPressed: () async {
              // Add functionality to handle send button press
              await ref.read(chatProvider).sendMessage(
                    message: messageController.text,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    myUid: myId,
                  );
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
