import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwh_01/view/widgets/category_travel.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TravelScreen extends StatelessWidget {
  const TravelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: MultiSliver(
            children: [
              SliverAppBar(
                title: Text("travel"),
                floating: true,
                pinned: true,
                snap: true,
                collapsedHeight: 8.h,
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
                      ),
                      CategoryTravel(
                        myTitle: "기본표현",
                        myIcon: FontAwesomeIcons.comment,
                        myColor: Colors.blue,
                        category: "basic_expressions",
                      ),
                      CategoryTravel(
                        myTitle: "식당에서",
                        myIcon: FontAwesomeIcons.utensils,
                        myColor: Colors.amber,
                        category: "restaurant",
                      ),
                      CategoryTravel(
                        myTitle: "비행기/공항",
                        myIcon: FontAwesomeIcons.plane,
                        myColor: Colors.red,
                        category: "plane",
                      ),
                      CategoryTravel(
                        myTitle: "교통편",
                        myIcon: FontAwesomeIcons.train,
                        myColor: Colors.grey,
                        category: "vehicle",
                      ),
                      CategoryTravel(
                        myTitle: "쇼핑할 때",
                        myIcon: FontAwesomeIcons.shop,
                        myColor: Colors.purple,
                        category: "shopping",
                      ),
                      CategoryTravel(
                        myTitle: "편의점에서",
                        myIcon: FontAwesomeIcons.store,
                        myColor: Colors.pink,
                        category: "convenient",
                      ),
                      CategoryTravel(
                        myTitle: "호텔에서",
                        myIcon: FontAwesomeIcons.hotel,
                        myColor: Colors.amber,
                        category: "hotel",
                      ),
                      CategoryTravel(
                        myTitle: "관광지에서",
                        myIcon: FontAwesomeIcons.mapLocation,
                        myColor: Colors.blue,
                        category: "attractive",
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
