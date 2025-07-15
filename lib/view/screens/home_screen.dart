import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/view/widgets/word_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  AuthRepository authRepo = AuthRepository();
  String userId = '';

  @override
  Widget build(BuildContext context) {
    if (authRepo.isLoggedIn) {
      userId = authRepo.user!.uid;
    }

    final wordQuery =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('bookmarks')
            .snapshots();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("오미즈 구다사이")),
      body: StreamBuilder(
        stream: wordQuery,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text('데이터가 없습니다.', style: TextStyle(fontSize: 25.sp)),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final doc = docs[index];
              final docId = doc.id;
              return WordTile(data: data, docId: docId);
            },
          );
        },
      ),
    );
  }
}
