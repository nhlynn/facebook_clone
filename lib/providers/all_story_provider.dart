import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/user_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/stroy.dart';
import '../utils/firebase_collection_names.dart';
import '../utils/firebase_field_names.dart';

final getAllStoriesProvider =
    StreamProvider.autoDispose<Iterable<Story>>((ref) {
  final controller = StreamController<Iterable<Story>>();
  final userData = ref.watch(userInfoProvider);

  userData.whenData((user) {
    final myFriends = [
      user.uid,
      ...user.friends,
    ];

    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.stories)
        .orderBy(FirebaseFieldNames.createdAt, descending: true)
        .where(FirebaseFieldNames.createdAt,
            isGreaterThan: yesterday.millisecondsSinceEpoch)
        .where(FirebaseFieldNames.authorId, whereIn: myFriends)
        .snapshots()
        .listen((snapshot) {
      final stories = snapshot.docs.map(
        (storyData) => Story.fromMap(
          storyData.data(),
        ),
      );
      controller.sink.add(stories);
    });

    ref.onDispose(() {
      controller.close();
      sub.cancel();
    });
  });

  return controller.stream;
});
