import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/firebase_collection_names.dart';
import '../utils/storage_folder_names.dart';
import '../models/user_vo.dart';
import '../utils/utils.dart';

final authRepositoryProvider = StateProvider((ref) {
  return AuthRepository();
});

class AuthRepository {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } catch (e) {
      showToastMessage(text: e.toString().split(']')[1]);
      return null;
    }
  }

  Future<String?> singOut() async {
    try {
      auth.signOut();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserCredential?> createAccount({
    required String fullName,
    required DateTime birthday,
    required String gender,
    required String email,
    required String password,
    required File? image,
  }) async {
    try {
      // create an account in firebase
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save image to firebase storage
      final path = storage
          .ref(StorageFolderNames.profilePics)
          .child(FirebaseAuth.instance.currentUser!.uid);

      if (image == null) {
        return null;
      }

      final taskSnapshot = await path.putFile(image);
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      UserVO user = UserVO(
        fullName: fullName,
        birthDay: birthday,
        gender: gender,
        email: email,
        password: password,
        profilePicUrl: downloadUrl,
        uid: FirebaseAuth.instance.currentUser!.uid,
        friends: const [],
        sentRequests: const [],
        receivedRequests: const [],
      );

      // save user to firestore
      await firestore
          .collection(FirebaseCollectionNames.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
            user.toMap(),
          );

      return credential;
    } catch (e) {
      showToastMessage(text: e.toString().split(']')[1]);
      return null;
    }
  }

  Future<String?> verifyEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        user.sendEmailVerification();
      }
      return null;
    } catch (e) {
      showToastMessage(text: e.toString().split(']')[0]);
      return e.toString();
    }
  }

  Future<UserVO> getUserInfo({String userId = ''}) async {
    final uId = userId == '' ? FirebaseAuth.instance.currentUser?.uid : userId;
    final userData = await firestore
        .collection(FirebaseCollectionNames.users)
        .doc(uId)
        .get();
    final user = UserVO.fromMap(userData.data()!);
    return user;
  }
}
