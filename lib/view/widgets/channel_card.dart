import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwh_01/view/screens/contents/playlist_in_channel.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:math'; // Random을 위해 추가

class ChannelCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  const ChannelCard({super.key, required this.data, required this.docId});

  void _onTapChannel(BuildContext context) {
    // Navigate to the playlist in channel screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaylistInChannel(docId: docId)),
    );
  }

  // 랜덤 색상 가져오기
  Color _getRandomBorderColor() {
    final List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.orange,
    ];

    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapChannel(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        height: 45.h,
        width: 80.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: _getRandomBorderColor(),
            width: 1,
          ), // 랜덤 색상 적용
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${data['channel']}",
              style: TextStyle(fontSize: 22.sp),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 2.h),
            CircleAvatar(
              radius: 10.h,
              backgroundImage: NetworkImage(data['thumbnail'] ?? ''),
              onBackgroundImageError: (exception, stackTrace) {},
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(height: 2.h),
            Text(
              "${data['description'] ?? 'no description'}",
              style: TextStyle(fontSize: 19.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
