import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwh_01/view/widgets/word_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late ScrollController _scrollController;
  String searchWord = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  late TextEditingController _searchController;
  bool searchKoreanMode = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchWordsStream(
    String searchText,
  ) {
    if (searchText.isEmpty) {
      // 빈 Stream 반환
      return Stream.empty();
    }

    String endText = '$searchText\uf8ff';

    if (searchKoreanMode) {
      return db
          .collectionGroup('details')
          .where('searchKeywords', arrayContains: searchText)
          .snapshots();

      // db
      //     .collectionGroup('details')
      //     .where('title', isGreaterThanOrEqualTo: searchText)
      //     .where('title', isLessThan: endText)
      //     .snapshots();
    } else {
      return db
          .collectionGroup('details')
          .where('mean', isGreaterThanOrEqualTo: searchText)
          .where('mean', isLessThan: endText)
          .snapshots();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: searchKoreanMode ? "한국어 찾기" : "일본어 찾기",
                labelStyle: TextStyle(fontSize: 18.sp),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        searchKoreanMode
                            ? Text(
                              "한",
                              key: ValueKey(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: Colors.blue,
                              ),
                            )
                            : Text(
                              "あ",
                              key: ValueKey(2),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: Colors.orange,
                              ),
                            ),
                  ),
                  onPressed: () {
                    setState(() {
                      searchKoreanMode = !searchKoreanMode;
                      _searchController.clear();
                      searchWord = ""; // 검색 초기화
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchWord = value;
                });
              },
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child:
                searchWord.isEmpty
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          "단어 찾기 팁!",
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "궁금한 단어가 나오지 않으면 비슷한 단어를 검색해보세요",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "ex) '뛰다'가 나오지 않는다면, '달리다'로 검색해보세요!",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                    : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      // ✅ searchWord 변경 시 Stream 새로 생성
                      stream: searchWordsStream(searchWord),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('오류 발생: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('검색 결과가 없습니다'));
                        }

                        final docs = snapshot.data!.docs;

                        // ✅ ListView.builder로 결과 표시
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data();
                            return WordTile(data: data);
                          },
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}
