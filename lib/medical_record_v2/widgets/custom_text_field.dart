import 'package:flutter/material.dart';

import '../../constant/color.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? value;
  final Function(String) onChanged;
  final String? hint;
  final bool isRequired;
  final int maxLines;
  final TextInputType keyboardType;
  final bool enabled;
  final Widget? prefixIcon;
  final TextEditingController? textController;

  const CustomTextField({
    Key? key,
    required this.label,
    this.value,
    required this.onChanged,
    this.hint,
    this.isRequired = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.prefixIcon,
    this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  letterSpacing: 0.1,
                ),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.redColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: textController,
              initialValue: textController == null ? value : null,
              onChanged: onChanged,
              maxLines: maxLines,
              keyboardType: keyboardType,
              enabled: enabled,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppColors.grayColor.withOpacity(0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: prefixIcon != null
                    ? Container(
                        margin: const EdgeInsets.only(left: 16, right: 12),
                        child: prefixIcon,
                      )
                    : null,
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.borderColor,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2.5,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.borderColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.redColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor:
                    enabled ? AppColors.whiteColor : AppColors.primaryColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: prefixIcon != null ? 8 : 20,
                  vertical: maxLines > 1 ? 16 : 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputTextField extends CustomTextField {
  const InputTextField({
    Key? key,
    required String label,
    String? value,
    required Function(String) onChanged,
    String? hint,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    Widget? prefixIcon,
    TextEditingController? textController,
    String? hintText,
  }) : super(
          key: key,
          label: label,
          value: value,
          onChanged: onChanged,
          hint: hint ?? hintText,
          isRequired: isRequired,
          maxLines: maxLines,
          keyboardType: keyboardType,
          enabled: enabled,
          prefixIcon: prefixIcon,
          textController: textController,
        );
}
