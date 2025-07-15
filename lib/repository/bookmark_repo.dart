import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addBookmark(Map<String, dynamic> data, String userId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(data['word'])
        .set({...data, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> removeBookmark(String userId, String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(docId)
        .delete();
  }
}

final bookmarkRepoProvider = Provider((ref) => BookmarkRepository());
