import '../page/error_page.dart';
import '../page/story_page.dart';
import '../providers/post_list_provider.dart';
import '../widgets/post_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/feed_make_post_widget.dart';

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CustomScrollView(
      slivers: [
        StoryPage(),
        FeedMakePostWidget(),
        PostListWidget(),
      ],
    );
  }
}

class PostListWidget extends ConsumerWidget {
  const PostListWidget({super.key, this.myUid});

  final String? myUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postList = myUid != null
        ? ref.watch(getAllPostsByUserProvider(myUid!))
        : ref.watch(getAllPostsProvider);

    return postList.when(
      data: (posts) {
        return SliverList.separated(
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
        return SliverToBoxAdapter(
          child: ErrorPage(errorMessage: error.toString()),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
