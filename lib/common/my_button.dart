import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyButton extends StatelessWidget {
  final String text;
  final bool isEnabled;

  const MyButton({super.key, required this.text, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color:
              isEnabled ? Theme.of(context).primaryColor : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(29),
        ),
        duration: Duration(milliseconds: 200),
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 200),
          style: GoogleFonts.gamjaFlower(
            fontSize: 28,
            color: isEnabled ? Colors.white : Colors.white,
          ),
          textAlign: TextAlign.center,
          child: Text(text),
        ),
      ),
    );
  }
}
