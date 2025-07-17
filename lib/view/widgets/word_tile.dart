import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwh_01/viewmodel/bookmark_vm.dart';
import 'package:jwh_01/viewmodel/user_vm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WordTile extends ConsumerWidget {
  final Map<String, dynamic> data;
  String? docId;

  WordTile({super.key, required this.data, this.docId});

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<String> getAudioUrl(String audio) async {
    final ref = FirebaseStorage.instance.ref(audio); // 예: 'audio/sample.mp3'
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textsize = ref.watch(UserVmProvider).value?.textsize ?? 1.0;
    final volume = ref.watch(UserVmProvider).value?.volume ?? 1.0;

    Future<void> playDiction(String? audio) async {
      await _audioPlayer.stop();
      if (audio == null || audio.isEmpty) return;
      final myAudioUrl = await getAudioUrl(audio);
      await _audioPlayer.setVolume(volume); // 볼륨 반영
      await _audioPlayer.play(UrlSource(myAudioUrl));
    }

    return ExpansionTile(
      iconColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      childrenPadding: EdgeInsets.only(bottom: 40),
      title: Text(
        data['title'] ?? '',
        style: TextStyle(fontSize: 18 * textsize, fontWeight: FontWeight.bold),
      ),

      subtitle: Text(
        data['mean'] ?? '',
        style: TextStyle(fontSize: 18 * textsize, fontWeight: FontWeight.w300),
      ),
      trailing: IconButton(
        onPressed: () => playDiction(data['url1'] ?? ''),
        icon: Icon(Icons.volume_up),
      ),
      controlAffinity: ListTileControlAffinity.leading,

      children: [
        if (data['description1'].toString().isNotEmpty &&
            data['description1'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${data['description1']}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
          ),
        if (data['description2'].toString().isNotEmpty &&
            data['description2'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${data['description2'] ?? ''}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
          ),
        if (data['description3'].toString().isNotEmpty &&
            data['description3'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${data['description3'] ?? ''}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
          ),
        if (data['exam1'].toString().isNotEmpty && data['exam1'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${data['exam1'] ?? ''}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
            subtitle: Text(
              '${data['exam2'] ?? ''}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
            trailing: IconButton(
              onPressed: () => playDiction(data['url2'] ?? ''),
              icon: Icon(Icons.volume_up),
            ),
          ),
        if (data['exam3'].toString().isNotEmpty && data['exam3'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${data['exam3'] ?? ''}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
            subtitle: Text(
              '${data['exam4'] ?? ''}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
            trailing: IconButton(
              onPressed: () => playDiction(data['url3'] ?? ''),
              icon: Icon(Icons.volume_up),
            ),
          ),
        if (data['exam5'].toString().isNotEmpty && data['exam5'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${data['exam5'] ?? ''}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
            subtitle: Text(
              '${data['exam6'] ?? ''}',
              style: TextStyle(fontSize: 15 * textsize),
            ),
            trailing: IconButton(
              onPressed: () => playDiction(data['url4'] ?? ''),
              icon: Icon(Icons.volume_up),
            ),
          ),

        SizedBox(height: 3.h),
        if (docId != null)
          ElevatedButton(
            onPressed: () async {
              final result = await ref
                  .read(bookmarkVmProvider.notifier)
                  .removeBookmark(docId!);
              Fluttertoast.showToast(
                msg: result,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error, // 버튼 배경색
              foregroundColor: Colors.white, // 텍스트 색상
              shadowColor:
                  Theme.of(context).colorScheme.errorContainer, // 그림자 색상
              elevation: 8, // 입체감(그림자 깊이)
              padding: EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ), // 내부 여백
              textStyle: GoogleFonts.gamjaFlower(
                fontWeight: FontWeight.bold,
                fontSize: 12 * textsize,
              ),
              side: BorderSide(color: Colors.black, width: 2), // 테두리
            ),

            child: Text('즐겨찾기 삭제'),
          ),
        if (docId == null)
          ElevatedButton(
            onPressed: () async {
              final result = await ref
                  .read(bookmarkVmProvider.notifier)
                  .addBookmark(data);
              Fluttertoast.showToast(
                msg: result,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.secondaryContainer, // 버튼 배경색
              foregroundColor: Colors.white, // 텍스트 색상
              shadowColor: Theme.of(context).colorScheme.secondary, // 그림자 색상
              elevation: 8, // 입체감(그림자 깊이)
              padding: EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ), // 내부 여백
              textStyle: GoogleFonts.gamjaFlower(
                fontWeight: FontWeight.bold,
                fontSize: 12 * textsize,
              ),
              side: BorderSide(color: Colors.black, width: 2), // 테두리
            ),

            child: Text('즐겨찾기 추가'),
          ),
      ],
    );
  }
}
