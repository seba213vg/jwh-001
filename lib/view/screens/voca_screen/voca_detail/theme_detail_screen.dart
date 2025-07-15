import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwh_01/view/widgets/category_voca.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ThemeDetailScreen extends StatelessWidget {
  const ThemeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wordQuery =
        FirebaseFirestore.instance
            .collection('words')
            .doc('theme')
            .collection('theme')
            .snapshots();
    return Scaffold(
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
              return CategoryVoca(data: data);
            },
          );
        },
      ),
    );
  }
}
