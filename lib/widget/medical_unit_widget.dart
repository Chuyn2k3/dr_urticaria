import 'dart:io';

import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/styles.dart';

class MedicalUnitWidget extends StatelessWidget {
  MedicalUnitWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        'Bệnh Viện Da Liễu Trung Ương',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Styles.content.copyWith(color: AppColors.background),
      ),
    );
  }
}
