import 'dart:io';

import '../controllers/post_controller.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/image_video_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/utils.dart';
import '../widgets/profile_info_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  static const routeName = '/create_post';

  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  late final TextEditingController _postController;
  File? file;
  String fileType = 'image';

  @override
  void initState() {
    _postController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> createPost() async {
    ref.read(postControllerProvider.notifier).createPost(
        content: _postController.text, file: file, postType: fileType);
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postControllerProvider);

    if (postState.isPosted) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        context.pop(true);
      });
    }

    debugPrint("Response is Hello");
    return Scaffold(
      backgroundColor: AppColors.realWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        actions: [
          TextButton(
            onPressed: createPost,
            child: const Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Constants.defaultPadding,
          child: Column(
            children: [
              const ProfileInfoWidget(),
              TextField(
                controller: _postController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'What\'s on your mind?',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: AppColors.darkGreyColor,
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              file != null
                  ? ImageVideoViewWidget(
                      file: file!,
                      fileType: fileType,
                    )
                  : PickFileWidget(
                      pickImage: () async {
                        fileType = 'image';
                        final pickFile = await pickImage();
                        file = pickFile != null ? File(pickFile.path) : null;
                        setState(() {});
                      },
                      pickVideo: () async {
                        fileType = 'video';
                        file = await pickVideo();
                        setState(() {});
                      },
                    ),
              const SizedBox(height: 20),
              postState.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: createPost,
                        child: const Text('Post'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class PickFileWidget extends StatelessWidget {
  const PickFileWidget({
    super.key,
    required this.pickImage,
    required this.pickVideo,
  });

  final VoidCallback pickImage;
  final VoidCallback pickVideo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: pickImage,
          child: const Text('Pick Image'),
        ),
        const Divider(),
        TextButton(
          onPressed: pickVideo,
          child: const Text('Pick Video'),
        ),
      ],
    );
  }
}
