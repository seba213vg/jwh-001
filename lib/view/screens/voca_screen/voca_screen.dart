import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwh_01/view/screens/voca_screen/voca_detail/difficulty_detail_screen.dart';
import 'package:jwh_01/view/screens/voca_screen/voca_detail/theme_detail_screen.dart';
import 'package:jwh_01/view/widgets/tab_header.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VocaScreen extends StatelessWidget {
  const VocaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [SliverAppBar(title: Text("탄고쵸-")), tabHeader()];
          },
          body: TabBarView(
            children: [ThemeDetailScreen(), DifficultyDetailScreen()],
          ),
        ),
      ),
    );
  }
}
