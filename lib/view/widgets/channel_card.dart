import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChannelCard extends StatelessWidget {
  const ChannelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 70.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.yellow, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
            child: Text(
              "YouTube Player",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
