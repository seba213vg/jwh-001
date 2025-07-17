import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/view/screens/contents/contents_screen.dart';
import 'package:jwh_01/view/screens/home_screen.dart';
import 'package:jwh_01/view/screens/profile/user_screen.dart';
import 'package:jwh_01/view/screens/travel_screen/travel_screen.dart';
import 'package:jwh_01/view/screens/voca_screen/voca_screen.dart';
import 'package:jwh_01/view/widgets/nav_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainNavigationScreen extends StatefulWidget {
  final String currentTab;

  const MainNavigationScreen({super.key, required this.currentTab});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = ["home", "travel", "voca", "contents", "profile"];

  late int _selectedIndex = _tabs.indexOf(widget.currentTab);

  void _isSelected(int index) {
    context.go('/${_tabs[index]}');
    print(_tabs[index]);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ot = MediaQuery.of(context).orientation;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          TravelScreen(),
          VocaScreen(),
          ContentsScreen(),
          UserScreen(),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        height: 9.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavWidget(
              text: "home",
              label: "홈",
              icon: FontAwesomeIcons.house,
              selectedIcon: FontAwesomeIcons.house,
              isSelected: _selectedIndex == 0,
              onTap: () => _isSelected(0),
              selectedIndex: _selectedIndex,
            ),
            NavWidget(
              text: "travel",
              label: "여행",
              icon: FontAwesomeIcons.plane,
              selectedIcon: FontAwesomeIcons.plane,
              isSelected: _selectedIndex == 1,
              onTap: () => _isSelected(1),
              selectedIndex: _selectedIndex,
            ),

            NavWidget(
              text: "voca",
              label: "단어",
              icon: FontAwesomeIcons.book,
              selectedIcon: FontAwesomeIcons.book,

              isSelected: _selectedIndex == 2,
              onTap: () => _isSelected(2),
              selectedIndex: _selectedIndex,
            ),
            NavWidget(
              text: "contents",
              label: "콘텐츠",
              icon: FontAwesomeIcons.video,
              selectedIcon: FontAwesomeIcons.video,

              isSelected: _selectedIndex == 3,
              onTap: () => _isSelected(3),
              selectedIndex: _selectedIndex,
            ),
            NavWidget(
              text: "Profile",
              label: "프로필",
              icon: FontAwesomeIcons.user,
              selectedIcon: FontAwesomeIcons.solidUser,
              isSelected: _selectedIndex == 4,
              onTap: () => _isSelected(4),
              selectedIndex: _selectedIndex,
            ),
          ],
        ),
      ),
    );
  }
}
