import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwh_01/view/widgets/category_voca.dart';
import 'package:jwh_01/view/widgets/category_voca_difficulty.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DifficultyCategoryScreen extends StatefulWidget {
  const DifficultyCategoryScreen({super.key, required this.myCategory});

  final String myCategory;

  @override
  State<DifficultyCategoryScreen> createState() =>
      _DifficultyCategoryScreenState();
}

class _DifficultyCategoryScreenState extends State<DifficultyCategoryScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordQuery =
        FirebaseFirestore.instance
            .collection('words')
            .doc('difficulty')
            .collection('difficulty')
            .doc(widget.myCategory)
            .collection(widget.myCategory)
            .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actionsPadding: EdgeInsets.only(right: 5.w),
        title: Text(widget.myCategory),
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
          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.0,
                crossAxisSpacing: 5.w,
                mainAxisSpacing: 2.h,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                final String docId = doc.id;
                final data = docs[index].data();

                return CategoryVocaDifficulty(
                  data: data,
                  docId: docId,
                  category: widget.myCategory,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
