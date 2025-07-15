import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DifficultyDetailScreen extends StatelessWidget {
  const DifficultyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: 5.h,
          expandedHeight: 10.h,
          collapsedHeight: 5.h,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(top: 12, bottom: 10),
            expandedTitleScale: 1.2,
            centerTitle: true,
            title: Text('난이도별', style: TextStyle(fontSize: 18.sp)),
          ),
        ),
        MultiSliver(
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
              child: Container(
                height: 50,
                color: Colors.red,
                child: Center(child: Text("Pinned Header")),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(title: Text('Item #$index')),
                childCount: 10,
              ),
            ),
          ],
        ),
        SliverPinnedHeader(
          child: Container(
            height: 50,
            color: Colors.teal,
            child: Center(child: Text("Pinned Header")),
          ),
        ),
        SliverStack(
          children: [
            SliverPositioned.fill(
              child: Container(color: Colors.blue.withOpacity(0.3)),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
                  tileColor: Colors.grey,
                  title: Text('Stacked Item #$index'),
                ),
                childCount: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
