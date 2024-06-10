import 'dart:io';

import '../repositorys/story_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils.dart';
import 'error_page.dart';

class CreateStoryPage extends ConsumerStatefulWidget {
  const CreateStoryPage({super.key});

  static const routeName = '/create-story';

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage> {
  Future<XFile?>? imageFuture;

  bool isLoading = false;

  @override
  void initState() {
    imageFuture = pickImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data != null) {
            return Scaffold(
              body: Stack(
                children: [
                  Center(
                    child: Image.file(File(snapshot.data!.path)),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 50,
                    right: 50,
                    child: isLoading
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : FilledButton(
                      onPressed: () async {
                        setState(() => isLoading = true);
                        await ref
                            .read(storyRepositoryProvider)
                            .postStory(
                            image: File(snapshot.data!.path),
                            myUid: myUid)
                            .then((value) {
                          setState(() => isLoading = false);

                          WidgetsBinding.instance.addPostFrameCallback((timestamp) {
                            context.pop(true);
                          });
                        }).onError((error, stackTrace) {
                          setState(() => isLoading = false);
                        });
                      },
                      child: const Text('Post Story'),
                    ),
                  ),
                ],
              ),
            );
          }

          return const ErrorPage(errorMessage: 'Image Not Found');
        },
      ),
    );
  }
}
