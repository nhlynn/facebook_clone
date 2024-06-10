import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firebase_collection_names.dart';

import '../models/user_vo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/firebase_field_names.dart';

final userInfoByIdProvider =
    FutureProvider.autoDispose.family<UserVO, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .doc(userId)
      .get()
      .then((response) {
    return UserVO.fromMap(response.data()!);
  });
});

final getUserInfoAsStreamByIdProvider =
    StreamProvider.autoDispose.family<UserVO, String>((ref, String userId) {
  final controller = StreamController<UserVO>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .where(FirebaseFieldNames.uid, isEqualTo: userId)
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    final userData = snapshot.docs.first;
    final user = UserVO.fromMap(userData.data());
    controller.sink.add(user);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});
