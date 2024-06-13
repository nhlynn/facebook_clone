import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/post_photo_video_widget.dart';
import '../../model/message.dart';

class MessageContents extends StatelessWidget {
  const MessageContents({
    super.key,
    required this.message,
    this.isSentMessage = false,
  });

  final Message message;
  final bool isSentMessage;

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'text') {
      return Text(
        message.message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isSentMessage ? AppColors.whiteColor : AppColors.blackColor,
        ),
      );
    } else {
      return PostPhotoVideoWidget(
        fileUrl: message.message,
        fileType: message.messageType,
      );
    }
  }
}
