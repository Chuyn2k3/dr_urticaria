import 'package:design_system_sl/typography/typography.dart';
import 'package:dr_urticaria/constant/color.dart';
import 'package:dr_urticaria/utils/common_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final String? label;
  final String? errorText;
  final bool obscureText;
  final Icon? prefixIcon;
  final String? hintText;
  final TextAlign? textAlign;
  final IconButton? iconButton;
  final int? maxLine;
  final int? maxLength;
  final int? minLine;
  final TextEditingController? textController;
  final bool enabled;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final InputDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? ontap;
  final TextInputType? keyboardType;

  const InputTextField({
    Key? key,
    this.onChanged,
    this.focusNode,
    this.obscureText = false,
    this.prefixIcon,
    this.errorText,
    this.textController,
    this.iconButton,
    this.hintText,
    this.maxLine,
    this.minLine,
    this.label,
    this.enabled = true,
    this.validator,
    this.inputFormatters,
    this.onSaved,
    this.ontap,
    this.textAlign,
    this.decoration,
    this.padding,
    this.maxLength,
    this.keyboardType,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      onTap: ontap,
      controller: textController,
      onChanged: onChanged,
      style: PrimaryFont.medium(15).copyWith(color: AppColors.greyColor),
      maxLines: maxLine,
      minLines: minLine,
      enabled: enabled,
      textAlign: textAlign ?? TextAlign.center,
      validator: validator,
      maxLength: maxLength,
      onSaved: onSaved,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: decoration ??
          InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              hintStyle:
                  textTheme.t16R.copyWith(color: colorApp.labelSecondary),
              prefixIcon: prefixIcon,
              label: label == null
                  ? null
                  : Text(
                      label ?? '',
                      style: PrimaryFont.medium(15)
                          .copyWith(color: AppColors.greyColor),
                    ),
              suffixIcon: iconButton,
              errorText: errorText,
              errorMaxLines: 2,
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorApp.grey, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorApp.grey5, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorApp.grey5, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)))),
    );
  }
}
