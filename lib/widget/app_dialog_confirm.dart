import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/helper.dart';
import '../utils/styles.dart';

class DialogConfirm extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? buttonLeft;
  final String? buttonRight;
  final Function? onButtonLeft;
  final Function? onButtonRight;
  const DialogConfirm({
    Key? key,
    required this.title,
    required this.subTitle,
    this.onButtonLeft,
    this.onButtonRight,
    this.buttonLeft,
    this.buttonRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widthConvert(context, 375),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowBaseShadow,
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 24, bottom: 12, left: 12, right: 12),
              child: Text(
                title,
                style: Styles.titleItem.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
              child: Text(
                subTitle,
                style: Styles.content,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                width: 1, color: Colors.grey.shade200),
                          ),
                        ),
                        child: Text(
                          buttonLeft ?? "",
                          style: Styles.titleButton
                              .copyWith(color: AppColors.black),
                        ),
                      ),
                      onTap: () {
                        onButtonLeft != null
                            ? onButtonLeft!()
                            : Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        height: 50,
                        child: Text(
                          buttonRight ?? "",
                          style: Styles.titleButton
                              .copyWith(color: AppColors.black),
                        ),
                      ),
                      onTap: () {
                        onButtonRight != null
                            ? onButtonRight!()
                            : Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
