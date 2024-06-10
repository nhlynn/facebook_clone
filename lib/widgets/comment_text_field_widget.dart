import '../controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_colors.dart';

class CommentTextFieldWidget extends ConsumerStatefulWidget {
  const CommentTextFieldWidget({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentTextFieldWidgetState();
}

class _CommentTextFieldWidgetState extends ConsumerState<CommentTextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> makeComment() async {
    final text = controller.text.trim();
    ref.read(postControllerProvider.notifier).createComment(
      text: text,
      postId: widget.postId,
    );
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.only(
          left: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Write your comment',
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: makeComment,
              icon: const Icon(Icons.send),
            ),
          ),
        ),
      ),
    );
  }
}