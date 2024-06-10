import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/firebase_collection_names.dart';
import '../utils/firebase_field_names.dart';

final friendRepositoryProvider = StateProvider((ref) {
  return FriendRepository();
});

class FriendRepository {
  final _firestore = FirebaseFirestore.instance;

  // Send friend request
  Future<String?> sendFriendRequest({
    required String userId,
    required String myId,
  }) async {
    try {
      // Add my uid to other person's received requests
      _firestore.collection(FirebaseCollectionNames.users).doc(userId).update({
        FirebaseFieldNames.receivedRequests: FieldValue.arrayUnion(
          [myId],
        ),
      });

      // Add other person's uid inside my own sent requests
      _firestore.collection(FirebaseCollectionNames.users).doc(myId).update({
        FirebaseFieldNames.sentRequests: FieldValue.arrayUnion(
          [userId],
        ),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Accept friend request
  Future<String?> acceptFriendRequest({
    required String userId,
    required String myId,
  }) async {
    try {
      // add your uid inside other person's friend list
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(userId)
          .update({
        FirebaseFieldNames.friends: FieldValue.arrayUnion([myId])
      });

      // add other person's id inside your own friends list
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(myId)
          .update({
        FirebaseFieldNames.friends: FieldValue.arrayUnion([userId])
      });

      // remove sent and received friend requests
      removeFriendRequest(userId: userId, myId: myId);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> removeFriendRequest({
    required String userId,
    required String myId,
  }) async {
    try {
      // Add my uid to other person's received requests
      _firestore.collection(FirebaseCollectionNames.users).doc(userId).update({
        FirebaseFieldNames.receivedRequests: FieldValue.arrayRemove([myId]),
        FirebaseFieldNames.sentRequests: FieldValue.arrayRemove([myId]),
      });

      // Add other person's uid inside my own sent requests
      _firestore.collection(FirebaseCollectionNames.users).doc(myId).update({
        FirebaseFieldNames.sentRequests: FieldValue.arrayRemove([userId]),
        FirebaseFieldNames.receivedRequests: FieldValue.arrayRemove([userId]),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Accept friend request
  Future<String?> removeFriend({
    required String userId,
    required String myId,
  }) async {
    try {
      // add your uid inside other person's friend list
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(userId)
          .update({
        FirebaseFieldNames.friends: FieldValue.arrayRemove([myId])
      });

      // add other person's id inside your own friends list
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(myId)
          .update({
        FirebaseFieldNames.friends: FieldValue.arrayRemove([userId])
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
