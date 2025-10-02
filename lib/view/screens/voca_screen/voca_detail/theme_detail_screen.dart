import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/view/widgets/category_voca.dart';
import 'package:jwh_01/view/widgets/category_voca_for_mywords.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ThemeDetailScreen extends ConsumerStatefulWidget {
  const ThemeDetailScreen({super.key});

  @override
  ConsumerState<ThemeDetailScreen> createState() => _ThemeDetailScreenState();
}

class _ThemeDetailScreenState extends ConsumerState<ThemeDetailScreen> {
  late AuthRepository _authRepo;
  @override
  void initState() {
    super.initState();
    _authRepo = ref.read(authRepoProvider);
  }

  @override
  Widget build(BuildContext context) {
    final wordQuery =
        FirebaseFirestore.instance
            .collection('words')
            .doc('theme')
            .collection('theme')
            .snapshots();

    final userId = _authRepo.user?.uid ?? '';
    final wordQueryForMywords =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('added_words')
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

          return StreamBuilder(
            stream: wordQueryForMywords,
            builder: (context, myWordsSnapshot) {
              // MyWords 데이터 상태 확인
              bool hasMyWordsData = false;
              List<DocumentSnapshot> myWordsDocs = [];

              if (myWordsSnapshot.hasData &&
                  myWordsSnapshot.data!.docs.isNotEmpty) {
                hasMyWordsData = true;
                myWordsDocs = myWordsSnapshot.data!.docs;
              }

              return Column(
                children: [
                  hasMyWordsData
                      ? CategoryVocaForMywords(title: '내가 추가한 단어 모음')
                      : SizedBox.shrink(),

                  Expanded(
                    child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        final String docId = doc.id;
                        final data = docs[index].data();

                        return CategoryVoca(data: data, docId: docId);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
