import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwh_01/common/route_helper.dart';
import 'package:jwh_01/view/screens/contents/play_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

//contents 탭에서 채널 입장 후 나타나는 화면
class PlaylistInChannel extends StatefulWidget {
  const PlaylistInChannel({super.key, required this.docId});
  final String docId;

  @override
  State<PlaylistInChannel> createState() => _PlaylistInChannelState();
}

class _PlaylistInChannelState extends State<PlaylistInChannel> {
  late ScrollController _scrollController;
  bool _isLoading = false;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> wordQuery;

  void _ontapPlaylist(BuildContext context, Map<String, dynamic> data) {
    Navigator.of(context).push(createSlideRoute(PlayScreen(data: data)));
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startLoadingAfterAnimation();
    wordQuery =
        FirebaseFirestore.instance
            .collection('contents')
            .doc(widget.docId)
            .collection('playlist')
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
    return Scaffold(
      appBar: AppBar(title: Text("Playlist in Channel"), centerTitle: true),
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
          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data();
                return ListTile(
                  title: Text(
                    data['title'] ?? 'no title',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  subtitle: Text(
                    data['description1'] ?? '',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  onTap: () => _ontapPlaylist(context, data),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
