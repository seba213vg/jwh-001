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

class TravelWordsScreen extends ConsumerStatefulWidget {
  final String myCategory;
  final String myTabName;
  const TravelWordsScreen(this.myCategory, this.myTabName, {super.key});

  @override
  ConsumerState<TravelWordsScreen> createState() => _TravelWordsScreenState();
}

class _TravelWordsScreenState extends ConsumerState<TravelWordsScreen> {
  late ScrollController _scrollController;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> wordQuery;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startLoadingAfterAnimation();
    wordQuery =
        FirebaseFirestore.instance
            .collection('travel')
            .doc(widget.myCategory)
            .collection('details')
            .snapshots();
  }

  Future<void> _startLoadingAfterAnimation() async {
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
          title: Text(widget.myTabName),
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
                  '데이터가 없습니다',
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
