import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwh_01/view/screens/voca_screen/voca_detail/difficulty_category_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DifficultyDetailScreen extends StatelessWidget {
  const DifficultyDetailScreen({super.key});

  _ontapCategory(BuildContext context, String myCategory) => {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DifficultyCategoryScreen(myCategory: myCategory),
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _ontapCategory(context, 'easy'),
                    child: Container(
                      height: 20.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.teal, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '기본 난이도 단어 / 표현',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () => _ontapCategory(context, 'easy2'),
                    child: Container(
                      height: 20.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.yellow, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '쉬운 난이도 단어 / 표현',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  GestureDetector(
                    onTap: () => _ontapCategory(context, 'medium'),
                    child: Container(
                      height: 20.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '어려운 난이도 단어 / 표현',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
