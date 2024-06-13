import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/firebase_collection_names.dart';
import '../../utils/firebase_field_names.dart';
import '../model/chat_room.dart';

final getAllChatsProvider =
StreamProvider.autoDispose<Iterable<ChatRoom>>((ref) {
  final myUid = FirebaseAuth.instance.currentUser!.uid;

  final controller = StreamController<Iterable<ChatRoom>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.chatrooms)
      .where(FirebaseFieldNames.members, arrayContains: myUid)
      .orderBy(FirebaseFieldNames.lastMessageTs)
      .snapshots()
      .listen((snapshot) {
    final chats = snapshot.docs.map(
          (chatData) => ChatRoom.fromMap(
        chatData.data(),
      ),
    );
    controller.sink.add(chats);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});