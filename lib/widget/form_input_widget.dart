// import 'package:dr_urticaria/widget/touchable_opacity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../utils/colors.dart';
// import '../utils/constants.dart';
// import '../utils/icons.dart';
// import '../utils/styles.dart';
// import 'app_dialog_confirm.dart';
// import 'app_input.dart';
// import 'button_login_widget.dart';

// class FormInputWidget extends StatefulWidget {
//   const FormInputWidget(
//       {Key? key,
//       required this.phoneController,
//       required this.passwordController})
//       : super(key: key);
//   final TextEditingController phoneController;
//   final TextEditingController passwordController;
//   @override
//   State<FormInputWidget> createState() => _FormInputWidgetState();
// }

// class _FormInputWidgetState extends State<FormInputWidget>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late AnimationController _buttonAnimationController;
//   late Animation<double> _buttonScaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _buttonAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//     );
//     _buttonScaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.95,
//     ).animate(CurvedAnimation(
//       parent: _buttonAnimationController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _buttonAnimationController.dispose();
//     super.dispose();
//   }

//   void _showDialogForgot(BuildContext context) async {
//     await showDialog<bool>(
//       context: context,
//       builder: (c) => DialogConfirm(
//         title: 'Thông báo',
//         subTitle:
//             'Vui lòng liên hệ tổng đài hỗ trợ để được hướng dẫn lấy lại mật khẩu',
//         buttonRight: 'Hủy bỏ',
//         buttonLeft: 'Gọi ngay',
//         onButtonLeft: () async {},
//         onButtonRight: () {
//           Navigator.of(context, rootNavigator: true).pop();
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Phone input với design mới
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       child: SvgPicture.asset(
//                         IconEnums.phone,
//                         height: 24,
//                         color: const Color(0xFF0066CC),
//                       ),
//                     ),
//                     Expanded(
//                       child: AppInput(
//                         controller: widget.phoneController,
//                         validator: (phoneNumber) {
//                           if (phoneNumber == null ||
//                               phoneNumber.trim().isEmpty) {
//                             return "Vui lòng nhập số điện thoại";
//                           }
//                           if (!Reges.regIsPhone.hasMatch(phoneNumber.trim())) {
//                             return "Số điện thoại không hợp lệ";
//                           }
//                           return null;
//                         },
//                         enabled: true,
//                         hintText: "Số điện thoại",
//                         onTapIconRight: () async {
//                           widget.phoneController.clear();
//                         },
//                         iconRight: IconEnums.close,
//                         onChangeValue: (value) {},
//                         keyboardType: TextInputType.phone,
//                         fillColor: Colors.transparent,
//                         // enabledBorder: InputBorder.none,
//                         // focusedBorder: InputBorder.none,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Password input với design mới
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       child: SvgPicture.asset(
//                         IconEnums.lock,
//                         height: 24,
//                         color: const Color(0xFF0066CC),
//                       ),
//                     ),
//                     Expanded(
//                       child: AppInput(
//                         controller: widget.passwordController,
//                         maxLine: 1,
//                         hintText: "Mật khẩu",
//                         obscureText: true,
//                         onChangeValue: (value) {},
//                         fillColor: Colors.transparent,
//                         // enabledBorder: InputBorder.none,
//                         // focusedBorder: InputBorder.none,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TouchableOpacity(
//                     onTap: () => _showDialogForgot(context),
//                     child: Text(
//                       "Quên mật khẩu?",
//                       style: TextStyle(
//                         color: const Color(0xFF0066CC),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 32),
//             ],
//           ),
//         ),

//         // Login button với animation
//         ScaleTransition(
//           scale: _buttonScaleAnimation,
//           child: Container(
//             width: double.infinity,
//             height: 56,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF0066CC), Color(0xFF004499)],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF0066CC).withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(16),
//                 onTapDown: (_) => _buttonAnimationController.forward(),
//                 onTapUp: (_) => _buttonAnimationController.reverse(),
//                 onTapCancel: () => _buttonAnimationController.reverse(),
//                 onTap: () async {
//                   Navigator.pushReplacement(
//                     context,
//                     PageRouteBuilder(
//                       pageBuilder: (context, animation, secondaryAnimation) =>
//                           const BottomNavPage(),
//                       transitionsBuilder:
//                           (context, animation, secondaryAnimation, child) {
//                         return FadeTransition(opacity: animation, child: child);
//                       },
//                       transitionDuration: const Duration(milliseconds: 500),
//                     ),
//                   );
//                 },
//                 child: const Center(
//                   child: Text(
//                     "Đăng nhập",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(height: 32),

//         // Sign up link
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Bạn chưa có tài khoản? ',
//               style: TextStyle(
//                 color: Color(0xFF6B7280),
//                 fontSize: 16,
//               ),
//             ),
//             TouchableOpacity(
//               child: Text(
//                 'Đăng ký',
//                 style: TextStyle(
//                   color: const Color(0xFF0066CC),
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (context, animation, secondaryAnimation) =>
//                         SignupForm(),
//                     transitionsBuilder:
//                         (context, animation, secondaryAnimation, child) {
//                       return SlideTransition(
//                         position: Tween<Offset>(
//                           begin: const Offset(1.0, 0.0),
//                           end: Offset.zero,
//                         ).animate(animation),
//                         child: child,
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
