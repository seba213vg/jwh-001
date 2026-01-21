import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NavWidget extends StatelessWidget {
  final String text;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final Function onTap;
  final int selectedIndex;

  const NavWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.selectedIcon,
    required this.selectedIndex,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: LayoutBuilder(
        builder:
            (context, constraints) => Container(
              width: 15.w,
              height: constraints.maxHeight,
              color: Colors.black,
              child: AnimatedOpacity(
                opacity: isSelected ? 1 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isSelected
                        ? FaIcon(selectedIcon, color: Colors.white, size: 21.sp)
                        : FaIcon(icon, color: Colors.white, size: 21.sp),
                    SizedBox(height: 0.5.h),
                    Text(
                      label,
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
