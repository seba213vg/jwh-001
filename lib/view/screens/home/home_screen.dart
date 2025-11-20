import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/view/screens/home/dictionary_webview.dart';
import 'package:jwh_01/view/screens/home/word_add_screen.dart';
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

  void _onTapDictionary() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => DictionaryWebview()));
  }

  void _onTapAdd() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => WordAddScreen()));
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
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("오미즈 구다사이"),
        actions: [
          IconButton(onPressed: _onTapAdd, icon: FaIcon(FontAwesomeIcons.plus)),
          IconButton(
            onPressed: _onTapDictionary,
            // icon: FaIcon(FontAwesomeIcons.language),
            icon: Icon(Icons.translate),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 3.w),
      ),
      body: StreamBuilder(
        stream: wordQuery,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 1.h),
                    height: 55.h,
                    width: 89.w,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: AssetImage('assets/images/note3.png'), // 에셋 이미지
                        fit: BoxFit.fill, // 이미지 크기 조정 방식
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), // 이미지에 어두운 오버레이
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          '= 한글로 일본어 배우기 =',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "'-'가 붙어있는 경우에는 길게 발음해주세요!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "'ㅈ' 는 영어 'z' 처럼 발음해주세요!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "받침 'ㄴ'과 'ㅇ' 발음은 중간 어디쯤으로 발음해주세요!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          " ex) 스미마센/스미미셍",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "'ㄱ'과 'ㅋ' 발음은 중간 어디쯤으로 발음해주세요!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          " ex) 고레/코레",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          "'ㅉ'과 'ㅊ' 발음은 중간 어디쯤으로 발음해주세요!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          " ex) 곤니찌와/곤니치와",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 8.h,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '즐겨찾기를 추가하면 여기에 표시됩니다',
                            style: TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,

                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                final doc = docs[index];
                final docId = doc.id;
                return WordTile(data: data, docId: docId);
              },
            ),
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
