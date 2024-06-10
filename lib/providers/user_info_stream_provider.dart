import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firebase_collection_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_vo.dart';
import '../utils/firebase_field_names.dart';

final userInfoStreamProvider = StreamProvider.autoDispose((ref) {
  final controller = StreamController<UserVO>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .where(FirebaseFieldNames.uid,
          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
