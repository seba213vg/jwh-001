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
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    // YouTube ID 검증 및 초기화
    String? youtubeId = _extractVideoId(widget.data['youtube_id']);

    if (youtubeId != null && youtubeId.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: youtubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          captionLanguage: 'ko',
          forceHD: false,
          loop: false,
        ),
      );

      // 플레이어 상태 리스너 추가
      _controller.addListener(_onPlayerStateChange);
    } else {
      // 유효하지 않은 YouTube ID 처리
      print('Invalid YouTube ID: ${widget.data['youtube_id']}');
    }
  }

  void _onPlayerStateChange() {
    if (_controller.value.isReady && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }

    if (_controller.value.hasError) {
      print('YouTube Player Error: ${_controller.value.errorCode}');
    }
  }

  // YouTube URL에서 Video ID 추출
  String? _extractVideoId(dynamic input) {
    if (input == null) return null;

    String videoId = input.toString();

    // 이미 Video ID인 경우
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(videoId)) {
      return videoId;
    }

    // YouTube URL에서 Video ID 추출
    return YoutubePlayer.convertUrlToId(videoId);
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChange);
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

    // YouTube ID가 없는 경우 에러 화면 표시
    if (_extractVideoId(widget.data['youtube_id']) == null) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('재생 오류'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  '유효하지 않은 동영상 ID입니다',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'YouTube ID: ${widget.data['youtube_id']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: YoutubePlayerBuilder(
        onEnterFullScreen: () {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        },
        onExitFullScreen: () {
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
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
          onReady: () {
            print('YouTube Player is ready');
            setState(() {
              _isPlayerReady = true;
            });
          },
          onEnded: (metaData) {
            print('Video ended');
          },
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
                // 플레이어 로딩 상태 표시
                Stack(
                  children: [
                    player,
                    if (!_isPlayerReady)
                      Container(
                        height: isShort ? 56.h : 25.h,
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (!_controller.value.isFullScreen) ...[
                  SizedBox(height: 2.h),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
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
                          SizedBox(height: 4.h), // 하단 여백 추가
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
