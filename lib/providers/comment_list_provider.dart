import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_vo.dart';
import '../utils/firebase_collection_names.dart';
import '../utils/firebase_field_names.dart';

final getAllCommentsProvider = StreamProvider.autoDispose
    .family<Iterable<CommentVO>, String>((ref, String postId) {
  final controller = StreamController<Iterable<CommentVO>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.comments)
      .where(FirebaseFieldNames.postId, isEqualTo: postId)
      .orderBy(FirebaseFieldNames.createdAt, descending: true)
      .snapshots()
      .listen((snapshot) {
    final comments = snapshot.docs.map(
      (commentData) => CommentVO.fromMap(
        commentData.data(),
      ),
    );
    controller.sink.add(comments);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
