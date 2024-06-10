import '../page/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/comment_list_provider.dart';
import '../widgets/comment_item_widget.dart';
import '../widgets/comment_text_field_widget.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({
    super.key,
    required this.postId,
  });

  final String postId;

  static const routeName = '/comments';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          // Comments List
          CommentListWidget(postId: postId),

          // Comment Text field
          CommentTextFieldWidget(
            postId: postId,
          ),
        ],
      ),
    );
  }
}

class CommentListWidget extends ConsumerWidget {
  const CommentListWidget({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(getAllCommentsProvider(postId));
    return Expanded(
      child: comments.when(
        data: (commentsList) {
          return ListView.builder(
            itemCount: commentsList.length,
            itemBuilder: (context, index) {
              final comment = commentsList.elementAt(index);
              return CommentItemWidget(
                comment: comment,
              );
            },
          );
        },
        error: (error, stackTrace) {
          return ErrorPage(errorMessage: error.toString());
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
