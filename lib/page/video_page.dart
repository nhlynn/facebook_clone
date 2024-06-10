import '../page/error_page.dart';
import '../providers/video_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/post_item_widget.dart';

class VideoPage extends ConsumerWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postList = ref.watch(getAllVideosProvider);

    return postList.when(
      data: (posts) {
        return ListView.separated(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts.elementAt(index);
              return PostItemWidget(post: post);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8,
              );
            });
      },
      error: (error, trace) {
        return ErrorPage(errorMessage: error.toString());
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
