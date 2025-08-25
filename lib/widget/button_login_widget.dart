import 'dart:io';
import 'package:dr_urticaria/widget/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/icons.dart';
import '../utils/styles.dart';

class ButtonLoginWidget extends StatelessWidget {
  const ButtonLoginWidget({
    Key? key,
    required this.onLogin,
    required this.onBiometric,
  }) : super(key: key);

  final Function() onLogin;
  final Function() onBiometric;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: ViewConstants.defaultBorderRadiusBtn),
      child: Stack(
        children: [
          TouchableOpacity(
              onTap: onBiometric,
              child: SvgPicture.asset(
                Platform.isIOS ? IconEnums.faceId : IconEnums.touch_id,
                height: Constants.buttonHeight - 4,
                color: AppColors.primary,
              )),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: onLogin,
                  child: Ink(
                    height: Constants.buttonHeight,
                    child: Center(
                      child: Text(
                        "Đăng nhập",
                        style: Styles.titleButton,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                          ViewConstants.defaultBorderRadiusBtn),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
