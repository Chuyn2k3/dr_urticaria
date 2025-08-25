// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:urticaria/utils/go_router/enum.dart';

// CustomTransitionPage<T> buildPageWithTransition<T>({
//   required Widget child,
//   RouteTransitionType type = RouteTransitionType.slideRightToLeft,
//   Duration duration = const Duration(milliseconds: 350),
// }) {
//   return CustomTransitionPage<T>(
//     child: child,
//     transitionDuration: duration,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       switch (type) {
//         case RouteTransitionType.slideRightToLeft:
//           return _buildSlide(animation, child, const Offset(1, 0));
//         case RouteTransitionType.slideLeftToRight:
//           return _buildSlide(animation, child, const Offset(-1, 0));
//         case RouteTransitionType.slideBottomToTop:
//           return _buildSlide(animation, child, const Offset(0, 1));
//         case RouteTransitionType.slideTopToBottom:
//           return _buildSlide(animation, child, const Offset(0, -1));
//         case RouteTransitionType.fade:
//           return FadeTransition(opacity: animation, child: child);
//         case RouteTransitionType.scale:
//           return ScaleTransition(scale: animation, child: child);
//         case RouteTransitionType.rotate:
//           return RotationTransition(turns: animation, child: child);
//         case RouteTransitionType.fadeScale:
//           return FadeTransition(
//             opacity: animation,
//             child: ScaleTransition(scale: animation, child: child),
//           );
//       }
//     },
//   );
// }

// Widget _buildSlide(Animation<double> animation, Widget child, Offset begin) {
//   return SlideTransition(
//     position: Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
//     child: child,
//   );
// }
