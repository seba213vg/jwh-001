import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryVoca extends StatelessWidget {
  final Map<String, dynamic> data;
  const CategoryVoca({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},

      child: Container(
        height: 10.h,
        margin: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.black,
          //color: Color(0xFFF7F7F7), // 아주 연한 회색
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: Stack(
          children: [
            // 왼쪽 구멍 3개
            Positioned(
              left: 2.1.w,
              top: 0.h,
              child: Column(
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(vertical: 0.8.h),
                    width: 3.4.w,
                    height: 3.4.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                  ),
                ),
              ),
            ),
            // 가로줄
            Positioned.fill(
              left: 4.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            //icon
            Positioned(
              top: 0.2.h,
              right: 13,
              child: Transform.rotate(
                angle: 0.6,
                child: FaIcon(
                  FontAwesomeIcons.thumbtack,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
            // 텍스트
            Positioned.fill(
              left: 48,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data['name'] ?? '',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[100],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
