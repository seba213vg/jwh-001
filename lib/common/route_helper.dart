import 'package:flutter/material.dart';

// 오른쪽에서 슬라이드 애니메이션 경로를 생성하는 함수
Route createSlideRoute(Widget targetPage) {
  // 함수의 이름을 좀 더 명확하게 변경했습니다.
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),

    // 파라미터로 받은 targetPage를 반환
    pageBuilder: (context, animation, secondaryAnimation) => targetPage,

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 오른쪽에서 등장하는 애니메이션 로직
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
