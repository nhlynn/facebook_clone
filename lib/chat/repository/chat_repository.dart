import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../utils/firebase_collection_names.dart';
import '../../utils/firebase_field_names.dart';
import '../model/chat_room.dart';
import '../model/message.dart';

final chatProvider = StateProvider((ref) {
  return ChatRepository();
});

class ChatRepository {
  final _storage = FirebaseStorage.instance;

  Future<String> createChatroom({
    required String userId,
    required String myUid,
  }) async {
    try {
      CollectionReference chatrooms = FirebaseFirestore.instance.collection(
        FirebaseCollectionNames.chatrooms,
      );

      // sorted members
      final sortedMembers = [myUid, userId]..sort((a, b) => a.compareTo(b));

      // existing chatrooms
      QuerySnapshot existingChatrooms = await chatrooms
          .where(
            FirebaseFieldNames.members,
            isEqualTo: sortedMembers,
          )
          .get();

      if (existingChatrooms.docs.isNotEmpty) {
        return existingChatrooms.docs.first.id;
      } else {
        final chatroomId = const Uuid().v1();
        final now = DateTime.now();

        ChatRoom chatroom = ChatRoom(
          chatroomId: chatroomId,
          lastMessage: '',
          lastMessageTs: now,
          members: sortedMembers,
          createdAt: now,
        );

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionNames.chatrooms)
            .doc(chatroomId)
            .set(chatroom.toMap());

        return chatroomId;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Send message
  Future<String?> sendMessage({
    required String message,
    required String chatroomId,
    required String receiverId,
    required String myUid,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      Message newMessage = Message(
        message: message,
        messageId: messageId,
        senderId: myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: 'text',
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: message,
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

// Send message
  Future<String?> sendFileMessage({
    required File file,
    required String chatroomId,
    required String receiverId,
    required String messageType,
    required String myUid,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      // Save to storage
      Reference ref = _storage.ref(messageType).child(messageId);
      TaskSnapshot snapshot = await ref.putFile(file);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      Message newMessage = Message(
        message: downloadUrl,
        messageId: messageId,
        senderId: myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: messageType,
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: 'send a $messageType',
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId)
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .update({
        FirebaseFieldNames.seen: true,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<QueryDocumentSnapshot>> getMessage({
    DocumentSnapshot? startAfter,
    required String chatroomId,
  }) async {
    Query query = FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.chatrooms)
        .doc(chatroomId)
        .collection(FirebaseCollectionNames.messages)
        .limit(20)
        .orderBy(FirebaseFieldNames.timestamp, descending: true);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs;
  }
}
