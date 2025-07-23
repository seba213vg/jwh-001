import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwh_01/view/screens/contents/play_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PlaylistInChannel extends StatelessWidget {
  const PlaylistInChannel({super.key, required this.docId});
  final String docId;

  void _ontapPlaylist(BuildContext context, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayScreen(data: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordQuery =
        FirebaseFirestore.instance
            .collection('contents')
            .doc(docId)
            .collection('playlist')
            .snapshots();
    return Scaffold(
      appBar: AppBar(title: Text("Playlist in Channel"), centerTitle: true),
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
          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
