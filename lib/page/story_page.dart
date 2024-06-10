import '../page/story_detail_page.dart';
import '../providers/all_story_provider.dart';
import '../widgets/add_story_button_widget.dart';
import '../widgets/story_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';

class StoryPage extends ConsumerWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyData = ref.watch(getAllStoriesProvider);

    return storyData.when(
      data: (stories) {
        return SliverToBoxAdapter(
          child: Container(
            height: 200,
            color: AppColors.realWhiteColor,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const AddStoryButtonWidget();
                }

                final story = stories.elementAt(index - 1);

                return InkWell(
                  onTap: () {
                    context.push(StoryDetailPage.routeName,
                        extra: stories.toList());
                  },
                  child: StoryItemWidget(
                    imageUrl: story.imageUrl,
                  ),
                );
              },
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(
          child: Text(error.toString()),
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
