import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/view/widgets/word_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VocaWordScreenForMywords extends ConsumerStatefulWidget {
  final String title;
  const VocaWordScreenForMywords({required this.title, super.key});

  @override
  ConsumerState<VocaWordScreenForMywords> createState() =>
      _VocaWordScreenForMywordsState();
}

class _VocaWordScreenForMywordsState
    extends ConsumerState<VocaWordScreenForMywords> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> wordQuery;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startLoadingAfterAnimation();
    final String userId = ref.read(authRepoProvider).user?.uid ?? '';
    wordQuery =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('added_words')
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
  Widget build(BuildContext context) {
    final String userId = ref.read(authRepoProvider).user?.uid ?? '';

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
              return Center(child: Text('데이터가 없습니다.'));
            }
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data();
                return Dismissible(
                  key: Key(docs[index].id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('added_words')
                        .doc(docs[index].id)
                        .delete();
                    Fluttertoast.showToast(
                      msg: "단어가 삭제되었어요",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  background: Container(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 6.w),
                    child: FaIcon(FontAwesomeIcons.trash, color: Colors.white),
                  ),
                  child: WordTile(data: data),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
