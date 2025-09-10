import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant/color.dart';
import '../../utils/enum/field_type_enum.dart';
import '../../widget/text_field/input_text_field.dart';
import 'custom_checkbox_group.dart';
import 'custom_multiple_choice_with_images.dart';
import 'custom_radio_group.dart';

class CustomFieldEditor extends StatefulWidget {
  final List<CustomFieldGroup>? groups;
  final Map<String, dynamic> value;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const CustomFieldEditor({
    super.key,
    this.groups,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomFieldEditor> createState() => _CustomFieldEditorState();
}

class _CustomFieldEditorState extends State<CustomFieldEditor> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void didUpdateWidget(covariant CustomFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final group in widget.groups ?? []) {
      for (var i = 0; i < group.fields.length; i++) {
        final field = group.fields[i];
        final fieldKey = field.label ?? group.label ?? 'field_$i';
        final fieldValue = widget.value[fieldKey] ??
            (field.type == FieldType.custom ? {} : null);
        if (field.type == FieldType.text || field.type == FieldType.number) {
          _controllers[fieldKey] ??= TextEditingController();
          if (_controllers[fieldKey]!.text != (fieldValue?.toString() ?? '')) {
            _controllers[fieldKey]!.text = fieldValue?.toString() ?? '';
            print(
                "[CustomFieldEditor] 🔄 Updated controller for $fieldKey: ${fieldValue}");
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groups == null || widget.groups!.isEmpty) {
      return const Text('Không có trường dữ liệu');
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.groups!.asMap().entries.map((entry) {
          final group = entry.value;
          final groupIndex = entry.key;
          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (group.label != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        group.label!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.bgBlueDark,
                        ),
                      ),
                    ),
                  ...group.fields.asMap().entries.map((fieldEntry) {
                    final field = fieldEntry.value;
                    final fieldIndex = fieldEntry.key;
                    final fieldKey =
                        field.label ?? group.label ?? 'field_$fieldIndex';
                    final fieldValue = widget.value[fieldKey] ??
                        (field.type == FieldType.custom ? {} : null);
                    print(
                        "[CustomFieldEditor] 🔍 Field: $fieldKey | Value: $fieldValue | Type: ${field.type} | Options: ${field.options}");

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: _buildFieldEditor(
                        context,
                        field,
                        fieldValue,
                        group,
                        fieldKey,
                        groupIndex,
                        fieldIndex,
                        '',
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFieldEditor(
    BuildContext context,
    CustomField field,
    dynamic fieldValue,
    CustomFieldGroup group,
    String fieldKey,
    int groupIndex,
    int fieldIndex,
    String prefix,
  ) {
    final fullKey = prefix.isEmpty ? fieldKey : '$prefix.$fieldKey';
    if (field.dependsOn != null && field.dependsOnValues != null) {
      final parentValue = widget.value[field.dependsOn] as String?;
      if (parentValue == null ||
          !field.dependsOnValues!.contains(parentValue)) {
        return const SizedBox.shrink();
      }
    }

    // Handle nested Map values (e.g., {"Có điều trị hay không?": "Có"})
    if (field.type == FieldType.select && field.options != null) {
      final nestedKey = field.label ?? fieldKey;
      final nestedValue = fieldValue is Map<String, dynamic>
          ? fieldValue[nestedKey] as String?
          : null;
      return CustomRadioGroup(
        label: field.label ?? 'Trường $fieldIndex',
        value: nestedValue,
        options: field.options ?? [],
        onChanged: (newValue) {
          print("[CustomFieldEditor] ✏️ $fullKey radio changed: $newValue");
          final updatedValue = Map<String, dynamic>.from(widget.value);
          if (newValue != null) {
            updatedValue[fullKey] = {nestedKey: newValue};
          } else {
            updatedValue.remove(fullKey);
          }
          widget.onChanged(updatedValue);
        },
        isRequired: field.requiredFields?.isNotEmpty ?? false,
        enabled: true,
      );
    }

    switch (field.type) {
      case FieldType.text:
      case FieldType.number:
        _controllers[fullKey] ??=
            TextEditingController(text: fieldValue?.toString() ?? '');
        return InputTextField(
          label: field.label ?? 'Trường $fieldIndex',
          keyboardType: field.type == FieldType.number
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          textController: _controllers[fullKey],
          validator: (field.requiredFields?.isNotEmpty ?? false)
              ? (val) =>
                  val == null || val.isEmpty ? 'Vui lòng điền trường này' : null
              : null,
          onChanged: (newValue) {
            print("[CustomFieldEditor] ✏️ $fullKey changed: $newValue");
            final updatedValue = Map<String, dynamic>.from(widget.value);
            if (newValue.isNotEmpty) {
              updatedValue[fullKey] = field.type == FieldType.number
                  ? num.tryParse(newValue) ?? newValue
                  : newValue;
            } else {
              updatedValue.remove(fullKey);
            }
            widget.onChanged(updatedValue);
          },
        );
      case FieldType.select:
        return CustomRadioGroup(
          label: field.label ?? 'Trường $fieldIndex',
          value: fieldValue is String ? fieldValue : null,
          options: field.options ?? [],
          onChanged: (newValue) {
            print("[CustomFieldEditor] ✏️ $fullKey select changed: $newValue");
            final updatedValue = Map<String, dynamic>.from(widget.value);
            if (newValue != null) {
              updatedValue[fullKey] = newValue;
            } else {
              updatedValue.remove(fullKey);
            }
            widget.onChanged(updatedValue);
          },
          isRequired: field.requiredFields?.isNotEmpty ?? false,
          enabled: true,
        );
      case FieldType.multiSelection:
        final hasImages = field.options != null &&
            field.options!.any((opt) => opt.contains('image_upload'));
        if (hasImages) {
          final options = field.options ?? [];
          final subOptions = field.groups!.isNotEmpty
              ? {
                  for (var g in field.groups!)
                    g.label ?? '': g.fields.map((f) => f.label ?? '').toList()
                }
              : null;
          final imagePaths = fieldValue is Map
              ? fieldValue['image_paths'] as Map<String, List<String>>? ?? {}
              : {};
          return CustomMultipleChoiceWithImages(
            label: field.label ?? 'Trường $fieldIndex',
            selectedValues: fieldValue is List<String> ? fieldValue : [],
            options: options,
            subOptions: subOptions,
            imagePaths: imagePaths as Map<String, List<String>>,
            onChanged: (newValues) {
              print(
                  "[CustomFieldEditor] ✏️ $fullKey multi-selection changed: $newValues");
              final updatedValue = Map<String, dynamic>.from(widget.value);
              if (newValues.isNotEmpty) {
                updatedValue[fullKey] = newValues;
              } else {
                updatedValue.remove(fullKey);
              }
              widget.onChanged(updatedValue);
            },
            onImagesChanged: (newImagePaths) {
              print(
                  "[CustomFieldEditor] ✏️ $fullKey images changed: $newImagePaths");
              final updatedValue = Map<String, dynamic>.from(widget.value);
              updatedValue[fullKey] = {
                ...?updatedValue[fullKey] as Map<String, dynamic>?,
                'image_paths': newImagePaths,
              };
              widget.onChanged(updatedValue);
            },
            isRequired: field.requiredFields?.isNotEmpty ?? false,
          );
        } else {
          return CustomCheckboxGroup(
            label: field.label ?? 'Trường $fieldIndex',
            selectedValues: fieldValue is List<String> ? fieldValue : [],
            options: field.options ?? [],
            onChanged: (newValues) {
              print(
                  "[CustomFieldEditor] ✏️ $fullKey checkbox changed: $newValues");
              final updatedValue = Map<String, dynamic>.from(widget.value);
              if (newValues.isNotEmpty) {
                updatedValue[fullKey] = newValues;
              } else {
                updatedValue.remove(fullKey);
              }
              widget.onChanged(updatedValue);
            },
            isRequired: field.requiredFields?.isNotEmpty ?? false,
            enabled: true,
          );
        }
      case FieldType.fullYearRange:
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(fieldValue?.toString() ?? '') ??
                  DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              final dateValue = DateFormat('yyyy-MM-dd').format(picked);
              print("[CustomFieldEditor] ✏️ $fullKey date changed: $dateValue");
              final updatedValue = Map<String, dynamic>.from(widget.value);
              updatedValue[fullKey] = dateValue;
              widget.onChanged(updatedValue);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: field.label ?? 'Trường $fieldIndex',
              hintText: 'Chọn ngày',
              prefixIcon: const Icon(Icons.calendar_today),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
            ),
            child: Text(
              fieldValue != null &&
                      DateTime.tryParse(fieldValue.toString()) != null
                  ? DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(fieldValue.toString()))
                  : 'Chọn ngày',
            ),
          ),
        );
      case FieldType.custom:
        return CustomFieldEditor(
          groups: field.groups,
          value: fieldValue is Map<String, dynamic> ? fieldValue : {},
          onChanged: (newValue) {
            print("[CustomFieldEditor] ✏️ $fullKey custom changed: $newValue");
            final updatedValue = Map<String, dynamic>.from(widget.value);
            if (newValue.isNotEmpty) {
              updatedValue[fullKey] = newValue;
            } else {
              updatedValue.remove(fullKey);
            }
            widget.onChanged(updatedValue);
          },
        );
      default:
        return Text('Kiểu dữ liệu không hỗ trợ: ${field.type}');
    }
  }
}
