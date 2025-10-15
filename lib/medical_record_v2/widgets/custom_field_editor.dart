import 'package:dr_urticaria/medical_record_v2/widgets/image_upload_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant/color.dart';
import '../../utils/enum/field_type_enum.dart';
import '../../widget/text_field/input_text_field.dart';
import 'custom_checkbox_group.dart';
import 'custom_multiple_choice_with_images.dart';
import 'custom_radio_group.dart';

// class CustomFieldEditor extends StatefulWidget {
//   final List<CustomFieldGroup>? groups;
//   final Map<String, dynamic> value;
//   final ValueChanged<Map<String, dynamic>> onChanged;

//   const CustomFieldEditor({
//     super.key,
//     this.groups,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   State<CustomFieldEditor> createState() => _CustomFieldEditorState();
// }

// class _CustomFieldEditorState extends State<CustomFieldEditor> {
//   final Map<String, TextEditingController> _controllers = {};

//   @override
//   void didUpdateWidget(covariant CustomFieldEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     for (final group in widget.groups ?? []) {
//       for (var i = 0; i < group.fields.length; i++) {
//         final field = group.fields[i];
//         final fieldKey = field.label ?? group.label ?? 'field_$i';
//         final fieldValue = widget.value[fieldKey] ??
//             (field.type == FieldType.custom ? {} : null);
//         if (field.type == FieldType.text || field.type == FieldType.number) {
//           _controllers[fieldKey] ??= TextEditingController();
//           if (_controllers[fieldKey]!.text != (fieldValue?.toString() ?? '')) {
//             _controllers[fieldKey]!.text = fieldValue?.toString() ?? '';
//             print(
//                 "[CustomFieldEditor] 🔄 Updated controller for $fieldKey: ${fieldValue}");
//           }
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controllers.values.forEach((controller) => controller.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.groups == null || widget.groups!.isEmpty) {
//       return const Text('Không có trường dữ liệu');
//     }

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: widget.groups!.asMap().entries.map((entry) {
//           final group = entry.value;
//           final groupIndex = entry.key;
//           return Card(
//             elevation: 1,
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (group.label != null)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Text(
//                         group.label!,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: AppColors.bgBlueDark,
//                         ),
//                       ),
//                     ),
//                   ...group.fields.asMap().entries.map((fieldEntry) {
//                     final field = fieldEntry.value;
//                     final fieldIndex = fieldEntry.key;
//                     final fieldKey =
//                         field.label ?? group.label ?? 'field_$fieldIndex';
//                     final fieldValue = widget.value[fieldKey] ??
//                         (field.type == FieldType.custom ? {} : null);
//                     print(
//                         "[CustomFieldEditor] 🔍 Field: $fieldKey | Value: $fieldValue | Type: ${field.type} | Options: ${field.options}");

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: _buildFieldEditor(
//                         context,
//                         field,
//                         fieldValue,
//                         group,
//                         fieldKey,
//                         groupIndex,
//                         fieldIndex,
//                         '',
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildFieldEditor(
//     BuildContext context,
//     CustomField field,
//     dynamic fieldValue,
//     CustomFieldGroup group,
//     String fieldKey,
//     int groupIndex,
//     int fieldIndex,
//     String prefix,
//   ) {
//     final fullKey = prefix.isEmpty ? fieldKey : '$prefix.$fieldKey';
//     if (field.dependsOn != null && field.dependsOnValues != null) {
//       final parentValue = widget.value[field.dependsOn] as String?;
//       if (parentValue == null ||
//           !field.dependsOnValues!.contains(parentValue)) {
//         return const SizedBox.shrink();
//       }
//     }

//     // Handle nested Map values (e.g., {"Có điều trị hay không?": "Có"})
//     if (field.type == FieldType.select && field.options != null) {
//       final nestedKey = field.label ?? fieldKey;
//       final nestedValue = fieldValue is Map<String, dynamic>
//           ? fieldValue[nestedKey] as String?
//           : null;
//       return CustomRadioGroup(
//         label: field.label ?? 'Trường $fieldIndex',
//         value: nestedValue,
//         options: field.options ?? [],
//         onChanged: (newValue) {
//           print("[CustomFieldEditor] ✏️ $fullKey radio changed: $newValue");
//           final updatedValue = Map<String, dynamic>.from(widget.value);
//           if (newValue != null) {
//             updatedValue[fullKey] = {nestedKey: newValue};
//           } else {
//             updatedValue.remove(fullKey);
//           }
//           widget.onChanged(updatedValue);
//         },
//         isRequired: field.requiredFields?.isNotEmpty ?? false,
//         enabled: true,
//       );
//     }

//     switch (field.type) {
//       case FieldType.text:
//       case FieldType.number:
//         _controllers[fullKey] ??=
//             TextEditingController(text: fieldValue?.toString() ?? '');
//         return InputTextField(
//           label: field.label ?? 'Trường $fieldIndex',
//           keyboardType: field.type == FieldType.number
//               ? TextInputType.numberWithOptions(decimal: true)
//               : TextInputType.text,
//           textController: _controllers[fullKey],
//           validator: (field.requiredFields?.isNotEmpty ?? false)
//               ? (val) =>
//                   val == null || val.isEmpty ? 'Vui lòng điền trường này' : null
//               : null,
//           onChanged: (newValue) {
//             print("[CustomFieldEditor] ✏️ $fullKey changed: $newValue");
//             final updatedValue = Map<String, dynamic>.from(widget.value);
//             if (newValue.isNotEmpty) {
//               updatedValue[fullKey] = field.type == FieldType.number
//                   ? num.tryParse(newValue) ?? newValue
//                   : newValue;
//             } else {
//               updatedValue.remove(fullKey);
//             }
//             widget.onChanged(updatedValue);
//           },
//         );
//       case FieldType.select:
//         return CustomRadioGroup(
//           label: field.label ?? 'Trường $fieldIndex',
//           value: fieldValue is String ? fieldValue : null,
//           options: field.options ?? [],
//           onChanged: (newValue) {
//             print("[CustomFieldEditor] ✏️ $fullKey select changed: $newValue");
//             final updatedValue = Map<String, dynamic>.from(widget.value);
//             if (newValue != null) {
//               updatedValue[fullKey] = newValue;
//             } else {
//               updatedValue.remove(fullKey);
//             }
//             widget.onChanged(updatedValue);
//           },
//           isRequired: field.requiredFields?.isNotEmpty ?? false,
//           enabled: true,
//         );
//       case FieldType.multiSelection:
//         final hasImages = field.options != null &&
//             field.options!.any((opt) => opt.contains('image_upload'));
//         if (hasImages) {
//           final options = field.options ?? [];
//           final subOptions = field.groups!.isNotEmpty
//               ? {
//                   for (var g in field.groups!)
//                     g.label ?? '': g.fields.map((f) => f.label ?? '').toList()
//                 }
//               : null;
//           final imagePaths = fieldValue is Map
//               ? fieldValue['image_paths'] as Map<String, List<String>>? ?? {}
//               : {};
//           return CustomMultipleChoiceWithImages(
//             label: field.label ?? 'Trường $fieldIndex',
//             selectedValues: fieldValue is List<String> ? fieldValue : [],
//             options: options,
//             subOptions: subOptions,
//             imagePaths: imagePaths as Map<String, List<String>>,
//             onChanged: (newValues) {
//               print(
//                   "[CustomFieldEditor] ✏️ $fullKey multi-selection changed: $newValues");
//               final updatedValue = Map<String, dynamic>.from(widget.value);
//               if (newValues.isNotEmpty) {
//                 updatedValue[fullKey] = newValues;
//               } else {
//                 updatedValue.remove(fullKey);
//               }
//               widget.onChanged(updatedValue);
//             },
//             onImagesChanged: (newImagePaths) {
//               print(
//                   "[CustomFieldEditor] ✏️ $fullKey images changed: $newImagePaths");
//               final updatedValue = Map<String, dynamic>.from(widget.value);
//               updatedValue[fullKey] = {
//                 ...?updatedValue[fullKey] as Map<String, dynamic>?,
//                 'image_paths': newImagePaths,
//               };
//               widget.onChanged(updatedValue);
//             },
//             isRequired: field.requiredFields?.isNotEmpty ?? false,
//           );
//         } else {
//           return CustomCheckboxGroup(
//             label: field.label ?? 'Trường $fieldIndex',
//             selectedValues: fieldValue is List<String> ? fieldValue : [],
//             options: field.options ?? [],
//             onChanged: (newValues) {
//               print(
//                   "[CustomFieldEditor] ✏️ $fullKey checkbox changed: $newValues");
//               final updatedValue = Map<String, dynamic>.from(widget.value);
//               if (newValues.isNotEmpty) {
//                 updatedValue[fullKey] = newValues;
//               } else {
//                 updatedValue.remove(fullKey);
//               }
//               widget.onChanged(updatedValue);
//             },
//             isRequired: field.requiredFields?.isNotEmpty ?? false,
//             enabled: true,
//           );
//         }
//       case FieldType.fullYearRange:
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: DateTime.tryParse(fieldValue?.toString() ?? '') ??
//                   DateTime.now(),
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );
//             if (picked != null) {
//               final dateValue = DateFormat('yyyy-MM-dd').format(picked);
//               print("[CustomFieldEditor] ✏️ $fullKey date changed: $dateValue");
//               final updatedValue = Map<String, dynamic>.from(widget.value);
//               updatedValue[fullKey] = dateValue;
//               widget.onChanged(updatedValue);
//             }
//           },
//           child: InputDecorator(
//             decoration: InputDecoration(
//               labelText: field.label ?? 'Trường $fieldIndex',
//               hintText: 'Chọn ngày',
//               prefixIcon: const Icon(Icons.calendar_today),
//               border:
//                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                 ),
//               ),
//             ),
//             child: Text(
//               fieldValue != null &&
//                       DateTime.tryParse(fieldValue.toString()) != null
//                   ? DateFormat('yyyy-MM-dd')
//                       .format(DateTime.parse(fieldValue.toString()))
//                   : 'Chọn ngày',
//             ),
//           ),
//         );
//       case FieldType.custom:
//         return CustomFieldEditor(
//           groups: field.groups,
//           value: fieldValue is Map<String, dynamic> ? fieldValue : {},
//           onChanged: (newValue) {
//             print("[CustomFieldEditor] ✏️ $fullKey custom changed: $newValue");
//             final updatedValue = Map<String, dynamic>.from(widget.value);
//             if (newValue.isNotEmpty) {
//               updatedValue[fullKey] = newValue;
//             } else {
//               updatedValue.remove(fullKey);
//             }
//             widget.onChanged(updatedValue);
//           },
//         );
//       default:
//         return Text('Kiểu dữ liệu không hỗ trợ: ${field.type}');
//     }
//   }
// }
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

  // Split '.' an toàn: không cắt giữa 2 chữ số (vd "6.3 Bàn tay")
  List<String> _splitKeyParts(String key) {
    final parts = <String>[];
    final buf = StringBuffer();
    for (int i = 0; i < key.length; i++) {
      final ch = key[i];
      if (ch == '.') {
        final prevIsDigit = i > 0 && _isDigit(key.codeUnitAt(i - 1));
        final nextIsDigit =
            i + 1 < key.length && _isDigit(key.codeUnitAt(i + 1));
        if (!(prevIsDigit && nextIsDigit)) {
          parts.add(buf.toString());
          buf.clear();
          continue;
        }
      }
      buf.write(ch);
    }
    parts.add(buf.toString());
    return parts;
  }

  bool _isDigit(int c) => c >= 48 && c <= 57;

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
    return flat;
  }

  Map<String, dynamic> _expandFormValue(Map<String, dynamic> flat) {
    final Map<String, dynamic> nested = {};

    void putPath(String path, dynamic value) {
      final parts = _splitKeyParts(path);
      Map<String, dynamic> current = nested;
      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];
        if (i == parts.length - 1) {
          current[part] = value;
        } else {
          current = current.putIfAbsent(part, () => <String, dynamic>{})
              as Map<String, dynamic>;
        }
      }
    }

    flat.forEach((key, value) {
      if (key.contains('.')) {
        putPath(key, value);
      } else {
        final existing = nested[key];
        if (existing is Map && value is Map) {
          nested[key] = {...existing, ...value};
        } else {
          nested[key] = value;
        }
      }
    });

    return nested;
  }

  @override
  void didUpdateWidget(covariant CustomFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final expandedValue = _expandFormValue(widget.value);

    for (final group in widget.groups ?? []) {
      for (var i = 0; i < group.fields.length; i++) {
        final field = group.fields[i];
        final fieldKey = field.label ?? group.label ?? 'field_$i';
        final fieldValue = _getValueByKey(
              expandedValue,
              _fullKey(
                  group.label?.trim() ?? '', field.label?.trim() ?? fieldKey),
            ) ??
            (field.type == FieldType.custom ? {} : null);

        if (field.type == FieldType.text || field.type == FieldType.number) {
          _controllers[fieldKey] ??= TextEditingController();
          final newText = fieldValue?.toString() ?? '';
          if (_controllers[fieldKey]!.text != newText) {
            _controllers[fieldKey]!.text = newText;
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

    final expandedValue = _expandFormValue(widget.value);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.groups!.asMap().entries.map((entry) {
          final group = entry.value;
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
                    final fieldKey =
                        field.label ?? group.label ?? 'field_${fieldEntry.key}';
                    final fullKey = _fullKey(
                      group.label?.trim() ?? '',
                      field.label?.trim() ?? fieldKey,
                    );

                    final resolvedValue =
                        _getValueByKey(expandedValue, fullKey);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: _buildFieldEditor(
                        context,
                        field,
                        resolvedValue,
                        group.label?.trim() ?? '',
                        field.label?.trim() ?? fieldKey,
                        fullKey,
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
    dynamic resolvedValue,
    String groupLabel,
    String fieldLabel,
    String fullKey,
  ) {
    // Điều kiện phụ thuộc (nếu có)
    if (field.dependsOn != null && field.dependsOnValues != null) {
      final depKey = field.dependsOn!;
      final expanded = _expandFormValue(widget.value);
      final depFullKey = groupLabel.isNotEmpty ? '$groupLabel.$depKey' : depKey;
      dynamic parentValue =
          _getValueByKey(expanded, depFullKey) ?? widget.value[depKey];

      if (parentValue is Map<String, dynamic> && parentValue.length == 1) {
        parentValue = parentValue.values.first;
      }
      if (parentValue == null ||
          !field.dependsOnValues!.contains(parentValue.toString())) {
        return const SizedBox.shrink();
      }
    }

    switch (field.type) {
      case FieldType.text:
      case FieldType.number:
        _controllers[fullKey] ??=
            TextEditingController(text: resolvedValue?.toString() ?? '');
        return InputTextField(
          label: field.label ?? '',
          keyboardType: field.type == FieldType.number
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          textController: _controllers[fullKey],
          onChanged: (newValue) {
            final updated = Map<String, dynamic>.from(widget.value);
            if (newValue.isNotEmpty) {
              updated[fullKey] = field.type == FieldType.number
                  ? num.tryParse(newValue) ?? newValue
                  : newValue;
            } else {
              updated.remove(fullKey);
            }
            widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
          },
        );

      case FieldType.select:
        // Hỗ trợ 2 kiểu:
        // - select có ảnh (chuẩn): "key": "Option", "key_image": "URL"
        // - image-only (1 option cố định + bắt buộc ảnh): "key": "URL"
        final needsImage = (field.requiredFields ?? [])
            .any((rf) => rf.type == FieldType.image);
        final options = field.options ?? [];
        final bool imageOnly = needsImage && options.length <= 1;

        if (imageOnly) {
          String? url;
          if (resolvedValue is String && resolvedValue.trim().isNotEmpty) {
            url = resolvedValue;
          } else if (resolvedValue is Map) {
            final k = field.label ?? '';
            url = (resolvedValue['${k}_image'] as String?) ??
                (resolvedValue['image'] as String?);
          }

          return ImageUploadField(
            label: field.label ?? 'Ảnh',
            templateId: 16,
            initialImageUrl: url,
            onChanged: (link) {
              final updated = Map<String, dynamic>.from(widget.value);
              if (link != null && link.isNotEmpty) {
                updated[fullKey] = link; // image-only: "key": "URL"
              } else {
                updated.remove(fullKey);
              }
              widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
            },
          );
        }

        // select + ảnh (chuẩn)
        final expanded = _expandFormValue(widget.value);
        final imageUrl =
            _getValueByKey(expanded, '${fullKey}_image')?.toString();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRadioGroup(
              label: field.label ?? '',
              value: resolvedValue is String ? resolvedValue : null,
              options: field.options ?? [],
              onChanged: (newValue) {
                final updated = Map<String, dynamic>.from(widget.value);
                if (newValue != null && newValue.toString().isNotEmpty) {
                  updated[fullKey] = newValue; // "key": "Option"
                } else {
                  updated.remove(fullKey);
                  updated.remove('${fullKey}_image');
                }
                widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
              },
              isRequired: false,
              enabled: true,
            ),
            if (needsImage &&
                resolvedValue is String &&
                resolvedValue.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ImageUploadField(
                  label: "Ảnh cho $resolvedValue",
                  templateId: 16,
                  initialImageUrl: imageUrl,
                  onChanged: (url) {
                    final updated = Map<String, dynamic>.from(widget.value);
                    if (url != null && url.isNotEmpty) {
                      updated['${fullKey}_image'] = url; // "key_image": "URL"
                    } else {
                      updated.remove('${fullKey}_image');
                    }
                    widget.onChanged(
                        _flattenFormValue(_expandFormValue(updated)));
                  },
                ),
              ),
          ],
        );

      case FieldType.multiSelection:
        final needsImage = (field.requiredFields ?? [])
            .any((rf) => rf.type == FieldType.image);

        if (needsImage) {
          // Map<option, url|null>
          Map<String, String?> selectedWithImages = {};
          List<String> selectedValues = [];

          if (resolvedValue is Map<String, dynamic>) {
            selectedWithImages = resolvedValue.map(
              (k, v) => MapEntry(k, v?.toString()),
            );
            selectedValues = selectedWithImages.keys.toList();
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckboxGroup(
                    label: field.label ?? '',
                    selectedValues: selectedValues,
                    options: field.options ?? [],
                    onChanged: (newValues) {
                      final updated = Map<String, dynamic>.from(widget.value);
                      final data = <String, String?>{};
                      for (final opt in newValues) {
                        data[opt] = selectedWithImages[opt];
                      }
                      if (data.isNotEmpty) {
                        updated[fullKey] = data; // "key": {opt: url|null}
                      } else {
                        updated.remove(fullKey);
                      }
                      setState(() {
                        selectedWithImages = data;
                        selectedValues = newValues;
                      });
                      widget.onChanged(
                          _flattenFormValue(_expandFormValue(updated)));
                    },
                    isRequired: false,
                    enabled: true,
                  ),
                  ...selectedValues.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ImageUploadField(
                        label: "Ảnh cho $option",
                        templateId: 16,
                        initialImageUrl: selectedWithImages[option],
                        onChanged: (imageUrl) {
                          final updated =
                              Map<String, dynamic>.from(widget.value);
                          final current =
                              _getValueByKey(_expandFormValue(updated), fullKey)
                                      as Map<String, dynamic>? ??
                                  {};
                          final next = Map<String, String?>.from(current
                              .map((k, v) => MapEntry(k, v?.toString())));
                          next[option] =
                              (imageUrl != null && imageUrl.isNotEmpty)
                                  ? imageUrl
                                  : null;
                          updated[fullKey] = next;
                          widget.onChanged(
                              _flattenFormValue(_expandFormValue(updated)));
                        },
                      ),
                    );
                  }),
                ],
              );
            },
          );
        } else {
          // List<String>
          return CustomCheckboxGroup(
            label: field.label ?? '',
            selectedValues: resolvedValue is List<String>
                ? resolvedValue
                : (resolvedValue is List
                    ? List<String>.from(resolvedValue.map((e) => e.toString()))
                    : <String>[]),
            options: field.options ?? [],
            onChanged: (newValues) {
              final updated = Map<String, dynamic>.from(widget.value);
              if (newValues.isNotEmpty) {
                updated[fullKey] = newValues; // "key": ["opt1","opt2"]
              } else {
                updated.remove(fullKey);
              }
              widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
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
              final updated = Map<String, dynamic>.from(widget.value);
              updated[fullKey] = DateFormat('yyyy-MM-dd').format(picked);
              widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: field.label ?? '',
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
            final updated = Map<String, dynamic>.from(widget.value);
            if (newValue.isNotEmpty) {
              updated[fullKey] = newValue;
            } else {
              updated.remove(fullKey);
            }
            widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
          },
        );

      default:
        return Text('⚠️ Kiểu dữ liệu không hỗ trợ: ${field.type}');
    }
  }

  String _fullKey(String groupLabel, String fieldLabel) {
    return groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;
  }

  dynamic _getValueByKey(Map<String, dynamic> map, String fullKey) {
    final parts = _splitKeyParts(fullKey);
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
