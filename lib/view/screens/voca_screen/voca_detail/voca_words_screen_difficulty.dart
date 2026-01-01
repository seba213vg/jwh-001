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

class VocaWordScreenforDifficulty extends ConsumerStatefulWidget {
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
  ConsumerState<VocaWordScreenforDifficulty> createState() =>
      _VocaWordScreenforDifficultyState();
}

class _VocaWordScreenforDifficultyState
    extends ConsumerState<VocaWordScreenforDifficulty> {
  late ScrollController _scrollController;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> wordQuery;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _startLoadingAfterAnimation();
    wordQuery =
        FirebaseFirestore.instance
            .collection('words')
            .doc('difficulty')
            .collection('difficulty')
            .doc(widget.category)
            .collection(widget.category)
            .doc(widget.docId)
            .collection('details')
            .snapshots();
  }

  Future<void> _startLoadingAfterAnimation() async {
    // 🚀 애니메이션 지속 시간만큼 기다립니다.
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          actionsPadding: EdgeInsets.only(right: 5.w),
          title: Text(widget.title),
        ),
        body: StreamBuilder(
          stream: wordQuery,
          builder: (context, snapshot) {
            if (!snapshot.hasData || !_isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return Center(
                child: Text(
                  '데이터가 없습니다.',
                  style: TextStyle(fontSize: 20.sp, color: Colors.grey[400]),
                ),
              );
            }
            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data();
                  return WordTile(data: data);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
