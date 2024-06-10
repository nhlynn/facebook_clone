import 'dart:io';

import '../repositorys/post_repository.dart';
import '../utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/post_state.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, PostState>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return PostController(postRepository: repository);
});

class PostController extends StateNotifier<PostState> {
  final PostRepository _postRepository;

  void isPosted() {
    state = state.copyWith(isPosted: false);
  }

  PostController({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(PostState.initial());

  void createPost({
    required String content,
    required File? file,
    required String postType,
  }) async {
    if (state.loading) {
      return;
    }

    if (file == null) {
      showToastMessage(text: 'Please choose video or photo');
      return;
    }

    state = state.copyWith(loading: true);

    final response = await _postRepository.createPost(
        content: content, file: file, postType: postType);

    if (response == null) {
      state = state.copyWith(isPosted: true);
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      state = state.copyWith(message: response);
    }
  }

  void likeDislikePost({
    required String postId,
    required List<String> likes,
  }) async {
    if (state.loading) {
      return;
    }
    state = state.copyWith(loading: true);

    final response =
        await _postRepository.likeDislikePost(postId: postId, likes: likes);

    if (response == null) {
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      state = state.copyWith(message: response);
    }
  }

  void createComment({
    required String text,
    required String postId,
  }) async {
    if (state.loading) {
      return;
    }

    state = state.copyWith(loading: true);

    final response =
        await _postRepository.createComment(text: text, postId: postId);

    if (response == null) {
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      state = state.copyWith(message: response);
    }
  }

  void likeDislikeComment({
    required String commentId,
    required List<String> likes,
  }) async {
    if (state.loading) {
      return;
    }
    state = state.copyWith(loading: true);

    final response = await _postRepository.likeDislikeComment(
        commentId: commentId, likes: likes);

    if (response == null) {
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      state = state.copyWith(message: response);
    }
  }
}
