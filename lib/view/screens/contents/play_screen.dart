import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PlayScreen({super.key, required this.data});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.data['youtube_id'] ?? '',
      flags: YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // 화면 방향을 기본값으로 복원
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // 시스템 UI 복원
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isShort = widget.data['portrait'] ?? false;
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        // 전체화면 진입 시 시스템 UI 숨기기
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      onExitFullScreen: () {
        // 전체화면 해제 시 시스템 UI 복원
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        aspectRatio: isShort ? 9 / 16 : 16 / 9,
        progressIndicatorColor: Colors.red,
        progressColors: ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar:
              _controller.value.isFullScreen
                  ? null
                  : AppBar(
                    title: Text(widget.data['title'] ?? 'Video Player'),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
          body: Column(
            children: [
              player,
              if (!_controller.value.isFullScreen) ...[
                SizedBox(height: 2.h),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['title'] ?? 'No Title',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.data['description1'] ??
                              'No description available',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.data['description2'] ??
                              'No description available',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
