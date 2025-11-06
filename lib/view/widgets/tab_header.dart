import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class tabHeader extends StatelessWidget {
  const tabHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: Container(
        height: 8.h,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border(top: BorderSide(color: Colors.black45, width: 0.2.w)),
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          labelColor: Theme.of(context).colorScheme.secondary,

          tabs: [
            Tab(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  "테마",
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Tab(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  "난이도",
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
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
