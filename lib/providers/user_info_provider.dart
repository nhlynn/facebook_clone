import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firebase_collection_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_vo.dart';

final userInfoProvider = FutureProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((response) {
    return UserVO.fromMap(response.data()!);
  });
});
