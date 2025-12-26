import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwh_01/viewmodel/bookmark_vm.dart';
import 'package:jwh_01/viewmodel/user_vm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WordTile extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  String? docId;

  WordTile({super.key, required this.data, this.docId});

  @override
  ConsumerState<WordTile> createState() => _WordTileState();
}

class _WordTileState extends ConsumerState<WordTile> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<String> getAudioUrl(String audio) async {
    final ref = FirebaseStorage.instance.ref(audio);
    return await ref.getDownloadURL();
  }

  bool _isValidAudioUrl(String? url) {
    return url != null && url.isNotEmpty && url != 'null';
  }

  Future<void> playDiction(String? audio) async {
    if (!_isValidAudioUrl(audio)) {
      Fluttertoast.showToast(
        msg: "오디오 파일이 없습니다",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      await _audioPlayer.stop();
      final myAudioUrl = await getAudioUrl(audio!);
      final volume = ref.read(UserVmProvider).value?.volume ?? 1.0;

      await _audioPlayer.setVolume(volume);
      await _audioPlayer.play(UrlSource(myAudioUrl));
    } catch (e) {
      String errorMessage = "오디오 재생 중 오류가 발생했습니다";

      if (e is FirebaseException) {
        switch (e.code) {
          case 'object-not-found':
            errorMessage = "오디오 파일을 찾을 수 없습니다";
            break;
          case 'unauthorized':
            errorMessage = "오디오 파일에 접근할 수 없습니다";
            break;
          case 'canceled':
            errorMessage = "오디오 로딩이 취소되었습니다";
            break;
          case 'unknown':
            errorMessage = "알 수 없는 오류가 발생했습니다";
            break;
          default:
            errorMessage = "오디오 파일 로드 실패: ${e.code}";
        }
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textsize = ref.watch(UserVmProvider).value?.textsize ?? 1.0;
    int defaultTitleSize = 16;
    int defaultDescriptionSize = 14;

    return ExpansionTile(
      iconColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      childrenPadding: EdgeInsets.only(bottom: 40),
      title: Text(
        widget.data['title'] ?? '',
        style: TextStyle(
          fontSize: defaultTitleSize * textsize,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.data['mean'] ?? '',
        style: TextStyle(
          fontSize: defaultTitleSize * textsize,
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing:
          _isValidAudioUrl(widget.data['url1'])
              ? IconButton(
                onPressed: () => playDiction(widget.data['url1']),
                icon: Icon(Icons.volume_up),
              )
              : null,
      controlAffinity: ListTileControlAffinity.leading,
      children: [
        if (widget.data['description1'].toString().isNotEmpty &&
            widget.data['description1'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${widget.data['description1']}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
          ),
        if (widget.data['description2'].toString().isNotEmpty &&
            widget.data['description2'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${widget.data['description2'] ?? ''}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
          ),
        if (widget.data['description3'].toString().isNotEmpty &&
            widget.data['description3'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${widget.data['description3'] ?? ''}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
          ),
        if (widget.data['exam1'].toString().isNotEmpty &&
            widget.data['exam1'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${widget.data['exam1'] ?? ''}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
            subtitle: Text(
              '${widget.data['exam2'] ?? ''}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
            trailing:
                _isValidAudioUrl(widget.data['url2'])
                    ? IconButton(
                      onPressed: () => playDiction(widget.data['url2']),
                      icon: Icon(Icons.volume_up),
                    )
                    : null,
          ),
        if (widget.data['exam3'].toString().isNotEmpty &&
            widget.data['exam3'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${widget.data['exam3'] ?? ''}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
            subtitle: Text(
              '${widget.data['exam4'] ?? ''}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
            trailing:
                _isValidAudioUrl(widget.data['url3'])
                    ? IconButton(
                      onPressed: () => playDiction(widget.data['url3']),
                      icon: Icon(Icons.volume_up),
                    )
                    : null,
          ),
        if (widget.data['exam5'].toString().isNotEmpty &&
            widget.data['exam5'] != null)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
            title: Text(
              '${widget.data['exam5'] ?? ''}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
            subtitle: Text(
              '${widget.data['exam6'] ?? ''}',
              style: TextStyle(fontSize: defaultDescriptionSize * textsize),
            ),
            trailing:
                _isValidAudioUrl(widget.data['url4'])
                    ? IconButton(
                      onPressed: () => playDiction(widget.data['url4']),
                      icon: Icon(Icons.volume_up),
                    )
                    : null,
          ),
        SizedBox(height: 3.h),
        if (widget.docId != null)
          ElevatedButton(
            onPressed: () async {
              final result = await ref
                  .read(bookmarkVmProvider.notifier)
                  .removeBookmark(widget.docId!);
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
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              shadowColor: Theme.of(context).colorScheme.errorContainer,
              elevation: 8,
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              textStyle: GoogleFonts.gamjaFlower(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
              side: BorderSide(color: Colors.black, width: 2),
            ),
            child: Text('즐겨찾기 삭제'),
          ),
        if (widget.docId == null)
          ElevatedButton(
            onPressed: () async {
              final result = await ref
                  .read(bookmarkVmProvider.notifier)
                  .addBookmark(widget.data);
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
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor: Colors.white,
              shadowColor: Theme.of(context).colorScheme.secondary,
              elevation: 8,
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              textStyle: GoogleFonts.gamjaFlower(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
              side: BorderSide(color: Colors.black, width: 2),
            ),
            child: Text('즐겨찾기 추가'),
          ),
      ],
    );
  }
}
