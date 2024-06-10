import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_vo.dart';
import '../utils/firebase_collection_names.dart';
import '../utils/firebase_field_names.dart';

final getAllPostsProvider = StreamProvider.autoDispose<Iterable<PostVO>>((ref) {
  final controller = StreamController<Iterable<PostVO>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.posts)
      .orderBy(FirebaseFieldNames.datePublished, descending: true)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs.map(
      (postData) => PostVO.fromMap(
        postData.data(),
      ),
    );
    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

final getAllPostsByUserProvider =
    StreamProvider.autoDispose.family<Iterable<PostVO>, String>((ref, userId) {
  final controller = StreamController<Iterable<PostVO>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.posts)
      .orderBy(FirebaseFieldNames.datePublished, descending: true)
      .where(FirebaseFieldNames.posterId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs.map(
      (postData) => PostVO.fromMap(
        postData.data(),
      ),
    );
    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
