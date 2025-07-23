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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                title: Text("Contents"),
                floating: true,
                pinned: true,
                snap: true,
              ),
              SliverToBoxAdapter(
                child: StreamBuilder(
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
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        final String docId = doc.id;
                        final data = docs[index].data();
                        return ChannelCard(data: data, docId: docId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
