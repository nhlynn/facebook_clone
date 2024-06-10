import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/stroy.dart';
import '../utils/firebase_collection_names.dart';
import '../utils/firebase_field_names.dart';
import '../utils/storage_folder_names.dart';

final storyRepositoryProvider = StateProvider((ref) {
  return StoryRepository();
});

class StoryRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // Post STory
  Future<String?> postStory({
    required String myUid,
    required File image,
  }) async {
    try {
      final storyId = const Uuid().v1();
      final now = DateTime.now();

      // post image to storage
      Reference ref = _storage.ref(StorageFolderNames.stories).child(storyId);
      TaskSnapshot snapshot = await ref.putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Create story object
      Story story = Story(
        imageUrl: downloadUrl,
        createdAt: now,
        storyId: storyId,
        authorId: myUid,
        views: const [],
      );

      // Post story to firestore
      await _firestore
          .collection(FirebaseCollectionNames.stories)
          .doc(storyId)
          .set(
            story.toMap(),
          );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // View Story
  Future<String?> viewStory({
    required String storyId,
    required String myUid,
  }) async {
    try {
      await _firestore
          .collection(FirebaseCollectionNames.stories)
          .doc(storyId)
          .update(
        {
          FirebaseFieldNames.views: FieldValue.arrayUnion(
            [myUid],
          ),
        },
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
