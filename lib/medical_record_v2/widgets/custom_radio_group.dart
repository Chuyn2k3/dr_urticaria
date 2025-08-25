import 'package:flutter/material.dart';

class CustomRadioGroup extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final Function(String?) onChanged;
  final bool isRequired;
  final bool enabled;

  const CustomRadioGroup({
    Key? key,
    required this.label,
    this.value,
    required this.options,
    required this.onChanged,
    this.isRequired = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: enabled ? Colors.white : Colors.grey[50],
            ),
            child: Column(
              children: options.map((option) {
                return RadioListTile<String>(
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color: enabled ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                  value: option,
                  groupValue: value,
                  onChanged: enabled ? onChanged : null,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Colors.blue,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
