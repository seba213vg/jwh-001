import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/view/widgets/word_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VocaWordScreenforDifficulty extends ConsumerWidget {
  final String docId;
  final String title;
  final String category;

  const VocaWordScreenforDifficulty({
    required this.title,
    required this.docId,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordQuery =
        FirebaseFirestore.instance
            .collection('words')
            .doc('difficulty')
            .collection('difficulty')
            .doc(category)
            .collection(category)
            .doc(docId)
            .collection(docId)
            .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actionsPadding: EdgeInsets.only(right: 5.w),
        title: Text(title),
      ),
      body: StreamBuilder(
        stream: wordQuery,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text('데이터가 없습니다.'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return WordTile(data: data);
            },
          );
        },
      ),
    );
  }
}
