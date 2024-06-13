import 'package:facebook_clone/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/message_pagination_state.dart';

class MessageController extends StateNotifier<MessagePaginationState> {
  String chatroomId;

  final ChatRepository _repository;

  MessageController(this._repository, this.chatroomId)
      : super(MessagePaginationState(
            documents: [], hasMore: true, isLoading: false, chatRoomId: ''));

  Future<void> fetchNextBatch() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final lastDocument =
          state.documents.isNotEmpty ? state.documents.last : null;
      final newDocuments = await _repository.getMessage(
        startAfter: lastDocument,
        chatroomId: chatroomId,
      );

      state = state.copyWith(
        documents: [...state.documents, ...newDocuments],
        hasMore: newDocuments.length == 20,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final paginationProvider =
    StateNotifierProvider<MessageController, MessagePaginationState>((ref) {
  final firestoreService = ref.read(chatProvider);
  return MessageController(firestoreService, ref.notifier.chatroomId);
});
