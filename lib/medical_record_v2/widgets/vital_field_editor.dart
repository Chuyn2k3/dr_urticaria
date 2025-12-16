// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../constant/color.dart';
// import '../../models/vital_indicator_model.dart';
// import '../../utils/enum/field_type_enum.dart';
// import '../../widget/text_field/input_text_field.dart';
// import 'custom_checkbox_group.dart';
// import 'custom_radio_group.dart';
// import 'custom_multiple_choice_with_images.dart';
// import 'image_upload_field.dart';

// class VitalFieldEditor extends StatefulWidget {
//   final VitalIndicatorModel indicator;
//   final dynamic value;
//   final String? unit;
//   final ValueChanged<dynamic> onChanged;

//   const VitalFieldEditor({
//     super.key,
//     required this.indicator,
//     required this.value,
//     this.unit,
//     required this.onChanged,
//   });

//   @override
//   State<VitalFieldEditor> createState() => _VitalFieldEditorState();
// }

// class _VitalFieldEditorState extends State<VitalFieldEditor> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.value?.toString() ?? '');
//   }

//   @override
//   void didUpdateWidget(covariant VitalFieldEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.value?.toString() != oldWidget.value?.toString()) {
//       _controller.text = widget.value?.toString() ?? '';
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final suffixIcon = widget.unit != null
//         ? Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: Text(
//               widget.unit!,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: AppColors.greyColor,
//                   ),
//             ),
//           )
//         : null;

//     switch (parseFieldType(widget.indicator.valueType)) {
//       case FieldType.text:
//       case FieldType.number:
//         return InputTextField(
//           label: widget.indicator.name,
//           keyboardType: widget.indicator.valueType == 'number'
//               ? TextInputType.numberWithOptions(decimal: true)
//               : TextInputType.text,
//           textController: _controller,
//           hintText: _rangeHint(),
//           onChanged: (newValue) {
//             if (widget.indicator.valueType == 'number') {
//               final parsedValue = num.tryParse(newValue);
//               widget.onChanged(
//                   _isValueNotEmpty(parsedValue) ? parsedValue : newValue);
//             } else {
//               widget.onChanged(_isValueNotEmpty(newValue) ? newValue : '');
//             }
//           },
//         );
//       case FieldType.select:
//         print("select data ${widget.value}");
//         return CustomRadioGroup(
//           label: widget.indicator.name,
//           value: widget.value is String ? widget.value : null,
//           options: widget.indicator.valueOptions is List
//               ? List<String>.from(widget.indicator.valueOptions)
//               : [],
//           onChanged: widget.onChanged,
//           isRequired: false,
//           enabled: true,
//         );
//       case FieldType.multiSelection:
//         print("multiSelection ${widget.value}");
//         print("valueOptions ${widget.indicator.valueOptions}");
//         final hasImages = widget.indicator.valueOptions is Map &&
//             widget.indicator.valueOptions.containsKey('image_upload');

//         if (hasImages) {
//           final options = (widget.indicator.valueOptions['options'] as List?)
//                   ?.cast<String>() ??
//               [];
//           final subOptions = widget.indicator.valueOptions['sub_options']
//               as Map<String, List<String>>?;
//           final imagePaths = widget.value is Map
//               ? widget.value['image_paths'] as Map<String, List<String>>? ?? {}
//               : {};

//           return CustomMultipleChoiceWithImages(
//             label: widget.indicator.name,
//             selectedValues: widget.value is List<String>
//                 ? widget.value
//                 : (widget.value is Map && widget.value['values'] is List
//                     ? List<String>.from(widget.value['values'])
//                     : []),
//             options: options,
//             subOptions: subOptions,
//             imagePaths: imagePaths as Map<String, List<String>>,
//             onChanged: (newValues) {
//               if (widget.value is Map) {
//                 final updatedValue = Map<String, dynamic>.from(widget.value);
//                 updatedValue['values'] = newValues;
//                 widget.onChanged(updatedValue);
//               } else {
//                 widget.onChanged(newValues);
//               }
//             },
//             onImagesChanged: (newImagePaths) {
//               final updatedValue = Map<String, dynamic>.from(
//                   widget.value is Map ? widget.value : {});
//               updatedValue['image_paths'] = newImagePaths;
//               widget.onChanged(updatedValue);
//             },
//             isRequired: false,
//           );
//         } else {
//           return CustomCheckboxGroup(
//             label: widget.indicator.name,
//             selectedValues: widget.value is List
//                 ? List<String>.from(
//                     widget.value.map((e) => e.toString().trim()))
//                 : (widget.value is Map && widget.value['values'] is List
//                     ? List<String>.from(
//                         widget.value['values'].map((e) => e.toString().trim()))
//                     : []),
//             options: widget.indicator.valueOptions is List
//                 ? List<String>.from(widget.indicator.valueOptions
//                     .map((e) => e.toString().trim()))
//                 : [],
//             onChanged: (newValues) {
//               if (widget.value is Map) {
//                 final updatedValue = Map<String, dynamic>.from(widget.value);
//                 updatedValue['values'] = newValues;
//                 widget.onChanged(updatedValue);
//               } else {
//                 widget.onChanged(newValues);
//               }
//             },
//             isRequired: false,
//             enabled: true,
//           );
//         }
//       case FieldType.fullDate:
//         final dateValue = widget.value is String && widget.value.isNotEmpty
//             ? DateTime.tryParse(widget.value)
//             : null;

//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context, // ✅ sửa lại context
//               initialDate: dateValue ?? DateTime.now(),
//               firstDate: DateTime(1970),
//               lastDate: DateTime(2100),
//             );
//             if (picked != null) {
//               widget.onChanged(picked.toIso8601String());
//             }
//           },
//           child: IgnorePointer(
//             child: InputTextField(
//               label: widget.indicator.name,
//               enabled: false,
//               prefixIcon: const Icon(Icons.calendar_today),
//               textController: TextEditingController(
//                 text: dateValue != null
//                     ? "${dateValue.day.toString().padLeft(2, '0')}/"
//                         "${dateValue.month.toString().padLeft(2, '0')}/"
//                         "${dateValue.year}"
//                     : '',
//               ),
//             ),
//           ),
//         );
//       case FieldType.fullYearRange:
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: DateTime.tryParse(widget.value?.toString() ?? '') ??
//                   DateTime.now(),
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );
//             if (picked != null) {
//               widget.onChanged(DateFormat('yyyy-MM-dd').format(picked));
//             }
//           },
//           child: InputDecorator(
//             decoration: InputDecoration(
//               labelText: widget.indicator.name,
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
//               widget.value != null &&
//                       DateTime.tryParse(widget.value.toString()) != null
//                   ? DateFormat('yyyy-MM-dd')
//                       .format(DateTime.parse(widget.value.toString()))
//                   : 'Chọn ngày',
//             ),
//           ),
//         );
//       case FieldType.custom:
//         print("custom data VitalFieldEditor ${widget.value}");
//         return CustomFieldEditor(
//           groups: widget.indicator.valueOptions != null
//               ? CustomField.fromJson(widget.indicator.valueOptions).groups
//               : [],
//           value: widget.value is Map ? widget.value : {},
//           onChanged: widget.onChanged,
//         );

//       default:
//         return Text('Kiểu dữ liệu không hỗ trợ: ${widget.indicator.valueType}');
//     }
//   }

//   String? _rangeHint() {
//     final min = widget.indicator.minValue;
//     final max = widget.indicator.maxValue;
//     if (min != null || max != null) {
//       return 'Giới hạn: ${min?.toString() ?? "−∞"} ~ ${max?.toString() ?? "+∞"}';
//     }
//     return null;
//   }

//   bool _isValueNotEmpty(dynamic val) {
//     if (val == null) return false;
//     if (val is String) return val.trim().isNotEmpty;
//     if (val is num) return true;
//     if (val is List) return val.isNotEmpty;
//     if (val is Map) return val.isNotEmpty;
//     return true;
//   }
// }

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

//   /// --- 🔑 FLATTEN ---
//   Map<String, dynamic> _flattenFormValue(
//     Map<String, dynamic> nested, {
//     String prefix = '',
//   }) {
//     final Map<String, dynamic> flat = {};
//     nested.forEach((key, value) {
//       final newKey = prefix.isEmpty ? key : '$prefix.$key';
//       if (value is Map<String, dynamic>) {
//         flat.addAll(_flattenFormValue(value, prefix: newKey));
//       } else {
//         if (value != null && value.toString().trim().isNotEmpty) {
//           flat[newKey] = value;
//         }
//       }
//     });

//     print("🔥 FLATTEN (prefix=$prefix) => $flat");
//     return flat;
//   }

//   /// --- 🔑 EXPAND ---
//   Map<String, dynamic> _expandFormValue(Map<String, dynamic> flat) {
//     final Map<String, dynamic> nested = {};

//     flat.forEach((key, value) {
//       final parts = key.split('.');
//       Map<String, dynamic> current = nested;

//       for (int i = 0; i < parts.length; i++) {
//         final part = parts[i];

//         if (i == parts.length - 1) {
//           if (value is Map<String, dynamic> &&
//               value.length == 1 &&
//               value.containsKey(part)) {
//             // 🔥 Nếu value lại bọc lặp chính part thì unwrap
//             current[part] = value[part];
//           } else {
//             current[part] = value;
//           }
//         } else {
//           current = current.putIfAbsent(part, () => <String, dynamic>{})
//               as Map<String, dynamic>;
//         }
//       }
//     });

//     print("✅ EXPAND (fixed) => $nested");
//     return nested;
//   }

//   @override
//   void didUpdateWidget(covariant CustomFieldEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     // luôn expand lại để hiển thị
//     final expandedValue = _expandFormValue(widget.value);

//     for (final group in widget.groups ?? []) {
//       for (var i = 0; i < group.fields.length; i++) {
//         final field = group.fields[i];
//         final fieldKey = field.label ?? group.label ?? 'field_$i';
//         final fieldValue = expandedValue[fieldKey] ??
//             (field.type == FieldType.custom ? {} : null);

//         if (field.type == FieldType.text || field.type == FieldType.number) {
//           _controllers[fieldKey] ??= TextEditingController();
//           if (_controllers[fieldKey]!.text != (fieldValue?.toString() ?? '')) {
//             _controllers[fieldKey]!.text = fieldValue?.toString() ?? '';
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

//     // --- Expand value để build ---
//     final expandedValue = _expandFormValue(widget.value);

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
//                     final fieldValue = expandedValue[fieldKey] ??
//                         (field.type == FieldType.custom ? {} : null);

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
//                         '', // Changed to empty string to avoid duplication
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
//     final expandedValue = _expandFormValue(widget.value);

//     // --- 🔑 Sinh fullKey: prefix.groupLabel.fieldLabel ---
//     final groupLabel = group.label?.trim() ?? '';
//     final fieldLabel = field.label?.trim() ??
//         (groupLabel.isNotEmpty ? groupLabel : 'field_$fieldIndex');

//     final keys = <String>[];
//     if (prefix.isNotEmpty) keys.add(prefix);
//     if (groupLabel.isNotEmpty) keys.add(groupLabel);
//     keys.add(fieldLabel);
//     final fullKey = keys.join('.');

//     // --- 🔎 Resolve value bằng cách split key ---
//     dynamic resolvedValue = _getValueByKey(expandedValue, fullKey);

//     // --- Nếu bị bọc lặp key => unwrap (for all types) ---
//     if (resolvedValue is Map<String, dynamic> && resolvedValue.length == 1) {
//       final innerKey = resolvedValue.keys.first;
//       if (innerKey == fieldLabel) {
//         resolvedValue = resolvedValue[innerKey];
//       }
//     }

//     // --- Additional unwrap for custom if needed ---
//     if (field.type == FieldType.custom &&
//         resolvedValue is Map &&
//         resolvedValue.length == 1) {
//       final innerKey = resolvedValue.keys.first;
//       final innerVal = resolvedValue[innerKey];
//       if (innerVal is Map &&
//           innerVal.length == 1 &&
//           innerVal.containsKey(innerKey)) {
//         resolvedValue = innerVal[innerKey];
//       }
//     }

//     debugPrint(
//         "🎯 build field: fullKey=$fullKey, label=$fieldLabel, resolvedValue=$resolvedValue");

//     // Nếu field có điều kiện hiển thị
//     if (field.dependsOn != null && field.dependsOnValues != null) {
//       dynamic parentValue = widget.value[field.dependsOn];
//       if (parentValue is Map<String, dynamic> && parentValue.length == 1) {
//         parentValue = parentValue.values.first;
//       }
//       if (parentValue == null ||
//           !field.dependsOnValues!.contains(parentValue.toString())) {
//         return const SizedBox.shrink();
//       }
//     }

//     // --- Render widget theo type ---
//     switch (field.type) {
//       case FieldType.text:
//       case FieldType.number:
//         _controllers[fullKey] ??=
//             TextEditingController(text: resolvedValue?.toString() ?? '');
//         return InputTextField(
//           label: field.label ?? 'Trường $fieldIndex',
//           keyboardType: field.type == FieldType.number
//               ? const TextInputType.numberWithOptions(decimal: true)
//               : TextInputType.text,
//           textController: _controllers[fullKey],
//           onChanged: (newValue) {
//             final updatedValue = Map<String, dynamic>.from(widget.value);
//             if (newValue.isNotEmpty) {
//               updatedValue[fullKey] = field.type == FieldType.number
//                   ? num.tryParse(newValue) ?? newValue
//                   : newValue;
//             } else {
//               updatedValue.remove(fullKey);
//             }
//             widget.onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
//           },
//         );

//       case FieldType.select:
//         return CustomRadioGroup(
//           label: field.label ?? 'Trường $fieldIndex',
//           value: resolvedValue is String ? resolvedValue : null,
//           options: field.options ?? [],
//           onChanged: (newValue) {
//             final updatedValue = Map<String, dynamic>.from(widget.value);
//             if (newValue != null) {
//               updatedValue[fullKey] = newValue;
//             } else {
//               updatedValue.remove(fullKey);
//             }
//             widget.onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
//           },
//           isRequired: false,
//           enabled: true,
//         );

//       case FieldType.multiSelection:
//         final needsImage = (field.requiredFields ?? [])
//             .any((rf) => rf.type == FieldType.image);

//         if (needsImage) {
//           Map<String, String?> selectedOptionsWithImages = {};
//           List<String> selectedValues = [];

//           if (resolvedValue is Map<String, dynamic>) {
//             selectedOptionsWithImages = Map<String, String?>.from(
//                 resolvedValue.map((k, v) => MapEntry(k, v?.toString())));
//             selectedValues = selectedOptionsWithImages.keys.toList();
//           }
//           debugPrint(
//               "🔎 multiSelection: resolvedValue=$resolvedValue, selectedValues=$selectedValues");

//           return StatefulBuilder(
//             builder: (context, setState) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomCheckboxGroup(
//                     label: field.label ?? 'Trường $fieldIndex',
//                     selectedValues: selectedValues,
//                     options: field.options ?? [],
//                     onChanged: (newValues) {
//                       final updatedValue =
//                           Map<String, dynamic>.from(widget.value);
//                       final newOptionsWithImages = <String, String?>{};

//                       for (String option in newValues) {
//                         newOptionsWithImages[option] =
//                             selectedOptionsWithImages[option] ?? null;
//                       }

//                       if (newOptionsWithImages.isNotEmpty) {
//                         updatedValue[fullKey] = newOptionsWithImages;
//                       } else {
//                         updatedValue.remove(fullKey);
//                       }
//                       debugPrint("✅ Selected options: $newValues");
//                       setState(() {
//                         selectedOptionsWithImages = newOptionsWithImages;
//                         selectedValues = newValues;
//                       });
//                       widget.onChanged(
//                           _flattenFormValue(_expandFormValue(updatedValue)));
//                     },
//                     isRequired: false,
//                     enabled: true,
//                   ),
//                   ...selectedValues.map((option) {
//                     debugPrint(
//                         "🔍 Rendering ImageUploadField for option: $option");
//                     final requiredField =
//                         (field.requiredFields ?? []).firstWhere(
//                       (rf) => rf.type == FieldType.image,
//                     );

//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: ImageUploadField(
//                         label: requiredField.description ?? "Ảnh cho $option",
//                         templateId: 16,
//                         initialImageUrl: selectedOptionsWithImages[option],
//                         onChanged: (imageUrl) {
//                           debugPrint("📸 Image changed for $option: $imageUrl");
//                           final updatedValue =
//                               Map<String, dynamic>.from(widget.value);
//                           final currentData = _getValueByKey(
//                                       _expandFormValue(updatedValue), fullKey)
//                                   as Map<String, dynamic>? ??
//                               {};
//                           final updatedData = Map<String, String?>.from(
//                               currentData
//                                   .map((k, v) => MapEntry(k, v?.toString())));

//                           if (imageUrl != null && imageUrl.isNotEmpty) {
//                             updatedData[option] = imageUrl;
//                           } else {
//                             updatedData[option] = null;
//                           }

//                           updatedValue[fullKey] = updatedData;
//                           widget.onChanged(_flattenFormValue(
//                               _expandFormValue(updatedValue)));
//                         },
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               );
//             },
//           );
//         } else {
//           // Standard multiSelection without images
//           return CustomCheckboxGroup(
//             label: field.label ?? 'Trường $fieldIndex',
//             selectedValues: resolvedValue is List<String>
//                 ? resolvedValue
//                 : (resolvedValue is List
//                     ? List<String>.from(resolvedValue.map((e) => e.toString()))
//                     : []),
//             options: field.options ?? [],
//             onChanged: (newValues) {
//               final updatedValue = Map<String, dynamic>.from(widget.value);
//               if (newValues.isNotEmpty) {
//                 updatedValue[fullKey] = newValues;
//               } else {
//                 updatedValue.remove(fullKey);
//               }
//               widget
//                   .onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
//             },
//             isRequired: false,
//             enabled: true,
//           );
//         }

//       case FieldType.fullYearRange:
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: DateTime.tryParse(resolvedValue?.toString() ?? '') ??
//                   DateTime.now(),
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );
//             if (picked != null) {
//               final updatedValue = Map<String, dynamic>.from(widget.value);
//               updatedValue[fullKey] = DateFormat('yyyy-MM-dd').format(picked);
//               widget
//                   .onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
//             }
//           },
//           child: InputDecorator(
//             decoration: InputDecoration(
//               labelText: field.label ?? 'Trường $fieldIndex',
//               hintText: 'Chọn ngày',
//               prefixIcon: const Icon(Icons.calendar_today),
//               border:
//                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             child: Text(
//               resolvedValue != null &&
//                       DateTime.tryParse(resolvedValue.toString()) != null
//                   ? DateFormat('yyyy-MM-dd')
//                       .format(DateTime.parse(resolvedValue.toString()))
//                   : 'Chọn ngày',
//             ),
//           ),
//         );

//       case FieldType.custom:
//         return CustomFieldEditor(
//           groups: field.groups,
//           value: resolvedValue is Map<String, dynamic> ? resolvedValue : {},
//           onChanged: (newValue) {
//             final updatedValue = Map<String, dynamic>.from(widget.value);
//             if (newValue.isNotEmpty) {
//               updatedValue[fullKey] = newValue;
//             } else {
//               updatedValue.remove(fullKey);
//             }
//             widget.onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
//           },
//         );

//       default:
//         return Text('⚠️ Kiểu dữ liệu không hỗ trợ: ${field.type}');
//     }
//   }

//   dynamic _getValueByKey(Map<String, dynamic> map, String fullKey) {
//     final parts = fullKey.split('.');
//     dynamic current = map;
//     for (final part in parts) {
//       if (current is Map<String, dynamic> && current.containsKey(part)) {
//         current = current[part];
//       } else {
//         return null;
//       }
//     }
//     return current;
//   }
// }
import 'package:dr_urticaria/medical_record_v2/widgets/custom_field_editor.dart';
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

/// ---------------------------------------------------------------------------
/// VitalFieldEditor
/// - Đọc/ghi giá trị thep QUY ƯỚC app bệnh nhân:
///   * Key phẳng: "Group.Field"
///   * Ảnh đi kèm select: "Group.Field_image"
///   * Multi selection có ảnh: { "opt1": "<url|null>", "opt2": "<url|null>" }
///   * Case đặc biệt 65/190 trên indicator-level: {
///       "<IndicatorName>_radio": "...",
///       "<IndicatorId>": [ ... ]
///     }
/// ---------------------------------------------------------------------------
// class VitalFieldEditor extends StatefulWidget {
//   final VitalIndicatorModel indicator;
//   final dynamic value;
//   final String? unit;
//   final ValueChanged<dynamic> onChanged;

//   const VitalFieldEditor({
//     super.key,
//     required this.indicator,
//     required this.value,
//     this.unit,
//     required this.onChanged,
//   });

//   @override
//   State<VitalFieldEditor> createState() => _VitalFieldEditorState();
// }

// class _VitalFieldEditorState extends State<VitalFieldEditor> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.value?.toString() ?? '');
//   }

//   @override
//   void didUpdateWidget(covariant VitalFieldEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.value?.toString() != oldWidget.value?.toString()) {
//       _controller.text = widget.value?.toString() ?? '';
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (parseFieldType(widget.indicator.valueType)) {
//       case FieldType.text:
//       case FieldType.number:
//         return InputTextField(
//           label: widget.indicator.name,
//           keyboardType: widget.indicator.valueType == 'number'
//               ? const TextInputType.numberWithOptions(decimal: true)
//               : TextInputType.text,
//           textController: _controller,
//           hintText: _rangeHint(),
//           onChanged: (newValue) {
//             if (widget.indicator.valueType == 'number') {
//               final parsedValue = num.tryParse(newValue);
//               widget.onChanged(
//                   _isValueNotEmpty(parsedValue) ? parsedValue : newValue);
//             } else {
//               widget.onChanged(_isValueNotEmpty(newValue) ? newValue : '');
//             }
//           },
//         );

//       case FieldType.select:
//         // Đọc select theo kiểu bệnh nhân. Nếu custom có ảnh, ImageUpload sẽ xuất hiện ở CustomFieldEditor.
//         return CustomRadioGroup(
//           label: widget.indicator.name,
//           value: widget.value is String ? widget.value : null,
//           options: widget.indicator.valueOptions is List
//               ? List<String>.from(widget.indicator.valueOptions)
//               : [],
//           onChanged: widget.onChanged,
//           isRequired: false,
//           enabled: true,
//         );

//       case FieldType.multiSelection:
//         // 1) Hỗ trợ kiểu có ảnh (indicator-level): valueOptions là Map có 'image_upload'
//         final hasImages = widget.indicator.valueOptions is Map &&
//             (widget.indicator.valueOptions as Map).containsKey('image_upload');

//         if (hasImages) {
//           final options = (widget.indicator.valueOptions['options'] as List?)
//                   ?.cast<String>() ??
//               [];
//           final subOptions = widget.indicator.valueOptions['sub_options']
//               as Map<String, List<String>>?;
//           final imagePaths = widget.value is Map
//               ? (widget.value['image_paths'] as Map?)
//                       ?.cast<String, List<String>>() ??
//                   {}
//               : <String, List<String>>{};
//           print("image path $imagePaths");
//           return CustomMultipleChoiceWithImages(
//             label: widget.indicator.name,
//             selectedValues: widget.value is List<String>
//                 ? widget.value
//                 : (widget.value is Map && widget.value['values'] is List
//                     ? List<String>.from(widget.value['values'])
//                     : <String>[]),
//             options: options,
//             subOptions: subOptions,
//             imagePaths: imagePaths,
//             onChanged: (newValues) {
//               if (widget.value is Map) {
//                 final updated = Map<String, dynamic>.from(widget.value);
//                 updated['values'] = newValues;
//                 widget.onChanged(updated);
//               } else {
//                 widget.onChanged(newValues);
//               }
//             },
//             onImagesChanged: (newImagePaths) {
//               final updated = Map<String, dynamic>.from(
//                   widget.value is Map ? widget.value : {});
//               updated['image_paths'] = newImagePaths;
//               widget.onChanged(updated);
//             },
//             isRequired: false,
//           );
//         }

//         // 2) Hỗ trợ case “đặc biệt” 65/190: Map có key indicatorId (string) -> List
//         final selectedFromIdMap = widget.value is Map &&
//                 (widget.value as Map)[widget.indicator.id.toString()] is List
//             ? List<String>.from(
//                 ((widget.value as Map)[widget.indicator.id.toString()] as List)
//                     .map((e) => e.toString().trim()))
//             : null;

//         return CustomCheckboxGroup(
//           label: widget.indicator.name,
//           selectedValues: selectedFromIdMap ??
//               (widget.value is List
//                   ? List<String>.from(
//                       widget.value.map((e) => e.toString().trim()))
//                   : (widget.value is Map &&
//                           (widget.value as Map)['values'] is List
//                       ? List<String>.from((widget.value as Map)['values']
//                           .map((e) => e.toString().trim()))
//                       : <String>[])),
//           options: widget.indicator.valueOptions is List
//               ? List<String>.from(
//                   widget.indicator.valueOptions.map((e) => e.toString().trim()))
//               : [],
//           onChanged: (newValues) {
//             if (widget.value is Map) {
//               final updated = Map<String, dynamic>.from(widget.value);
//               // vẫn ghi vào 'values' để backend nhận; dữ liệu cũ theo id vẫn không mất
//               updated['values'] = newValues;
//               widget.onChanged(updated);
//             } else {
//               widget.onChanged(newValues);
//             }
//           },
//           isRequired: false,
//           enabled: true,
//         );

//       case FieldType.fullDate:
//         final dateValue = widget.value is String && widget.value.isNotEmpty
//             ? DateTime.tryParse(widget.value)
//             : null;

//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: dateValue ?? DateTime.now(),
//               firstDate: DateTime(1970),
//               lastDate: DateTime(2100),
//             );
//             if (picked != null) {
//               widget.onChanged(picked.toIso8601String());
//             }
//           },
//           child: IgnorePointer(
//             child: InputTextField(
//               label: widget.indicator.name,
//               enabled: false,
//               prefixIcon: const Icon(Icons.calendar_today),
//               textController: TextEditingController(
//                 text: dateValue != null
//                     ? "${dateValue.day.toString().padLeft(2, '0')}/"
//                         "${dateValue.month.toString().padLeft(2, '0')}/"
//                         "${dateValue.year}"
//                     : '',
//               ),
//             ),
//           ),
//         );

//       case FieldType.fullYearRange:
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: DateTime.tryParse(widget.value?.toString() ?? '') ??
//                   DateTime.now(),
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );
//             if (picked != null) {
//               widget.onChanged(DateFormat('yyyy-MM-dd').format(picked));
//             }
//           },
//           child: InputDecorator(
//             decoration: InputDecoration(
//               labelText: widget.indicator.name,
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
//               widget.value != null &&
//                       DateTime.tryParse(widget.value.toString()) != null
//                   ? DateFormat('yyyy-MM-dd')
//                       .format(DateTime.parse(widget.value.toString()))
//                   : 'Chọn ngày',
//             ),
//           ),
//         );

//       case FieldType.custom:
//         return CustomFieldEditor(
//           groups: widget.indicator.valueOptions != null
//               ? CustomField.fromJson(widget.indicator.valueOptions).groups
//               : [],
//           value: widget.value is Map ? widget.value : {},
//           onChanged: widget.onChanged,
//         );

//       default:
//         return Text('Kiểu dữ liệu không hỗ trợ: ${widget.indicator.valueType}');
//     }
//   }

//   String? _rangeHint() {
//     final min = widget.indicator.minValue;
//     final max = widget.indicator.maxValue;
//     if (min != null || max != null) {
//       return 'Giới hạn: ${min?.toString() ?? "−∞"} ~ ${max?.toString() ?? "+∞"}';
//     }
//     return null;
//   }

//   bool _isValueNotEmpty(dynamic val) {
//     if (val == null) return false;
//     if (val is String) return val.trim().isNotEmpty;
//     if (val is num) return true;
//     if (val is List) return val.isNotEmpty;
//     if (val is Map) return val.isNotEmpty;
//     return true;
//   }
// }

// /// ---------------------------------------------------------------------------
// /// CustomFieldEditor
// /// - Mở rộng/thu gọn map theo dot-key giống bệnh nhân
// /// - Select có ảnh: đọc/ghi '..._image'
// /// - MultiSelection có ảnh: Map<option, url>
// /// ---------------------------------------------------------------------------
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

//   Map<String, dynamic> _flattenFormValue(
//     Map<String, dynamic> nested, {
//     String prefix = '',
//   }) {
//     final Map<String, dynamic> flat = {};
//     nested.forEach((key, value) {
//       final newKey = prefix.isEmpty ? key : '$prefix.$key';
//       if (value is Map<String, dynamic>) {
//         flat.addAll(_flattenFormValue(value, prefix: newKey));
//       } else {
//         if (value != null && value.toString().trim().isNotEmpty) {
//           flat[newKey] = value;
//         }
//       }
//     });
//     return flat;
//   }

//   Map<String, dynamic> _expandFormValue(Map<String, dynamic> flat) {
//     // Nhận cả flat dot-key và nested-map
//     final Map<String, dynamic> nested = {};

//     void putPath(String path, dynamic value) {
//       final parts = path.split('.');
//       Map<String, dynamic> current = nested;
//       for (int i = 0; i < parts.length; i++) {
//         final part = parts[i];
//         if (i == parts.length - 1) {
//           current[part] = value;
//         } else {
//           current = current.putIfAbsent(part, () => <String, dynamic>{})
//               as Map<String, dynamic>;
//         }
//       }
//     }

//     flat.forEach((key, value) {
//       if (key.contains('.')) {
//         putPath(key, value);
//       } else {
//         final existing = nested[key];
//         if (existing is Map && value is Map) {
//           nested[key] = {...existing, ...value};
//         } else {
//           nested[key] = value;
//         }
//       }
//     });

//     return nested;
//   }

//   @override
//   void didUpdateWidget(covariant CustomFieldEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     final expandedValue = _expandFormValue(widget.value);

//     for (final group in widget.groups ?? []) {
//       for (var i = 0; i < group.fields.length; i++) {
//         final field = group.fields[i];
//         final fieldKey = field.label ?? group.label ?? 'field_$i';
//         final fieldValue = _getValueByKey(
//               expandedValue,
//               _fullKey(
//                   group.label?.trim() ?? '', field.label?.trim() ?? fieldKey),
//             ) ??
//             (field.type == FieldType.custom ? {} : null);

//         if (field.type == FieldType.text || field.type == FieldType.number) {
//           _controllers[fieldKey] ??= TextEditingController();
//           final newText = fieldValue?.toString() ?? '';
//           if (_controllers[fieldKey]!.text != newText) {
//             _controllers[fieldKey]!.text = newText;
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

//     final expandedValue = _expandFormValue(widget.value);

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: widget.groups!.asMap().entries.map((entry) {
//           final group = entry.value;
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
//                     final fieldKey =
//                         field.label ?? group.label ?? 'field_${fieldEntry.key}';
//                     final fullKey = _fullKey(group.label?.trim() ?? '',
//                         field.label?.trim() ?? fieldKey);

//                     final resolvedValue =
//                         _getValueByKey(expandedValue, fullKey);

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: _buildFieldEditor(
//                         context,
//                         field,
//                         resolvedValue,
//                         group.label?.trim() ?? '',
//                         field.label?.trim() ?? fieldKey,
//                         fullKey,
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
//     dynamic resolvedValue,
//     String groupLabel,
//     String fieldLabel,
//     String fullKey,
//   ) {
//     // Điều kiện hiển thị phụ thuộc (nếu có)
//     if (field.dependsOn != null && field.dependsOnValues != null) {
//       final depKey = field.dependsOn!;
//       final expanded = _expandFormValue(widget.value);
//       final depFullKey = groupLabel.isNotEmpty ? '$groupLabel.$depKey' : depKey;
//       dynamic parentValue =
//           _getValueByKey(expanded, depFullKey) ?? widget.value[depKey];

//       if (parentValue is Map<String, dynamic> && parentValue.length == 1) {
//         parentValue = parentValue.values.first;
//       }
//       if (parentValue == null ||
//           !field.dependsOnValues!.contains(parentValue.toString())) {
//         return const SizedBox.shrink();
//       }
//     }

//     switch (field.type) {
//       case FieldType.text:
//       case FieldType.number:
//         _controllers[fullKey] ??=
//             TextEditingController(text: resolvedValue?.toString() ?? '');
//         return InputTextField(
//           label: field.label ?? '',
//           keyboardType: field.type == FieldType.number
//               ? const TextInputType.numberWithOptions(decimal: true)
//               : TextInputType.text,
//           textController: _controllers[fullKey],
//           onChanged: (newValue) {
//             final updatedValue = Map<String, dynamic>.from(widget.value);
//             if (newValue.isNotEmpty) {
//               updatedValue[fullKey] = field.type == FieldType.number
//                   ? num.tryParse(newValue) ?? newValue
//                   : newValue;
//             } else {
//               updatedValue.remove(fullKey);
//             }
//             widget.onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
//           },
//         );

//       case FieldType.select:
//         // Đọc thêm ảnh theo chuẩn bệnh nhân: '<fullKey>_image'
//         final expanded = _expandFormValue(widget.value);
//         final imageUrl =
//             _getValueByKey(expanded, '${fullKey}_image')?.toString();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomRadioGroup(
//               label: field.label ?? '',
//               value: resolvedValue is String ? resolvedValue : null,
//               options: field.options ?? [],
//               onChanged: (newValue) {
//                 final updated = Map<String, dynamic>.from(widget.value);
//                 if (newValue != null && newValue.toString().isNotEmpty) {
//                   updated[fullKey] = newValue;
//                 } else {
//                   updated.remove(fullKey);
//                   updated.remove('${fullKey}_image');
//                 }
//                 widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//               },
//               isRequired: false,
//               enabled: true,
//             ),
//             // Nếu select yêu cầu ảnh (requiredFields có image) -> hiển thị uploader
//             if ((field.requiredFields ?? [])
//                     .any((rf) => rf.type == FieldType.image) &&
//                 resolvedValue is String &&
//                 resolvedValue.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: ImageUploadField(
//                   label: "Ảnh cho $resolvedValue",
//                   templateId: 16,
//                   initialImageUrl: imageUrl,
//                   onChanged: (url) {
//                     final updated = Map<String, dynamic>.from(widget.value);
//                     if (url != null && url.isNotEmpty) {
//                       updated['${fullKey}_image'] = url;
//                     } else {
//                       updated.remove('${fullKey}_image');
//                     }
//                     widget.onChanged(
//                         _flattenFormValue(_expandFormValue(updated)));
//                   },
//                 ),
//               ),
//           ],
//         );

//       case FieldType.multiSelection:
//         final needsImage = (field.requiredFields ?? [])
//             .any((rf) => rf.type == FieldType.image);

//         if (needsImage) {
//           // Kiểu bệnh nhân: Map<option, url|null>
//           Map<String, String?> selectedOptionsWithImages = {};
//           List<String> selectedValues = [];

//           if (resolvedValue is Map<String, dynamic>) {
//             selectedOptionsWithImages = resolvedValue.map(
//               (k, v) => MapEntry(k, v?.toString()),
//             );
//             selectedValues = selectedOptionsWithImages.keys.toList();
//           }

//           return StatefulBuilder(
//             builder: (context, setState) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomCheckboxGroup(
//                     label: field.label ?? '',
//                     selectedValues: selectedValues,
//                     options: field.options ?? [],
//                     onChanged: (newValues) {
//                       final updated = Map<String, dynamic>.from(widget.value);
//                       final data = <String, String?>{};
//                       for (final opt in newValues) {
//                         data[opt] = selectedOptionsWithImages[opt];
//                       }
//                       if (data.isNotEmpty) {
//                         updated[fullKey] = data;
//                       } else {
//                         updated.remove(fullKey);
//                       }
//                       setState(() {
//                         selectedOptionsWithImages = data;
//                         selectedValues = newValues;
//                       });
//                       widget.onChanged(
//                           _flattenFormValue(_expandFormValue(updated)));
//                     },
//                     isRequired: false,
//                     enabled: true,
//                   ),
//                   ...selectedValues.map((option) {
//                     final requiredField =
//                         (field.requiredFields ?? []).firstWhere(
//                       (rf) => rf.type == FieldType.image,
//                     );
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: ImageUploadField(
//                         label: requiredField.description ?? "Ảnh cho $option",
//                         templateId: 16,
//                         initialImageUrl: selectedOptionsWithImages[option],
//                         onChanged: (imageUrl) {
//                           final updated =
//                               Map<String, dynamic>.from(widget.value);
//                           final current =
//                               _getValueByKey(_expandFormValue(updated), fullKey)
//                                       as Map<String, dynamic>? ??
//                                   {};
//                           final next = Map<String, String?>.from(current
//                               .map((k, v) => MapEntry(k, v?.toString())));
//                           if (imageUrl != null && imageUrl.isNotEmpty) {
//                             next[option] = imageUrl;
//                           } else {
//                             next[option] = null;
//                           }
//                           updated[fullKey] = next;
//                           widget.onChanged(
//                               _flattenFormValue(_expandFormValue(updated)));
//                         },
//                       ),
//                     );
//                   }),
//                 ],
//               );
//             },
//           );
//         } else {
//           // Standard multi-selection không ảnh: List<String>
//           return CustomCheckboxGroup(
//             label: field.label ?? '',
//             selectedValues: resolvedValue is List<String>
//                 ? resolvedValue
//                 : (resolvedValue is List
//                     ? List<String>.from(resolvedValue.map((e) => e.toString()))
//                     : <String>[]),
//             options: field.options ?? [],
//             onChanged: (newValues) {
//               final updated = Map<String, dynamic>.from(widget.value);
//               if (newValues.isNotEmpty) {
//                 updated[fullKey] = newValues;
//               } else {
//                 updated.remove(fullKey);
//               }
//               widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//             },
//             isRequired: false,
//             enabled: true,
//           );
//         }

//       case FieldType.fullYearRange:
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: DateTime.tryParse(resolvedValue?.toString() ?? '') ??
//                   DateTime.now(),
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );
//             if (picked != null) {
//               final updated = Map<String, dynamic>.from(widget.value);
//               updated[fullKey] = DateFormat('yyyy-MM-dd').format(picked);
//               widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//             }
//           },
//           child: InputDecorator(
//             decoration: InputDecoration(
//               labelText: field.label ?? '',
//               hintText: 'Chọn ngày',
//               prefixIcon: const Icon(Icons.calendar_today),
//               border:
//                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             child: Text(
//               resolvedValue != null &&
//                       DateTime.tryParse(resolvedValue.toString()) != null
//                   ? DateFormat('yyyy-MM-dd')
//                       .format(DateTime.parse(resolvedValue.toString()))
//                   : 'Chọn ngày',
//             ),
//           ),
//         );

//       case FieldType.custom:
//         return CustomFieldEditor(
//           groups: field.groups,
//           value: resolvedValue is Map<String, dynamic> ? resolvedValue : {},
//           onChanged: (newValue) {
//             final updated = Map<String, dynamic>.from(widget.value);
//             if (newValue.isNotEmpty) {
//               updated[fullKey] = newValue;
//             } else {
//               updated.remove(fullKey);
//             }
//             widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//           },
//         );

//       default:
//         return Text('⚠️ Kiểu dữ liệu không hỗ trợ: ${field.type}');
//     }
//   }

//   String _fullKey(String groupLabel, String fieldLabel) {
//     return groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;
//   }

//   dynamic _getValueByKey(Map<String, dynamic> map, String fullKey) {
//     final parts = fullKey.split('.');
//     dynamic current = map;
//     for (final part in parts) {
//       if (current is Map<String, dynamic> && current.containsKey(part)) {
//         current = current[part];
//       } else {
//         return null;
//       }
//     }
//     return current;
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant/color.dart';
import '../../models/vital_indicator_model.dart';
import '../../utils/enum/field_type_enum.dart';
import '../../widget/text_field/input_text_field.dart';
import 'custom_checkbox_group.dart';
import 'custom_radio_group.dart';
import 'image_upload_field.dart';

class VitalFieldEditor extends StatefulWidget {
  final VitalIndicator indicator;
  final dynamic value;
  final String? unit;
  final ValueChanged<dynamic> onChanged;

  // NEW: overrides for nested custom fields
  final String? labelOverride;
  final String? valueTypeOverride;
  final dynamic valueOptionsOverride;
  final dynamic minValueOverride;
  final dynamic maxValueOverride;
  final String? unitOverride;

  const VitalFieldEditor({
    super.key,
    required this.indicator,
    required this.value,
    this.unit,
    required this.onChanged,
    this.labelOverride,
    this.valueTypeOverride,
    this.valueOptionsOverride,
    this.minValueOverride,
    this.maxValueOverride,
    this.unitOverride,
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

  RangeValues _parseRange(dynamic v, double min, double max) {
    double clamp(double x) => x < min ? min : (x > max ? max : x);

    if (v is RangeValues) {
      return RangeValues(clamp(v.start), clamp(v.end));
    }

    if (v is Map) {
      final s = double.tryParse(v['start']?.toString() ?? '');
      final e = double.tryParse(v['end']?.toString() ?? '');
      if (s != null && e != null) return RangeValues(clamp(s), clamp(e));
    }

    if (v is List && v.length >= 2) {
      final s = double.tryParse(v[0].toString());
      final e = double.tryParse(v[1].toString());
      if (s != null && e != null) return RangeValues(clamp(s), clamp(e));
    }

    // default
    return RangeValues(min, max);
  }

  int? _rangeDivisions(double min, double max) {
    final span = (max - min).abs();
    if (span <= 0) return null;
    // giữ giống bạn: 20 divisions nếu được
    return span >= 20 ? 20 : span.floor().clamp(1, 20);
  }

  @override
  Widget build(BuildContext context) {
    final valueType = widget.valueTypeOverride ?? widget.indicator.valueType;
    final label = widget.labelOverride ?? widget.indicator.name;

    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString()
        .trim();

    final minValue = widget.minValueOverride ?? widget.indicator.minValue;
    final maxValue = widget.maxValueOverride ?? widget.indicator.maxValue;

    final valueOptions =
        widget.valueOptionsOverride ?? widget.indicator.valueOptions;
    final displayLabel =
        (unit == null || unit.isEmpty) ? label : '$label ($unit)';
    switch (parseFieldType(widget.indicator.valueType)) {
      case FieldType.text:
      case FieldType.number:
        return InputTextField(
          label: displayLabel,
          keyboardType: widget.indicator.valueType == 'number'
              ? const TextInputType.numberWithOptions(decimal: true)
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
        // Indicator-level select (không phải custom). Không xử lý ảnh ở đây.
        return CustomRadioGroup(
          label: displayLabel,
          value: widget.value is String ? widget.value : null,
          options: widget.indicator.valueOptions is List
              ? List<String>.from(widget.indicator.valueOptions)
              : [],
          onChanged: widget.onChanged,
          isRequired: false,
          enabled: true,
        );

      case FieldType.multiSelection:
        // Hỗ trợ nhánh cũ 65/190 ở indicator-level (ngoài custom)
        final hasImages = widget.indicator.valueOptions is Map &&
            (widget.indicator.valueOptions as Map).containsKey('image_upload');

        if (hasImages) {
          final options = (widget.indicator.valueOptions['options'] as List?)
                  ?.cast<String>() ??
              [];
          final imagePaths = widget.value is Map
              ? (widget.value['image_paths'] as Map?)
                      ?.cast<String, List<String>>() ??
                  {}
              : <String, List<String>>{};

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCheckboxGroup(
                label: displayLabel,
                selectedValues: widget.value is List<String>
                    ? widget.value
                    : (widget.value is Map && widget.value['values'] is List
                        ? List<String>.from(widget.value['values'])
                        : <String>[]),
                options: options,
                onChanged: (newValues) {
                  if (widget.value is Map) {
                    final updated = Map<String, dynamic>.from(widget.value);
                    updated['values'] = newValues;
                    widget.onChanged(updated);
                  } else {
                    widget.onChanged(newValues);
                  }
                },
                isRequired: false,
                enabled: true,
              ),
              // images theo cấu trúc cũ — giữ để backward-compat nếu còn dùng
              if (imagePaths.isNotEmpty)
                ...imagePaths.entries.map((e) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${e.key}: ${e.value.length} ảnh',
                          style: const TextStyle(fontSize: 12)),
                    )),
            ],
          );
        }

        // 65/190: { "<IndicatorName>_radio": "...", "<indicatorId>": [ ... ] }
        final selectedFromIdMap = widget.value is Map &&
                (widget.value as Map)[widget.indicator.id.toString()] is List
            ? List<String>.from(
                ((widget.value as Map)[widget.indicator.id.toString()] as List)
                    .map((e) => e.toString().trim()))
            : null;

        return CustomCheckboxGroup(
          label: displayLabel,
          selectedValues: selectedFromIdMap ??
              (widget.value is List
                  ? List<String>.from(
                      widget.value.map((e) => e.toString().trim()))
                  : (widget.value is Map &&
                          (widget.value as Map)['values'] is List
                      ? List<String>.from((widget.value as Map)['values']
                          .map((e) => e.toString().trim()))
                      : <String>[])),
          options: widget.indicator.valueOptions is List
              ? List<String>.from(
                  widget.indicator.valueOptions.map((e) => e.toString().trim()))
              : [],
          onChanged: (newValues) {
            if (widget.value is Map) {
              final updated = Map<String, dynamic>.from(widget.value);
              updated['values'] = newValues;
              widget.onChanged(updated);
            } else {
              widget.onChanged(newValues);
            }
          },
          isRequired: false,
          enabled: true,
        );

      case FieldType.fullDate:
        final dateValue = widget.value is String && widget.value.isNotEmpty
            ? DateTime.tryParse(widget.value)
            : null;

        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              locale: Locale('vi'),
              context: context,
              initialDate: dateValue ?? DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              widget.onChanged(picked.toIso8601String());
            }
          },
          child: IgnorePointer(
            child: InputTextField(
              label: displayLabel,
              enabled: false,
              prefixIcon: const Icon(Icons.calendar_today),
              textController: TextEditingController(
                text: dateValue != null
                    ? "${dateValue.day.toString().padLeft(2, '0')}/"
                        "${dateValue.month.toString().padLeft(2, '0')}/"
                        "${dateValue.year}"
                    : '',
              ),
            ),
          ),
        );

      case FieldType.fullYearRange:
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              locale: Locale('vi'),
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
              labelText: displayLabel,
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
      case FieldType.range:
        final min =
            double.tryParse(widget.indicator.minValue?.toString() ?? '') ?? 0.0;
        final max =
            double.tryParse(widget.indicator.maxValue?.toString() ?? '') ??
                100.0;

        final range = _parseRange(widget.value, min, max);
        final divisions = _rangeDivisions(min, max);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayLabel),
            const SizedBox(height: 8),
            Text(
              '${range.start.toStringAsFixed(0)} - ${range.end.toStringAsFixed(0)}'
              '${widget.unit != null && widget.unit!.trim().isNotEmpty ? " ${widget.unit}" : ""}',
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            RangeSlider(
              values: range,
              min: min,
              max: max,
              divisions: divisions,
              activeColor: AppColors.primaryColor,
              onChanged: (v) {
                // Lưu dạng Map để dễ serialize
                widget.onChanged({"start": v.start, "end": v.end});
              },
            ),
          ],
        );

      case FieldType.custom:
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
