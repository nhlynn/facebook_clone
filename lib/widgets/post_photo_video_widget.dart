import '../widgets/network_video_widget.dart';
import 'package:flutter/material.dart';

class PostPhotoVideoWidget extends StatelessWidget {
  const PostPhotoVideoWidget({
    super.key,
    required this.fileType,
    required this.fileUrl,
  });

  final String fileType;
  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    if (fileType == 'image') {
      return Image.network(fileUrl);
    } else {
      return NetworkVideoWidget(
        videoUrl: fileUrl,
      );
    }
  }
}
