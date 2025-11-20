import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwh_01/view/widgets/category_travel.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: MultiSliver(
            children: [
              SliverAppBar(
                title: Text("료-코"),
                floating: true,
                pinned: true,
                snap: true,
                // toolbarHeight: math.max(8.h, kToolbarHeight),
                // collapsedHeight: math.max(8.h, kToolbarHeight),
                // centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  child: Wrap(
                    // alignment: WrapAlignment.center,
                    spacing: 4.w,
                    runSpacing: 3.h,
                    children: [
                      CategoryTravel(
                        myTitle: "기본단어",
                        myIcon: FontAwesomeIcons.noteSticky,
                        myColor: Colors.teal,
                        category: "basic_words",
                        tab_name: "키혼탕고",
                      ),
                      CategoryTravel(
                        myTitle: "기본표현",
                        myIcon: FontAwesomeIcons.comment,
                        myColor: Colors.blue,
                        category: "basic_expressions",
                        tab_name: "키혼효겐",
                      ),
                      CategoryTravel(
                        myTitle: "식당에서",
                        myIcon: FontAwesomeIcons.utensils,
                        myColor: Colors.amber,
                        category: "restaurant",
                        tab_name: "쇼쿠도-",
                      ),
                      CategoryTravel(
                        myTitle: "비행기/공항",
                        myIcon: FontAwesomeIcons.plane,
                        myColor: Colors.red,
                        category: "plane",
                        tab_name: "히코-키/쿠-코-",
                      ),
                      CategoryTravel(
                        myTitle: "교통",
                        myIcon: FontAwesomeIcons.train,
                        myColor: Colors.grey,
                        category: "transport",
                        tab_name: "코=츠=",
                      ),
                      CategoryTravel(
                        myTitle: "쇼핑",
                        myIcon: FontAwesomeIcons.shop,
                        myColor: Colors.purple,
                        category: "shopping",
                        tab_name: "카이모노",
                      ),
                      CategoryTravel(
                        myTitle: "카페/편의점",
                        myIcon: FontAwesomeIcons.store,
                        myColor: Colors.pink,
                        category: "cafe",
                        tab_name: "카페/콘비니",
                      ),
                      CategoryTravel(
                        myTitle: "호텔에서",
                        myIcon: FontAwesomeIcons.hotel,
                        myColor: Colors.amber,
                        category: "hotel",
                        tab_name: "호테루",
                      ),
                      CategoryTravel(
                        myTitle: "관광지에서",
                        myIcon: FontAwesomeIcons.mapLocation,
                        myColor: Colors.blue,
                        category: "attractive",
                        tab_name: "칸코-치",
                      ),
                      CategoryTravel(
                        myTitle: "숫자읽기",
                        myIcon: FontAwesomeIcons.two,
                        myColor: Colors.green,
                        category: "number",
                        tab_name: "수-지",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
