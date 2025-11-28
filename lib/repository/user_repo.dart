import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jwh_01/model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<bool> deleteAccountAndData() async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'deleteUserDataAndAccount', // TypeScript Function 이름
      );

      final HttpsCallableResult result = await callable.call();

      if (result.data['success']) {
        print('계정 및 데이터 삭제 성공');
        return true;
        // 앱에서 로그아웃 및 로그인 화면으로 이동
      }
    } on FirebaseFunctionsException catch (e) {
      print('함수 호출 실패: ${e.message}');
    }
    return false;
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<String> uploadProfilePic(File file, String filename) async {
    final fileRef = _storage.ref().child("avatars/$filename");
    final uploadTask = await fileRef.putFile(file);
    final snapshot = uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  Future updateProfileUrl(String uid, String downloadUrl) async {
    await _db.collection('users').doc(uid).update({'photoUrl': downloadUrl});
  }
}

final userRepoProvider = Provider((ref) => UserRepository());
