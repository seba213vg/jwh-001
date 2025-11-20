import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwh_01/view/widgets/channel_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentsScreen extends StatefulWidget {
  const ContentsScreen({super.key});

  @override
  State<ContentsScreen> createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {
  @override
  Widget build(BuildContext context) {
    final wordQuery =
        FirebaseFirestore.instance.collection('contents').snapshots();

    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: MultiSliver(
            children: [
              SliverAppBar(
                title: Text("콘텐츠"),
                floating: true,
                pinned: true,
                snap: true,
              ),
              StreamBuilder(
                stream: wordQuery,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.h),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('데이터가 없습니다.'),
                        ),
                      ),
                    );
                  }

                  // ✅ SliverList 사용으로 변경
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      final String docId = doc.id;
                      final data = docs[index].data();
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 3.w,
                          right: 3.w,
                          bottom:
                              !(index == docs.length - 1)
                                  ? 4.h
                                  : 0, // 마지막 아이템만 하단 여백
                        ),
                        child: ChannelCard(data: data, docId: docId),
                      );
                    }, childCount: docs.length),
                  );
                },
              ),
              SliverToBoxAdapter(child: SizedBox(height: 2.h)),
            ],
          ),
        ),
      ],
    );
  }
}
