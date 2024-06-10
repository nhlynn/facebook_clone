import 'dart:io';
import '../widgets/video_view_widget.dart';
import 'package:flutter/material.dart';

class ImageVideoViewWidget extends StatelessWidget {
  const ImageVideoViewWidget({
    super.key,
    required this.fileType,
    required this.file,
  });

  final String fileType;
  final File file;

  @override
  Widget build(BuildContext context) {
    if (fileType == 'image') {
      return Image.file(file);
    } else {
      return VideoViewWidget(
        video: file,
      );
    }
  }
}
