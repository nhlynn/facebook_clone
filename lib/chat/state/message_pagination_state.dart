import 'package:cloud_firestore/cloud_firestore.dart';

class MessagePaginationState {
  final List<QueryDocumentSnapshot> documents;
  final bool hasMore;
  final bool isLoading;
  final String chatRoomId;

  MessagePaginationState({
    required this.documents,
    required this.hasMore,
    required this.isLoading,
    required this.chatRoomId,
  });

  MessagePaginationState copyWith({
    List<QueryDocumentSnapshot>? documents,
    bool? hasMore,
    bool? isLoading,
    String? chatRoomId,
  }) {
    return MessagePaginationState(
      documents: documents ?? this.documents,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }
}
