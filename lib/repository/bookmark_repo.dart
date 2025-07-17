import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addBookmark(Map<String, dynamic> data, String userId) async {
    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(data['title']);

    // 문서가 이미 존재하는지 확인
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      if (docSnapshot['title'] == data['title']) {
        // 이미 존재하는 경우 createdAt만 업데이트
        await docRef.update({'createdAt': FieldValue.serverTimestamp()});
      }
    } else {
      // 존재하지 않는 경우 새로 생성
      await docRef.set({...data, 'createdAt': FieldValue.serverTimestamp()});
    }
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
