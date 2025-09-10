import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant/color.dart';
import '../../models/vital_indicator_model.dart';
import '../../utils/enum/field_type_enum.dart';
import '../../widget/text_field/input_text_field.dart';
import 'custom_checkbox_group.dart';
import 'custom_radio_group.dart';
import 'custom_multiple_choice_with_images.dart';
import 'image_upload_field.dart';

class VitalFieldEditor extends StatefulWidget {
  final VitalIndicatorModel indicator;
  final dynamic value;
  final String? unit;
  final ValueChanged<dynamic> onChanged;

  const VitalFieldEditor({
    super.key,
    required this.indicator,
    required this.value,
    this.unit,
    required this.onChanged,
  });

  @override
  State<VitalFieldEditor> createState() => _VitalFieldEditorState();
}

class _VitalFieldEditorState extends State<VitalFieldEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant VitalFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value?.toString() != oldWidget.value?.toString()) {
      _controller.text = widget.value?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suffixIcon = widget.unit != null
        ? Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              widget.unit!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyColor,
                  ),
            ),
          )
        : null;

    switch (parseFieldType(widget.indicator.valueType)) {
      case FieldType.text:
      case FieldType.number:
        return InputTextField(
          label: widget.indicator.name,
          keyboardType: widget.indicator.valueType == 'number'
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          textController: _controller,
          hintText: _rangeHint(),
          onChanged: (newValue) {
            if (widget.indicator.valueType == 'number') {
              final parsedValue = num.tryParse(newValue);
              widget.onChanged(
                  _isValueNotEmpty(parsedValue) ? parsedValue : newValue);
            } else {
              widget.onChanged(_isValueNotEmpty(newValue) ? newValue : '');
            }
          },
        );
      case FieldType.select:
        print("select data ${widget.value}");
        return CustomRadioGroup(
          label: widget.indicator.name,
          value: widget.value is String ? widget.value : null,
          options: widget.indicator.valueOptions is List
              ? List<String>.from(widget.indicator.valueOptions)
              : [],
          onChanged: widget.onChanged,
          isRequired: false,
          enabled: true,
        );
      case FieldType.multiSelection:
        print("multiSelection ${widget.value}");
        print("valueOptions ${widget.indicator.valueOptions}");
        final hasImages = widget.indicator.valueOptions is Map &&
            widget.indicator.valueOptions.containsKey('image_upload');

        if (hasImages) {
          final options = (widget.indicator.valueOptions['options'] as List?)
                  ?.cast<String>() ??
              [];
          final subOptions = widget.indicator.valueOptions['sub_options']
              as Map<String, List<String>>?;
          final imagePaths = widget.value is Map
              ? widget.value['image_paths'] as Map<String, List<String>>? ?? {}
              : {};

          return CustomMultipleChoiceWithImages(
            label: widget.indicator.name,
            selectedValues: widget.value is List<String>
                ? widget.value
                : (widget.value is Map && widget.value['values'] is List
                    ? List<String>.from(widget.value['values'])
                    : []),
            options: options,
            subOptions: subOptions,
            imagePaths: imagePaths as Map<String, List<String>>,
            onChanged: (newValues) {
              if (widget.value is Map) {
                final updatedValue = Map<String, dynamic>.from(widget.value);
                updatedValue['values'] = newValues;
                widget.onChanged(updatedValue);
              } else {
                widget.onChanged(newValues);
              }
            },
            onImagesChanged: (newImagePaths) {
              final updatedValue = Map<String, dynamic>.from(
                  widget.value is Map ? widget.value : {});
              updatedValue['image_paths'] = newImagePaths;
              widget.onChanged(updatedValue);
            },
            isRequired: false,
          );
        } else {
          return CustomCheckboxGroup(
            label: widget.indicator.name,
            selectedValues: widget.value is List
                ? List<String>.from(
                    widget.value.map((e) => e.toString().trim()))
                : (widget.value is Map && widget.value['values'] is List
                    ? List<String>.from(
                        widget.value['values'].map((e) => e.toString().trim()))
                    : []),
            options: widget.indicator.valueOptions is List
                ? List<String>.from(widget.indicator.valueOptions
                    .map((e) => e.toString().trim()))
                : [],
            onChanged: (newValues) {
              if (widget.value is Map) {
                final updatedValue = Map<String, dynamic>.from(widget.value);
                updatedValue['values'] = newValues;
                widget.onChanged(updatedValue);
              } else {
                widget.onChanged(newValues);
              }
            },
            isRequired: false,
            enabled: true,
          );
        }
      case FieldType.fullYearRange:
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(widget.value?.toString() ?? '') ??
                  DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              widget.onChanged(DateFormat('yyyy-MM-dd').format(picked));
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.indicator.name,
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
              widget.value != null &&
                      DateTime.tryParse(widget.value.toString()) != null
                  ? DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(widget.value.toString()))
                  : 'Chọn ngày',
            ),
          ),
        );
      case FieldType.custom:
        print("custom data VitalFieldEditor ${widget.value}");
        return CustomFieldEditor(
          groups: widget.indicator.valueOptions != null
              ? CustomField.fromJson(widget.indicator.valueOptions).groups
              : [],
          value: widget.value is Map ? widget.value : {},
          onChanged: widget.onChanged,
        );

      default:
        return Text('Kiểu dữ liệu không hỗ trợ: ${widget.indicator.valueType}');
    }
  }

  String? _rangeHint() {
    final min = widget.indicator.minValue;
    final max = widget.indicator.maxValue;
    if (min != null || max != null) {
      return 'Giới hạn: ${min?.toString() ?? "−∞"} ~ ${max?.toString() ?? "+∞"}';
    }
    return null;
  }

  bool _isValueNotEmpty(dynamic val) {
    if (val == null) return false;
    if (val is String) return val.trim().isNotEmpty;
    if (val is num) return true;
    if (val is List) return val.isNotEmpty;
    if (val is Map) return val.isNotEmpty;
    return true;
  }
}

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

  /// --- 🔑 FLATTEN ---
  Map<String, dynamic> _flattenFormValue(
    Map<String, dynamic> nested, {
    String prefix = '',
  }) {
    final Map<String, dynamic> flat = {};
    nested.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        flat.addAll(_flattenFormValue(value, prefix: newKey));
      } else {
        if (value != null && value.toString().trim().isNotEmpty) {
          flat[newKey] = value;
        }
      }
    });

    print("🔥 FLATTEN (prefix=$prefix) => $flat");
    return flat;
  }

  /// --- 🔑 EXPAND ---
  Map<String, dynamic> _expandFormValue(Map<String, dynamic> flat) {
    final Map<String, dynamic> nested = {};

    flat.forEach((key, value) {
      final parts = key.split('.');
      Map<String, dynamic> current = nested;

      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];

        if (i == parts.length - 1) {
          if (value is Map<String, dynamic> &&
              value.length == 1 &&
              value.containsKey(part)) {
            // 🔥 Nếu value lại bọc lặp chính part thì unwrap
            current[part] = value[part];
          } else {
            current[part] = value;
          }
        } else {
          current = current.putIfAbsent(part, () => <String, dynamic>{})
              as Map<String, dynamic>;
        }
      }
    });

    print("✅ EXPAND (fixed) => $nested");
    return nested;
  }

  @override
  void didUpdateWidget(covariant CustomFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    // luôn expand lại để hiển thị
    final expandedValue = _expandFormValue(widget.value);

    for (final group in widget.groups ?? []) {
      for (var i = 0; i < group.fields.length; i++) {
        final field = group.fields[i];
        final fieldKey = field.label ?? group.label ?? 'field_$i';
        final fieldValue = expandedValue[fieldKey] ??
            (field.type == FieldType.custom ? {} : null);

        if (field.type == FieldType.text || field.type == FieldType.number) {
          _controllers[fieldKey] ??= TextEditingController();
          if (_controllers[fieldKey]!.text != (fieldValue?.toString() ?? '')) {
            _controllers[fieldKey]!.text = fieldValue?.toString() ?? '';
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

    // --- Expand value để build ---
    final expandedValue = _expandFormValue(widget.value);

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
                    final fieldValue = expandedValue[fieldKey] ??
                        (field.type == FieldType.custom ? {} : null);

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
                        '', // Changed to empty string to avoid duplication
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
    final expandedValue = _expandFormValue(widget.value);

    // --- 🔑 Sinh fullKey: prefix.groupLabel.fieldLabel ---
    final groupLabel = group.label?.trim() ?? '';
    final fieldLabel = field.label?.trim() ??
        (groupLabel.isNotEmpty ? groupLabel : 'field_$fieldIndex');

    final keys = <String>[];
    if (prefix.isNotEmpty) keys.add(prefix);
    if (groupLabel.isNotEmpty) keys.add(groupLabel);
    keys.add(fieldLabel);
    final fullKey = keys.join('.');

    // --- 🔎 Resolve value bằng cách split key ---
    dynamic resolvedValue = _getValueByKey(expandedValue, fullKey);

    // --- Nếu bị bọc lặp key => unwrap (for all types) ---
    if (resolvedValue is Map<String, dynamic> && resolvedValue.length == 1) {
      final innerKey = resolvedValue.keys.first;
      if (innerKey == fieldLabel) {
        resolvedValue = resolvedValue[innerKey];
      }
    }

    // --- Additional unwrap for custom if needed ---
    if (field.type == FieldType.custom &&
        resolvedValue is Map &&
        resolvedValue.length == 1) {
      final innerKey = resolvedValue.keys.first;
      final innerVal = resolvedValue[innerKey];
      if (innerVal is Map &&
          innerVal.length == 1 &&
          innerVal.containsKey(innerKey)) {
        resolvedValue = innerVal[innerKey];
      }
    }

    debugPrint(
        "🎯 build field: fullKey=$fullKey, label=$fieldLabel, resolvedValue=$resolvedValue");

    // Nếu field có điều kiện hiển thị
    if (field.dependsOn != null && field.dependsOnValues != null) {
      dynamic parentValue = widget.value[field.dependsOn];
      if (parentValue is Map<String, dynamic> && parentValue.length == 1) {
        parentValue = parentValue.values.first;
      }
      if (parentValue == null ||
          !field.dependsOnValues!.contains(parentValue.toString())) {
        return const SizedBox.shrink();
      }
    }

    // --- Render widget theo type ---
    switch (field.type) {
      case FieldType.text:
      case FieldType.number:
        _controllers[fullKey] ??=
            TextEditingController(text: resolvedValue?.toString() ?? '');
        return InputTextField(
          label: field.label ?? 'Trường $fieldIndex',
          keyboardType: field.type == FieldType.number
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          textController: _controllers[fullKey],
          onChanged: (newValue) {
            final updatedValue = Map<String, dynamic>.from(widget.value);
            if (newValue.isNotEmpty) {
              updatedValue[fullKey] = field.type == FieldType.number
                  ? num.tryParse(newValue) ?? newValue
                  : newValue;
            } else {
              updatedValue.remove(fullKey);
            }
            widget.onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
          },
        );

      case FieldType.select:
        return CustomRadioGroup(
          label: field.label ?? 'Trường $fieldIndex',
          value: resolvedValue is String ? resolvedValue : null,
          options: field.options ?? [],
          onChanged: (newValue) {
            final updatedValue = Map<String, dynamic>.from(widget.value);
            if (newValue != null) {
              updatedValue[fullKey] = newValue;
            } else {
              updatedValue.remove(fullKey);
            }
            widget.onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
          },
          isRequired: false,
          enabled: true,
        );

      case FieldType.multiSelection:
        final needsImage = (field.requiredFields ?? [])
            .any((rf) => rf.type == FieldType.image);

        if (needsImage) {
          Map<String, String?> selectedOptionsWithImages = {};
          List<String> selectedValues = [];

          if (resolvedValue is Map<String, dynamic>) {
            selectedOptionsWithImages = Map<String, String?>.from(
                resolvedValue.map((k, v) => MapEntry(k, v?.toString())));
            selectedValues = selectedOptionsWithImages.keys.toList();
          }
          debugPrint(
              "🔎 multiSelection: resolvedValue=$resolvedValue, selectedValues=$selectedValues");

          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckboxGroup(
                    label: field.label ?? 'Trường $fieldIndex',
                    selectedValues: selectedValues,
                    options: field.options ?? [],
                    onChanged: (newValues) {
                      final updatedValue =
                          Map<String, dynamic>.from(widget.value);
                      final newOptionsWithImages = <String, String?>{};

                      for (String option in newValues) {
                        newOptionsWithImages[option] =
                            selectedOptionsWithImages[option] ?? null;
                      }

                      if (newOptionsWithImages.isNotEmpty) {
                        updatedValue[fullKey] = newOptionsWithImages;
                      } else {
                        updatedValue.remove(fullKey);
                      }
                      debugPrint("✅ Selected options: $newValues");
                      setState(() {
                        selectedOptionsWithImages = newOptionsWithImages;
                        selectedValues = newValues;
                      });
                      widget.onChanged(
                          _flattenFormValue(_expandFormValue(updatedValue)));
                    },
                    isRequired: false,
                    enabled: true,
                  ),
                  ...selectedValues.map((option) {
                    debugPrint(
                        "🔍 Rendering ImageUploadField for option: $option");
                    final requiredField =
                        (field.requiredFields ?? []).firstWhere(
                      (rf) => rf.type == FieldType.image,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ImageUploadField(
                        label: requiredField.description ?? "Ảnh cho $option",
                        templateId: 16,
                        initialImageUrl: selectedOptionsWithImages[option],
                        onChanged: (imageUrl) {
                          debugPrint("📸 Image changed for $option: $imageUrl");
                          final updatedValue =
                              Map<String, dynamic>.from(widget.value);
                          final currentData = _getValueByKey(
                                      _expandFormValue(updatedValue), fullKey)
                                  as Map<String, dynamic>? ??
                              {};
                          final updatedData = Map<String, String?>.from(
                              currentData
                                  .map((k, v) => MapEntry(k, v?.toString())));

                          if (imageUrl != null && imageUrl.isNotEmpty) {
                            updatedData[option] = imageUrl;
                          } else {
                            updatedData[option] = null;
                          }

                          updatedValue[fullKey] = updatedData;
                          widget.onChanged(_flattenFormValue(
                              _expandFormValue(updatedValue)));
                        },
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          );
        } else {
          // Standard multiSelection without images
          return CustomCheckboxGroup(
            label: field.label ?? 'Trường $fieldIndex',
            selectedValues: resolvedValue is List<String>
                ? resolvedValue
                : (resolvedValue is List
                    ? List<String>.from(resolvedValue.map((e) => e.toString()))
                    : []),
            options: field.options ?? [],
            onChanged: (newValues) {
              final updatedValue = Map<String, dynamic>.from(widget.value);
              if (newValues.isNotEmpty) {
                updatedValue[fullKey] = newValues;
              } else {
                updatedValue.remove(fullKey);
              }
              widget
                  .onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
            },
            isRequired: false,
            enabled: true,
          );
        }

      case FieldType.fullYearRange:
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(resolvedValue?.toString() ?? '') ??
                  DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              final updatedValue = Map<String, dynamic>.from(widget.value);
              updatedValue[fullKey] = DateFormat('yyyy-MM-dd').format(picked);
              widget
                  .onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: field.label ?? 'Trường $fieldIndex',
              hintText: 'Chọn ngày',
              prefixIcon: const Icon(Icons.calendar_today),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              resolvedValue != null &&
                      DateTime.tryParse(resolvedValue.toString()) != null
                  ? DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(resolvedValue.toString()))
                  : 'Chọn ngày',
            ),
          ),
        );

      case FieldType.custom:
        return CustomFieldEditor(
          groups: field.groups,
          value: resolvedValue is Map<String, dynamic> ? resolvedValue : {},
          onChanged: (newValue) {
            final updatedValue = Map<String, dynamic>.from(widget.value);
            if (newValue.isNotEmpty) {
              updatedValue[fullKey] = newValue;
            } else {
              updatedValue.remove(fullKey);
            }
            widget.onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
          },
        );

      default:
        return Text('⚠️ Kiểu dữ liệu không hỗ trợ: ${field.type}');
    }
  }

  dynamic _getValueByKey(Map<String, dynamic> map, String fullKey) {
    final parts = fullKey.split('.');
    dynamic current = map;
    for (final part in parts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return null;
      }
    }
    return current;
  }
}
