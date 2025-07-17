import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/view/widgets/word_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthRepository authRepo = AuthRepository();
  String userId = '';
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

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
            .orderBy('createdAt', descending: true)
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
            controller: _scrollController,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: FaIcon(FontAwesomeIcons.chevronUp),
      ),
    );
  }
}
