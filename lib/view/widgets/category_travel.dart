import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/view/screens/travel_screen/travel_detail/words_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryTravel extends StatelessWidget {
  final String myTitle;
  final IconData myIcon;
  final Color myColor;
  final String category;

  const CategoryTravel({
    super.key,
    required this.myTitle,
    required this.myIcon,
    required this.myColor,
    required this.category,
  });

  void _onTabCategory(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => WordsScreen(category)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTabCategory(context),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1.0, color: myColor),
        ),
        width: 45.w,
        height: 12.h,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  myTitle,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: Offset(-3.w, 1.h),
                  child: Transform.scale(
                    scale: 1.6,
                    child: Icon(myIcon, size: 25.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
