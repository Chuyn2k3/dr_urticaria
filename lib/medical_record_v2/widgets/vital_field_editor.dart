// import 'package:dr_urticaria/medical_record_v2/widgets/custom_field_editor.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../constant/color.dart';
// import '../../models/vital_indicator_model.dart';
// import '../../utils/enum/field_type_enum.dart';
// import '../../widget/text_field/input_text_field.dart';
// import 'custom_checkbox_group.dart';
// import 'custom_radio_group.dart';
// import 'custom_multiple_choice_with_images.dart';
// import 'image_upload_field.dart';
//
// /// ---------------------------------------------------------------------------
// /// VitalFieldEditor
// /// - Đọc/ghi giá trị thep QUY ƯỚC app bệnh nhân:
// ///   * Key phẳng: "Group.Field"
// ///   * Ảnh đi kèm select: "Group.Field_image"
// ///   * Multi selection có ảnh: { "opt1": "<url|null>", "opt2": "<url|null>" }
// ///   * Case đặc biệt 65/190 trên indicator-level: {
// ///       "<IndicatorName>_radio": "...",
// ///       "<IndicatorId>": [ ... ]
// ///     }
// /// ---------------------------------------------------------------------------
// // class VitalFieldEditor extends StatefulWidget {
// //   final VitalIndicatorModel indicator;
// //   final dynamic value;
// //   final String? unit;
// //   final ValueChanged<dynamic> onChanged;
//
// //   const VitalFieldEditor({
// //     super.key,
// //     required this.indicator,
// //     required this.value,
// //     this.unit,
// //     required this.onChanged,
// //   });
//
// //   @override
// //   State<VitalFieldEditor> createState() => _VitalFieldEditorState();
// // }
//
// // class _VitalFieldEditorState extends State<VitalFieldEditor> {
// //   late TextEditingController _controller;
//
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = TextEditingController(text: widget.value?.toString() ?? '');
// //   }
//
// //   @override
// //   void didUpdateWidget(covariant VitalFieldEditor oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.value?.toString() != oldWidget.value?.toString()) {
// //       _controller.text = widget.value?.toString() ?? '';
// //     }
// //   }
//
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     switch (parseFieldType(widget.indicator.valueType)) {
// //       case FieldType.text:
// //       case FieldType.number:
// //         return InputTextField(
// //           label: widget.indicator.name,
// //           keyboardType: widget.indicator.valueType == 'number'
// //               ? const TextInputType.numberWithOptions(decimal: true)
// //               : TextInputType.text,
// //           textController: _controller,
// //           hintText: _rangeHint(),
// //           onChanged: (newValue) {
// //             if (widget.indicator.valueType == 'number') {
// //               final parsedValue = num.tryParse(newValue);
// //               widget.onChanged(
// //                   _isValueNotEmpty(parsedValue) ? parsedValue : newValue);
// //             } else {
// //               widget.onChanged(_isValueNotEmpty(newValue) ? newValue : '');
// //             }
// //           },
// //         );
//
// //       case FieldType.select:
// //         // Đọc select theo kiểu bệnh nhân. Nếu custom có ảnh, ImageUpload sẽ xuất hiện ở CustomFieldEditor.
// //         return CustomRadioGroup(
// //           label: widget.indicator.name,
// //           value: widget.value is String ? widget.value : null,
// //           options: widget.indicator.valueOptions is List
// //               ? List<String>.from(widget.indicator.valueOptions)
// //               : [],
// //           onChanged: widget.onChanged,
// //           isRequired: false,
// //           enabled: true,
// //         );
//
// //       case FieldType.multiSelection:
// //         // 1) Hỗ trợ kiểu có ảnh (indicator-level): valueOptions là Map có 'image_upload'
// //         final hasImages = widget.indicator.valueOptions is Map &&
// //             (widget.indicator.valueOptions as Map).containsKey('image_upload');
//
// //         if (hasImages) {
// //           final options = (widget.indicator.valueOptions['options'] as List?)
// //                   ?.cast<String>() ??
// //               [];
// //           final subOptions = widget.indicator.valueOptions['sub_options']
// //               as Map<String, List<String>>?;
// //           final imagePaths = widget.value is Map
// //               ? (widget.value['image_paths'] as Map?)
// //                       ?.cast<String, List<String>>() ??
// //                   {}
// //               : <String, List<String>>{};
// //           print("image path $imagePaths");
// //           return CustomMultipleChoiceWithImages(
// //             label: widget.indicator.name,
// //             selectedValues: widget.value is List<String>
// //                 ? widget.value
// //                 : (widget.value is Map && widget.value['values'] is List
// //                     ? List<String>.from(widget.value['values'])
// //                     : <String>[]),
// //             options: options,
// //             subOptions: subOptions,
// //             imagePaths: imagePaths,
// //             onChanged: (newValues) {
// //               if (widget.value is Map) {
// //                 final updated = Map<String, dynamic>.from(widget.value);
// //                 updated['values'] = newValues;
// //                 widget.onChanged(updated);
// //               } else {
// //                 widget.onChanged(newValues);
// //               }
// //             },
// //             onImagesChanged: (newImagePaths) {
// //               final updated = Map<String, dynamic>.from(
// //                   widget.value is Map ? widget.value : {});
// //               updated['image_paths'] = newImagePaths;
// //               widget.onChanged(updated);
// //             },
// //             isRequired: false,
// //           );
// //         }
//
// //         // 2) Hỗ trợ case “đặc biệt” 65/190: Map có key indicatorId (string) -> List
// //         final selectedFromIdMap = widget.value is Map &&
// //                 (widget.value as Map)[widget.indicator.id.toString()] is List
// //             ? List<String>.from(
// //                 ((widget.value as Map)[widget.indicator.id.toString()] as List)
// //                     .map((e) => e.toString().trim()))
// //             : null;
//
// //         return CustomCheckboxGroup(
// //           label: widget.indicator.name,
// //           selectedValues: selectedFromIdMap ??
// //               (widget.value is List
// //                   ? List<String>.from(
// //                       widget.value.map((e) => e.toString().trim()))
// //                   : (widget.value is Map &&
// //                           (widget.value as Map)['values'] is List
// //                       ? List<String>.from((widget.value as Map)['values']
// //                           .map((e) => e.toString().trim()))
// //                       : <String>[])),
// //           options: widget.indicator.valueOptions is List
// //               ? List<String>.from(
// //                   widget.indicator.valueOptions.map((e) => e.toString().trim()))
// //               : [],
// //           onChanged: (newValues) {
// //             if (widget.value is Map) {
// //               final updated = Map<String, dynamic>.from(widget.value);
// //               // vẫn ghi vào 'values' để backend nhận; dữ liệu cũ theo id vẫn không mất
// //               updated['values'] = newValues;
// //               widget.onChanged(updated);
// //             } else {
// //               widget.onChanged(newValues);
// //             }
// //           },
// //           isRequired: false,
// //           enabled: true,
// //         );
//
// //       case FieldType.fullDate:
// //         final dateValue = widget.value is String && widget.value.isNotEmpty
// //             ? DateTime.tryParse(widget.value)
// //             : null;
//
// //         return InkWell(
// //           onTap: () async {
// //             final picked = await showDatePicker(
// //               context: context,
// //               initialDate: dateValue ?? DateTime.now(),
// //               firstDate: DateTime(1970),
// //               lastDate: DateTime(2100),
// //             );
// //             if (picked != null) {
// //               widget.onChanged(picked.toIso8601String());
// //             }
// //           },
// //           child: IgnorePointer(
// //             child: InputTextField(
// //               label: widget.indicator.name,
// //               enabled: false,
// //               prefixIcon: const Icon(Icons.calendar_today),
// //               textController: TextEditingController(
// //                 text: dateValue != null
// //                     ? "${dateValue.day.toString().padLeft(2, '0')}/"
// //                         "${dateValue.month.toString().padLeft(2, '0')}/"
// //                         "${dateValue.year}"
// //                     : '',
// //               ),
// //             ),
// //           ),
// //         );
//
// //       case FieldType.fullYearRange:
// //         return InkWell(
// //           onTap: () async {
// //             final picked = await showDatePicker(
// //               context: context,
// //               initialDate: DateTime.tryParse(widget.value?.toString() ?? '') ??
// //                   DateTime.now(),
// //               firstDate: DateTime(1900),
// //               lastDate: DateTime(2100),
// //             );
// //             if (picked != null) {
// //               widget.onChanged(DateFormat('yyyy-MM-dd').format(picked));
// //             }
// //           },
// //           child: InputDecorator(
// //             decoration: InputDecoration(
// //               labelText: widget.indicator.name,
// //               hintText: 'Chọn ngày',
// //               prefixIcon: const Icon(Icons.calendar_today),
// //               border:
// //                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// //               enabledBorder: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //                 borderSide: BorderSide(
// //                   color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
// //                 ),
// //               ),
// //             ),
// //             child: Text(
// //               widget.value != null &&
// //                       DateTime.tryParse(widget.value.toString()) != null
// //                   ? DateFormat('yyyy-MM-dd')
// //                       .format(DateTime.parse(widget.value.toString()))
// //                   : 'Chọn ngày',
// //             ),
// //           ),
// //         );
//
// //       case FieldType.custom:
// //         return CustomFieldEditor(
// //           groups: widget.indicator.valueOptions != null
// //               ? CustomField.fromJson(widget.indicator.valueOptions).groups
// //               : [],
// //           value: widget.value is Map ? widget.value : {},
// //           onChanged: widget.onChanged,
// //         );
//
// //       default:
// //         return Text('Kiểu dữ liệu không hỗ trợ: ${widget.indicator.valueType}');
// //     }
// //   }
//
// //   String? _rangeHint() {
// //     final min = widget.indicator.minValue;
// //     final max = widget.indicator.maxValue;
// //     if (min != null || max != null) {
// //       return 'Giới hạn: ${min?.toString() ?? "−∞"} ~ ${max?.toString() ?? "+∞"}';
// //     }
// //     return null;
// //   }
//
// //   bool _isValueNotEmpty(dynamic val) {
// //     if (val == null) return false;
// //     if (val is String) return val.trim().isNotEmpty;
// //     if (val is num) return true;
// //     if (val is List) return val.isNotEmpty;
// //     if (val is Map) return val.isNotEmpty;
// //     return true;
// //   }
// // }
//
// // /// ---------------------------------------------------------------------------
// // /// CustomFieldEditor
// // /// - Mở rộng/thu gọn map theo dot-key giống bệnh nhân
// // /// - Select có ảnh: đọc/ghi '..._image'
// // /// - MultiSelection có ảnh: Map<option, url>
// // /// ---------------------------------------------------------------------------
// // class CustomFieldEditor extends StatefulWidget {
// //   final List<CustomFieldGroup>? groups;
// //   final Map<String, dynamic> value;
// //   final ValueChanged<Map<String, dynamic>> onChanged;
//
// //   const CustomFieldEditor({
// //     super.key,
// //     this.groups,
// //     required this.value,
// //     required this.onChanged,
// //   });
//
// //   @override
// //   State<CustomFieldEditor> createState() => _CustomFieldEditorState();
// // }
//
// // class _CustomFieldEditorState extends State<CustomFieldEditor> {
// //   final Map<String, TextEditingController> _controllers = {};
//
// //   Map<String, dynamic> _flattenFormValue(
// //     Map<String, dynamic> nested, {
// //     String prefix = '',
// //   }) {
// //     final Map<String, dynamic> flat = {};
// //     nested.forEach((key, value) {
// //       final newKey = prefix.isEmpty ? key : '$prefix.$key';
// //       if (value is Map<String, dynamic>) {
// //         flat.addAll(_flattenFormValue(value, prefix: newKey));
// //       } else {
// //         if (value != null && value.toString().trim().isNotEmpty) {
// //           flat[newKey] = value;
// //         }
// //       }
// //     });
// //     return flat;
// //   }
//
// //   Map<String, dynamic> _expandFormValue(Map<String, dynamic> flat) {
// //     // Nhận cả flat dot-key và nested-map
// //     final Map<String, dynamic> nested = {};
//
// //     void putPath(String path, dynamic value) {
// //       final parts = path.split('.');
// //       Map<String, dynamic> current = nested;
// //       for (int i = 0; i < parts.length; i++) {
// //         final part = parts[i];
// //         if (i == parts.length - 1) {
// //           current[part] = value;
// //         } else {
// //           current = current.putIfAbsent(part, () => <String, dynamic>{})
// //               as Map<String, dynamic>;
// //         }
// //       }
// //     }
//
// //     flat.forEach((key, value) {
// //       if (key.contains('.')) {
// //         putPath(key, value);
// //       } else {
// //         final existing = nested[key];
// //         if (existing is Map && value is Map) {
// //           nested[key] = {...existing, ...value};
// //         } else {
// //           nested[key] = value;
// //         }
// //       }
// //     });
//
// //     return nested;
// //   }
//
// //   @override
// //   void didUpdateWidget(covariant CustomFieldEditor oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     final expandedValue = _expandFormValue(widget.value);
//
// //     for (final group in widget.groups ?? []) {
// //       for (var i = 0; i < group.fields.length; i++) {
// //         final field = group.fields[i];
// //         final fieldKey = field.label ?? group.label ?? 'field_$i';
// //         final fieldValue = _getValueByKey(
// //               expandedValue,
// //               _fullKey(
// //                   group.label?.trim() ?? '', field.label?.trim() ?? fieldKey),
// //             ) ??
// //             (field.type == FieldType.custom ? {} : null);
//
// //         if (field.type == FieldType.text || field.type == FieldType.number) {
// //           _controllers[fieldKey] ??= TextEditingController();
// //           final newText = fieldValue?.toString() ?? '';
// //           if (_controllers[fieldKey]!.text != newText) {
// //             _controllers[fieldKey]!.text = newText;
// //           }
// //         }
// //       }
// //     }
// //   }
//
// //   @override
// //   void dispose() {
// //     _controllers.values.forEach((controller) => controller.dispose());
// //     super.dispose();
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     if (widget.groups == null || widget.groups!.isEmpty) {
// //       return const Text('Không có trường dữ liệu');
// //     }
//
// //     final expandedValue = _expandFormValue(widget.value);
//
// //     return SingleChildScrollView(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: widget.groups!.asMap().entries.map((entry) {
// //           final group = entry.value;
// //           return Card(
// //             elevation: 1,
// //             margin: const EdgeInsets.symmetric(vertical: 4),
// //             child: Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   if (group.label != null)
// //                     Padding(
// //                       padding: const EdgeInsets.only(bottom: 8),
// //                       child: Text(
// //                         group.label!,
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                           color: AppColors.bgBlueDark,
// //                         ),
// //                       ),
// //                     ),
// //                   ...group.fields.asMap().entries.map((fieldEntry) {
// //                     final field = fieldEntry.value;
// //                     final fieldKey =
// //                         field.label ?? group.label ?? 'field_${fieldEntry.key}';
// //                     final fullKey = _fullKey(group.label?.trim() ?? '',
// //                         field.label?.trim() ?? fieldKey);
//
// //                     final resolvedValue =
// //                         _getValueByKey(expandedValue, fullKey);
//
// //                     return Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 4.0),
// //                       child: _buildFieldEditor(
// //                         context,
// //                         field,
// //                         resolvedValue,
// //                         group.label?.trim() ?? '',
// //                         field.label?.trim() ?? fieldKey,
// //                         fullKey,
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ],
// //               ),
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }
//
// //   Widget _buildFieldEditor(
// //     BuildContext context,
// //     CustomField field,
// //     dynamic resolvedValue,
// //     String groupLabel,
// //     String fieldLabel,
// //     String fullKey,
// //   ) {
// //     // Điều kiện hiển thị phụ thuộc (nếu có)
// //     if (field.dependsOn != null && field.dependsOnValues != null) {
// //       final depKey = field.dependsOn!;
// //       final expanded = _expandFormValue(widget.value);
// //       final depFullKey = groupLabel.isNotEmpty ? '$groupLabel.$depKey' : depKey;
// //       dynamic parentValue =
// //           _getValueByKey(expanded, depFullKey) ?? widget.value[depKey];
//
// //       if (parentValue is Map<String, dynamic> && parentValue.length == 1) {
// //         parentValue = parentValue.values.first;
// //       }
// //       if (parentValue == null ||
// //           !field.dependsOnValues!.contains(parentValue.toString())) {
// //         return const SizedBox.shrink();
// //       }
// //     }
//
// //     switch (field.type) {
// //       case FieldType.text:
// //       case FieldType.number:
// //         _controllers[fullKey] ??=
// //             TextEditingController(text: resolvedValue?.toString() ?? '');
// //         return InputTextField(
// //           label: field.label ?? '',
// //           keyboardType: field.type == FieldType.number
// //               ? const TextInputType.numberWithOptions(decimal: true)
// //               : TextInputType.text,
// //           textController: _controllers[fullKey],
// //           onChanged: (newValue) {
// //             final updatedValue = Map<String, dynamic>.from(widget.value);
// //             if (newValue.isNotEmpty) {
// //               updatedValue[fullKey] = field.type == FieldType.number
// //                   ? num.tryParse(newValue) ?? newValue
// //                   : newValue;
// //             } else {
// //               updatedValue.remove(fullKey);
// //             }
// //             widget.onChanged(_flattenFormValue(_expandFormValue(updatedValue)));
// //           },
// //         );
//
// //       case FieldType.select:
// //         // Đọc thêm ảnh theo chuẩn bệnh nhân: '<fullKey>_image'
// //         final expanded = _expandFormValue(widget.value);
// //         final imageUrl =
// //             _getValueByKey(expanded, '${fullKey}_image')?.toString();
//
// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             CustomRadioGroup(
// //               label: field.label ?? '',
// //               value: resolvedValue is String ? resolvedValue : null,
// //               options: field.options ?? [],
// //               onChanged: (newValue) {
// //                 final updated = Map<String, dynamic>.from(widget.value);
// //                 if (newValue != null && newValue.toString().isNotEmpty) {
// //                   updated[fullKey] = newValue;
// //                 } else {
// //                   updated.remove(fullKey);
// //                   updated.remove('${fullKey}_image');
// //                 }
// //                 widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
// //               },
// //               isRequired: false,
// //               enabled: true,
// //             ),
// //             // Nếu select yêu cầu ảnh (requiredFields có image) -> hiển thị uploader
// //             if ((field.requiredFields ?? [])
// //                     .any((rf) => rf.type == FieldType.image) &&
// //                 resolvedValue is String &&
// //                 resolvedValue.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: ImageUploadField(
// //                   label: "Ảnh cho $resolvedValue",
// //                   templateId: 16,
// //                   initialImageUrl: imageUrl,
// //                   onChanged: (url) {
// //                     final updated = Map<String, dynamic>.from(widget.value);
// //                     if (url != null && url.isNotEmpty) {
// //                       updated['${fullKey}_image'] = url;
// //                     } else {
// //                       updated.remove('${fullKey}_image');
// //                     }
// //                     widget.onChanged(
// //                         _flattenFormValue(_expandFormValue(updated)));
// //                   },
// //                 ),
// //               ),
// //           ],
// //         );
//
// //       case FieldType.multiSelection:
// //         final needsImage = (field.requiredFields ?? [])
// //             .any((rf) => rf.type == FieldType.image);
//
// //         if (needsImage) {
// //           // Kiểu bệnh nhân: Map<option, url|null>
// //           Map<String, String?> selectedOptionsWithImages = {};
// //           List<String> selectedValues = [];
//
// //           if (resolvedValue is Map<String, dynamic>) {
// //             selectedOptionsWithImages = resolvedValue.map(
// //               (k, v) => MapEntry(k, v?.toString()),
// //             );
// //             selectedValues = selectedOptionsWithImages.keys.toList();
// //           }
//
// //           return StatefulBuilder(
// //             builder: (context, setState) {
// //               return Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   CustomCheckboxGroup(
// //                     label: field.label ?? '',
// //                     selectedValues: selectedValues,
// //                     options: field.options ?? [],
// //                     onChanged: (newValues) {
// //                       final updated = Map<String, dynamic>.from(widget.value);
// //                       final data = <String, String?>{};
// //                       for (final opt in newValues) {
// //                         data[opt] = selectedOptionsWithImages[opt];
// //                       }
// //                       if (data.isNotEmpty) {
// //                         updated[fullKey] = data;
// //                       } else {
// //                         updated.remove(fullKey);
// //                       }
// //                       setState(() {
// //                         selectedOptionsWithImages = data;
// //                         selectedValues = newValues;
// //                       });
// //                       widget.onChanged(
// //                           _flattenFormValue(_expandFormValue(updated)));
// //                     },
// //                     isRequired: false,
// //                     enabled: true,
// //                   ),
// //                   ...selectedValues.map((option) {
// //                     final requiredField =
// //                         (field.requiredFields ?? []).firstWhere(
// //                       (rf) => rf.type == FieldType.image,
// //                     );
// //                     return Padding(
// //                       padding: const EdgeInsets.only(top: 8.0),
// //                       child: ImageUploadField(
// //                         label: requiredField.description ?? "Ảnh cho $option",
// //                         templateId: 16,
// //                         initialImageUrl: selectedOptionsWithImages[option],
// //                         onChanged: (imageUrl) {
// //                           final updated =
// //                               Map<String, dynamic>.from(widget.value);
// //                           final current =
// //                               _getValueByKey(_expandFormValue(updated), fullKey)
// //                                       as Map<String, dynamic>? ??
// //                                   {};
// //                           final next = Map<String, String?>.from(current
// //                               .map((k, v) => MapEntry(k, v?.toString())));
// //                           if (imageUrl != null && imageUrl.isNotEmpty) {
// //                             next[option] = imageUrl;
// //                           } else {
// //                             next[option] = null;
// //                           }
// //                           updated[fullKey] = next;
// //                           widget.onChanged(
// //                               _flattenFormValue(_expandFormValue(updated)));
// //                         },
// //                       ),
// //                     );
// //                   }),
// //                 ],
// //               );
// //             },
// //           );
// //         } else {
// //           // Standard multi-selection không ảnh: List<String>
// //           return CustomCheckboxGroup(
// //             label: field.label ?? '',
// //             selectedValues: resolvedValue is List<String>
// //                 ? resolvedValue
// //                 : (resolvedValue is List
// //                     ? List<String>.from(resolvedValue.map((e) => e.toString()))
// //                     : <String>[]),
// //             options: field.options ?? [],
// //             onChanged: (newValues) {
// //               final updated = Map<String, dynamic>.from(widget.value);
// //               if (newValues.isNotEmpty) {
// //                 updated[fullKey] = newValues;
// //               } else {
// //                 updated.remove(fullKey);
// //               }
// //               widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
// //             },
// //             isRequired: false,
// //             enabled: true,
// //           );
// //         }
//
// //       case FieldType.fullYearRange:
// //         return InkWell(
// //           onTap: () async {
// //             final picked = await showDatePicker(
// //               context: context,
// //               initialDate: DateTime.tryParse(resolvedValue?.toString() ?? '') ??
// //                   DateTime.now(),
// //               firstDate: DateTime(1900),
// //               lastDate: DateTime(2100),
// //             );
// //             if (picked != null) {
// //               final updated = Map<String, dynamic>.from(widget.value);
// //               updated[fullKey] = DateFormat('yyyy-MM-dd').format(picked);
// //               widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
// //             }
// //           },
// //           child: InputDecorator(
// //             decoration: InputDecoration(
// //               labelText: field.label ?? '',
// //               hintText: 'Chọn ngày',
// //               prefixIcon: const Icon(Icons.calendar_today),
// //               border:
// //                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// //             ),
// //             child: Text(
// //               resolvedValue != null &&
// //                       DateTime.tryParse(resolvedValue.toString()) != null
// //                   ? DateFormat('yyyy-MM-dd')
// //                       .format(DateTime.parse(resolvedValue.toString()))
// //                   : 'Chọn ngày',
// //             ),
// //           ),
// //         );
//
// //       case FieldType.custom:
// //         return CustomFieldEditor(
// //           groups: field.groups,
// //           value: resolvedValue is Map<String, dynamic> ? resolvedValue : {},
// //           onChanged: (newValue) {
// //             final updated = Map<String, dynamic>.from(widget.value);
// //             if (newValue.isNotEmpty) {
// //               updated[fullKey] = newValue;
// //             } else {
// //               updated.remove(fullKey);
// //             }
// //             widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
// //           },
// //         );
//
// //       default:
// //         return Text('⚠️ Kiểu dữ liệu không hỗ trợ: ${field.type}');
// //     }
// //   }
//
// //   String _fullKey(String groupLabel, String fieldLabel) {
// //     return groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;
// //   }
//
// //   dynamic _getValueByKey(Map<String, dynamic> map, String fullKey) {
// //     final parts = fullKey.split('.');
// //     dynamic current = map;
// //     for (final part in parts) {
// //       if (current is Map<String, dynamic> && current.containsKey(part)) {
// //         current = current[part];
// //       } else {
// //         return null;
// //       }
// //     }
// //     return current;
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../constant/color.dart';
// import '../../models/vital_indicator_model.dart';
// import '../../utils/enum/field_type_enum.dart';
// import '../../widget/text_field/input_text_field.dart';
// import 'custom_checkbox_group.dart';
// import 'custom_radio_group.dart';
// import 'image_upload_field.dart';
//
// class VitalFieldEditor extends StatefulWidget {
//   final VitalIndicator indicator;
//   final dynamic value;
//   final String? unit;
//   final ValueChanged<dynamic> onChanged;
//
//   // NEW: overrides for nested custom fields
//   final String? labelOverride;
//   final String? valueTypeOverride;
//   final dynamic valueOptionsOverride;
//   final dynamic minValueOverride;
//   final dynamic maxValueOverride;
//   final String? unitOverride;
//
//   const VitalFieldEditor({
//     super.key,
//     required this.indicator,
//     required this.value,
//     this.unit,
//     required this.onChanged,
//     this.labelOverride,
//     this.valueTypeOverride,
//     this.valueOptionsOverride,
//     this.minValueOverride,
//     this.maxValueOverride,
//     this.unitOverride,
//   });
//
//   @override
//   State<VitalFieldEditor> createState() => _VitalFieldEditorState();
// }
//
// class _VitalFieldEditorState extends State<VitalFieldEditor> {
//   late TextEditingController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.value?.toString() ?? '');
//   }
//
//   @override
//   void didUpdateWidget(covariant VitalFieldEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.value?.toString() != oldWidget.value?.toString()) {
//       _controller.text = widget.value?.toString() ?? '';
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   RangeValues _parseRange(dynamic v, double min, double max) {
//     double clamp(double x) => x < min ? min : (x > max ? max : x);
//
//     if (v is RangeValues) {
//       return RangeValues(clamp(v.start), clamp(v.end));
//     }
//
//     if (v is Map) {
//       final s = double.tryParse(v['start']?.toString() ?? '');
//       final e = double.tryParse(v['end']?.toString() ?? '');
//       if (s != null && e != null) return RangeValues(clamp(s), clamp(e));
//     }
//
//     if (v is List && v.length >= 2) {
//       final s = double.tryParse(v[0].toString());
//       final e = double.tryParse(v[1].toString());
//       if (s != null && e != null) return RangeValues(clamp(s), clamp(e));
//     }
//
//     // default
//     return RangeValues(min, max);
//   }
//
//   int? _rangeDivisions(double min, double max) {
//     final span = (max - min).abs();
//     if (span <= 0) return null;
//     // giữ giống bạn: 20 divisions nếu được
//     return span >= 20 ? 20 : span.floor().clamp(1, 20);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final valueType = widget.valueTypeOverride ?? widget.indicator.valueType;
//     final label = widget.labelOverride ?? widget.indicator.name;
//
//     final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
//         ?.toString()
//         .trim();
//
//     final minValue = widget.minValueOverride ?? widget.indicator.minValue;
//     final maxValue = widget.maxValueOverride ?? widget.indicator.maxValue;
//
//     final valueOptions =
//         widget.valueOptionsOverride ?? widget.indicator.valueOptions;
//     final displayLabel =
//         (unit == null || unit.isEmpty) ? label : '$label ($unit)';
//     switch (parseFieldType(widget.indicator.valueType)) {
//       case FieldType.text:
//       case FieldType.number:
//         return InputTextField(
//           label: displayLabel,
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
//
//       case FieldType.select:
//         // Indicator-level select (không phải custom). Không xử lý ảnh ở đây.
//         return CustomRadioGroup(
//           label: displayLabel,
//           value: widget.value is String ? widget.value : null,
//           options: widget.indicator.valueOptions is List
//               ? List<String>.from(widget.indicator.valueOptions)
//               : [],
//           onChanged: widget.onChanged,
//           isRequired: false,
//           enabled: true,
//         );
//
//       case FieldType.multiSelection:
//         // Hỗ trợ nhánh cũ 65/190 ở indicator-level (ngoài custom)
//         final hasImages = widget.indicator.valueOptions is Map &&
//             (widget.indicator.valueOptions as Map).containsKey('image_upload');
//
//         if (hasImages) {
//           final options = (widget.indicator.valueOptions['options'] as List?)
//                   ?.cast<String>() ??
//               [];
//           final imagePaths = widget.value is Map
//               ? (widget.value['image_paths'] as Map?)
//                       ?.cast<String, List<String>>() ??
//                   {}
//               : <String, List<String>>{};
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomCheckboxGroup(
//                 label: displayLabel,
//                 selectedValues: widget.value is List<String>
//                     ? widget.value
//                     : (widget.value is Map && widget.value['values'] is List
//                         ? List<String>.from(widget.value['values'])
//                         : <String>[]),
//                 options: options,
//                 onChanged: (newValues) {
//                   if (widget.value is Map) {
//                     final updated = Map<String, dynamic>.from(widget.value);
//                     updated['values'] = newValues;
//                     widget.onChanged(updated);
//                   } else {
//                     widget.onChanged(newValues);
//                   }
//                 },
//                 isRequired: false,
//                 enabled: true,
//               ),
//               // images theo cấu trúc cũ — giữ để backward-compat nếu còn dùng
//               if (imagePaths.isNotEmpty)
//                 ...imagePaths.entries.map((e) => Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text('${e.key}: ${e.value.length} ảnh',
//                           style: const TextStyle(fontSize: 12)),
//                     )),
//             ],
//           );
//         }
//
//         // 65/190: { "<IndicatorName>_radio": "...", "<indicatorId>": [ ... ] }
//         final selectedFromIdMap = widget.value is Map &&
//                 (widget.value as Map)[widget.indicator.id.toString()] is List
//             ? List<String>.from(
//                 ((widget.value as Map)[widget.indicator.id.toString()] as List)
//                     .map((e) => e.toString().trim()))
//             : null;
//
//         return CustomCheckboxGroup(
//           label: displayLabel,
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
//               updated['values'] = newValues;
//               widget.onChanged(updated);
//             } else {
//               widget.onChanged(newValues);
//             }
//           },
//           isRequired: false,
//           enabled: true,
//         );
//
//       case FieldType.fullDate:
//         final dateValue = widget.value is String && widget.value.isNotEmpty
//             ? DateTime.tryParse(widget.value)
//             : null;
//
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               locale: Locale('vi'),
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
//               label: displayLabel,
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
//
//       case FieldType.fullYearRange:
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               locale: Locale('vi'),
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
//               labelText: displayLabel,
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
//       case FieldType.range:
//         final min =
//             double.tryParse(widget.indicator.minValue?.toString() ?? '') ?? 0.0;
//         final max =
//             double.tryParse(widget.indicator.maxValue?.toString() ?? '') ??
//                 100.0;
//
//         final range = _parseRange(widget.value, min, max);
//         final divisions = _rangeDivisions(min, max);
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(displayLabel),
//             const SizedBox(height: 8),
//             Text(
//               '${range.start.toStringAsFixed(0)} - ${range.end.toStringAsFixed(0)}'
//               '${widget.unit != null && widget.unit!.trim().isNotEmpty ? " ${widget.unit}" : ""}',
//               style:
//                   const TextStyle(fontSize: 12, color: AppColors.textSecondary),
//             ),
//             RangeSlider(
//               values: range,
//               min: min,
//               max: max,
//               divisions: divisions,
//               activeColor: AppColors.primaryColor,
//               onChanged: (v) {
//                 // Lưu dạng Map để dễ serialize
//                 widget.onChanged({"start": v.start, "end": v.end});
//               },
//             ),
//           ],
//         );
//
//       case FieldType.custom:
//         return CustomFieldEditor(
//           groups: widget.indicator.valueOptions != null
//               ? CustomField.fromJson(widget.indicator.valueOptions).groups
//               : [],
//           value: widget.value is Map ? widget.value : {},
//           onChanged: widget.onChanged,
//         );
//
//       default:
//         return Text('Kiểu dữ liệu không hỗ trợ: ${widget.indicator.valueType}');
//     }
//   }
//
//   String? _rangeHint() {
//     final min = widget.indicator.minValue;
//     final max = widget.indicator.maxValue;
//     if (min != null || max != null) {
//       return 'Giới hạn: ${min?.toString() ?? "−∞"} ~ ${max?.toString() ?? "+∞"}';
//     }
//     return null;
//   }
//
//   bool _isValueNotEmpty(dynamic val) {
//     if (val == null) return false;
//     if (val is String) return val.trim().isNotEmpty;
//     if (val is num) return true;
//     if (val is List) return val.isNotEmpty;
//     if (val is Map) return val.isNotEmpty;
//     return true;
//   }
// }
// vital_field_editor.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant/color.dart';
import '../../models/vital_indicator_model.dart';
import '../../utils/enum/field_type_enum.dart';
import '../../widget/text_field/input_text_field.dart';
import 'custom_checkbox_group.dart';
import 'custom_field_editor.dart';
import 'custom_radio_group.dart';
import 'indicator_label.dart';

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

  // ===================== Shared helpers =====================
  bool _isValueNotEmpty(dynamic val) {
    if (val == null) return false;
    if (val is String) return val.trim().isNotEmpty;
    if (val is num) return true;
    if (val is List) return val.isNotEmpty;
    if (val is Map) return val.isNotEmpty;
    return true;
  }

  bool _hasHtml(String s) {
    final x = s.toLowerCase();
    return x.contains('<img') || x.contains('<br') || x.contains('<p');
  }

  String _displayLabel(String label, String? unit) {
    if (widget.indicator.name.isNotEmpty && _hasHtml(widget.indicator.name)) {
      return "";
    }
    final u = unit?.toString().trim();
    if (u == null || u.isEmpty) return label;
    return '$label ($u)';
  }

  // ===================== RANGE (number) helper =====================
  RangeValues _parseRange(dynamic v, double min, double max) {
    double clamp(double x) => x < min ? min : (x > max ? max : x);

    if (v is RangeValues) return RangeValues(clamp(v.start), clamp(v.end));

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

    return RangeValues(min, max);
  }

  int? _rangeDivisions(double min, double max) {
    final span = (max - min).abs();
    if (span <= 0) return null;
    return span >= 20 ? 20 : span.floor().clamp(1, 20);
  }

  // ===================== SPECIAL INDICATORS =====================
  Widget? _buildSpecialIndicatorIfAny(BuildContext context) {
    final id = widget.indicator.id;

    switch (id) {
      case 190:
      case 65:
        return _buildSpecial190or65(context);

      case 175:
      case 64:
        return _buildSpecial175or64(context);

      case 196:
      case 66:
        return _buildSpecial196or66(context);

      case 182:
      case 69:
        return _buildSpecial182or69(context);

      case 185:
      case 71:
        return _buildSpecial185or71(context);

      case 180:
      case 67:
        return _buildSpecial180or67(context);

      default:
        return null;
    }
  }

  // 190/65: multi_selection kiểu radio + checkbox phụ thuộc
  Widget _buildSpecial190or65(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    final options = widget.indicator.valueOptions is List
        ? List<String>.from(
            widget.indicator.valueOptions.map((e) => e.toString()))
        : <String>[];

    // ✅ không cast cứng nữa
    final allValues = _asMap(widget.value);

    final radioKey = "${widget.indicator.name}_radio";
    final radioValue = allValues[radioKey]?.toString() ?? "Một cách ngẫu nhiên";

    final selected = (allValues[widget.indicator.id.toString()] is List)
        ? List<String>.from(
            (allValues[widget.indicator.id.toString()] as List)
                .map((e) => e.toString()),
          )
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRadioGroup(
          label: displayLabel,
          value: radioValue,
          options: const [
            "Một cách ngẫu nhiên",
            "Khi có các yếu tố kích thích"
          ],
          onChanged: (val) {
            final m = Map<String, dynamic>.from(allValues);
            final vv = val?.toString() ?? '';

            if (vv.trim().isNotEmpty) {
              m[radioKey] = vv;
            } else {
              m.remove(radioKey);
            }

            if (vv == "Một cách ngẫu nhiên") {
              m.remove(widget.indicator.id.toString());
            }

            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),
        if (radioValue == "Khi có các yếu tố kích thích")
          CustomCheckboxGroup(
            label: "Chọn các yếu tố kích thích",
            selectedValues: selected,
            options: options.length > 2 ? options.skip(2).toList() : options,
            onChanged: (newValues) {
              final m = Map<String, dynamic>.from(allValues);
              if (newValues.isNotEmpty) {
                m[widget.indicator.id.toString()] =
                    newValues.map((e) => e.toString()).toList();
              } else {
                m.remove(widget.indicator.id.toString());
              }
              widget.onChanged(m);
            },
            enabled: true,
          ),
      ],
    );
  }

  // 175/64: episode groups theo "Số đợt..." + cleanup group ẩn
  Widget _buildSpecial175or64(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    final valueOptions =
        widget.valueOptionsOverride ?? widget.indicator.valueOptions;

    final groupJson = (valueOptions is Map) ? valueOptions['group'] : null;

    List<CustomFieldGroup> groups = [];
    if (groupJson is List) {
      groups = groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
    } else if (groupJson is Map<String, dynamic>) {
      groups = [CustomFieldGroup.fromJson(groupJson)];
    }

    // ✅ không cast cứng
    final allValues = _asMap(widget.value);

    if (groups.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(displayLabel,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('⚠️ Không có cấu hình group cho indicator này'),
        ],
      );
    }

    String? findFieldLabelContains(CustomFieldGroup g, String needle) {
      for (final f in g.fields) {
        final l = f.label?.trim();
        if (l != null && l.contains(needle)) return l;
      }
      return null;
    }

    bool isYes(dynamic v, String key) {
      if (v is String) return v.trim() == 'Có';
      if (v is Map) return v[key]?.toString().trim() == 'Có';
      return false;
    }

    int parseCount(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toInt();
      final m = RegExp(r'(\d+)').firstMatch(v.toString());
      return m == null ? 0 : (int.tryParse(m.group(1)!) ?? 0);
    }

    final rootGroup = groups.first;

    // Tìm đúng label theo JSON
    final prevLabel =
        findFieldLabelContains(rootGroup, "Trước đây bạn đã từng bị đợt nào");
    final countLabel =
        findFieldLabelContains(rootGroup, "Số đợt bị tương tự như đợt này");

    final prevYes =
        (prevLabel != null) ? isYes(allValues[prevLabel], prevLabel) : false;

    final count =
        (prevYes && countLabel != null) ? parseCount(allValues[countLabel]) : 0;

    final filteredGroups = <CustomFieldGroup>[rootGroup];
    if (prevYes && count > 0) {
      filteredGroups.addAll(
        groups.skip(1).take(count.clamp(0, groups.length - 1)),
      );
    }

    void cleanupHiddenEpisodeGroups(Map<String, dynamic> map,
        {required int keepCount}) {
      // groups[0] = root, groups[1..] = episode groups
      for (int i = 1 + keepCount; i < groups.length; i++) {
        final g = groups[i];
        final gl = g.label?.trim() ?? '';
        for (final field in g.fields) {
          final fl = field.label?.trim() ?? '';
          final fk = gl.isNotEmpty ? '$gl.$fl' : fl;
          map.remove(fk);
          map.remove('${fk}_image');
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Root group
        CustomFieldEditor(
          groups: [filteredGroups[0]],
          value: allValues,
          onChanged: (updatedValue) {
            final updated = Map<String, dynamic>.from(updatedValue);

            // dọn key dropdown cũ nếu còn
            updated.remove("${widget.indicator.name}_episode_count");

            final newPrevYes = (prevLabel != null)
                ? isYes(updated[prevLabel], prevLabel)
                : false;

            if (!newPrevYes) {
              if (countLabel != null) updated.remove(countLabel);
              cleanupHiddenEpisodeGroups(updated, keepCount: 0);
            } else {
              final newCount =
                  (countLabel != null) ? parseCount(updated[countLabel]) : 0;
              cleanupHiddenEpisodeGroups(updated,
                  keepCount: newCount.clamp(0, 3));
            }

            widget.onChanged(updated);
          },
        ),

        // Episode groups
        if (prevYes && count > 0)
          ...filteredGroups.skip(1).map(
                (g) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CustomFieldEditor(
                    groups: [g],
                    value: allValues,
                    onChanged: (updatedValue) {
                      widget.onChanged(Map<String, dynamic>.from(updatedValue));
                    },
                  ),
                ),
              ),
      ],
    );
  }

  // 196/66: checkbox + chi tiết (thức ăn / thuốc) + cleanup
  Widget _buildSpecial196or66(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    // ✅ không cast cứng
    final allValues = _asMap(widget.value);

    final selected = (allValues[widget.indicator.id.toString()] is List)
        ? List<String>.from(
            (allValues[widget.indicator.id.toString()] as List)
                .map((e) => e.toString()),
          )
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CustomCheckboxGroup(
          label: '',
          selectedValues: selected,
          options: const [
            "Stress",
            "Thức ăn",
            "Chống viêm, giảm đau (Paracetalmon,...)"
          ],
          onChanged: (newValues) {
            final m = Map<String, dynamic>.from(allValues);

            final normalized = newValues.map((e) => e.toString()).toList();
            if (normalized.isNotEmpty) {
              m[widget.indicator.id.toString()] = normalized;
            } else {
              m.remove(widget.indicator.id.toString());
            }

            // Cleanup chi tiết nếu không chọn
            if (!normalized.contains('Thức ăn')) {
              m.remove('Chi tiết thức ăn làm nặng bệnh');
            }
            if (!normalized
                .contains('Chống viêm, giảm đau (Paracetalmon,...)')) {
              m.remove('Chi tiết thuốc làm nặng bệnh');
            }

            widget.onChanged(m);
          },
          enabled: true,
        ),
        if (selected.contains('Thức ăn'))
          InputTextField(
            label: 'Chi tiết thức ăn làm nặng bệnh',
            textController: TextEditingController(
              text: (allValues['Chi tiết thức ăn làm nặng bệnh'] ?? '')
                  .toString(),
            ),
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              if (v.trim().isNotEmpty) {
                m['Chi tiết thức ăn làm nặng bệnh'] = v;
              } else {
                m.remove('Chi tiết thức ăn làm nặng bệnh');
              }
              widget.onChanged(m);
            },
          ),
        if (selected.contains('Chống viêm, giảm đau (Paracetalmon,...)'))
          InputTextField(
            label: 'Chi tiết thuốc làm nặng bệnh',
            textController: TextEditingController(
              text:
                  (allValues['Chi tiết thuốc làm nặng bệnh'] ?? '').toString(),
            ),
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              if (v.trim().isNotEmpty) {
                m['Chi tiết thuốc làm nặng bệnh'] = v;
              } else {
                m.remove('Chi tiết thuốc làm nặng bệnh');
              }
              widget.onChanged(m);
            },
          ),
      ],
    );
  }

  Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map<String, dynamic>) return Map<String, dynamic>.from(v);
    if (v is Map)
      return Map<String, dynamic>.from(
          v.map((k, val) => MapEntry(k.toString(), val)));
    return <String, dynamic>{};
  }

  /// lấy list theo key (key có thể là id string). nếu value là String -> convert thành [String]
  List<String> _listFromMap(Map<String, dynamic> m, String key) {
    final raw = m[key];
    if (raw == null) return <String>[];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is String && raw.trim().isNotEmpty) return <String>[raw.trim()];
    return <String>[];
  }

  /// fallback: nếu widget.value đang là List/String (không phải Map) thì vẫn đọc được selected
  List<String> _listFromAny(dynamic v) {
    if (v == null) return <String>[];
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String && v.trim().isNotEmpty) return <String>[v.trim()];
    return <String>[];
  }

  // 182/69: checkbox + mô tả khác + cleanup
  Widget _buildSpecial182or69(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    final allValues = _asMap(widget.value);

    // ưu tiên đúng shape: map[id] = List<String>
    // fallback: nếu widget.value là List/String thì vẫn hiển thị được
    final selected =
        _listFromMap(allValues, widget.indicator.id.toString()).isNotEmpty
            ? _listFromMap(allValues, widget.indicator.id.toString())
            : _listFromAny(widget.value);

    final otherText = (allValues['Mô tả hình dạng khác'] ?? '').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CustomCheckboxGroup(
          label: 'Chọn hình dạng bạn gặp phải',
          selectedValues: selected,
          options: const ['Tròn/Oval', 'Dài', 'Hình dạng khác'],
          onChanged: (newValues) {
            final m = Map<String, dynamic>.from(allValues);
            m[widget.indicator.id.toString()] = newValues;

            if (!newValues.contains('Hình dạng khác')) {
              m.remove('Mô tả hình dạng khác');
            }
            widget.onChanged(m);
          },
          enabled: true,
        ),
        if (selected.contains('Hình dạng khác'))
          InputTextField(
            label: 'Mô tả hình dạng khác',
            textController: TextEditingController(text: otherText),
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              if (v.trim().isNotEmpty) {
                m['Mô tả hình dạng khác'] = v;
              } else {
                m.remove('Mô tả hình dạng khác');
              }
              widget.onChanged(m);
            },
          ),
      ],
    );
  }

  // 185/71: 2 radio + input khi chọn "Khác (theo giờ)" + cleanup
  Widget _buildSpecial185or71(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    // ✅ không cast cứng nữa
    final allValues = _asMap(widget.value);

    final sel1 = allValues['11.1 Khi dùng thuốc']?.toString();
    final sel2 = allValues['11.2 Khi không dùng thuốc']?.toString();

    final input1 =
        (allValues['Nhập khoảng thời gian (dùng thuốc)'] ?? '').toString();
    final input2 = (allValues['Nhập khoảng thời gian (không dùng thuốc)'] ?? '')
        .toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CustomRadioGroup(
          label: '11.1 Khi dùng thuốc',
          value: (sel1 != null && sel1.trim().isNotEmpty) ? sel1 : null,
          options: const [
            '< 1h',
            '1-6h',
            '6h-12h',
            '12-24h',
            'Không biết',
            'Khác (theo giờ)',
          ],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            final vv = v?.toString() ?? '';

            if (vv.trim().isNotEmpty) {
              m['11.1 Khi dùng thuốc'] = vv;
            } else {
              m.remove('11.1 Khi dùng thuốc');
            }

            if (vv != 'Khác (theo giờ)') {
              m.remove('Nhập khoảng thời gian (dùng thuốc)');
            }

            widget.onChanged(m);
          },
        ),
        if (sel1 == 'Khác (theo giờ)')
          InputTextField(
            label: 'Nhập khoảng thời gian',
            textController: TextEditingController(text: input1),
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              final vv = v.toString();

              if (vv.trim().isNotEmpty) {
                m['Nhập khoảng thời gian (dùng thuốc)'] = vv;
              } else {
                m.remove('Nhập khoảng thời gian (dùng thuốc)');
              }

              widget.onChanged(m);
            },
          ),
        CustomRadioGroup(
          label: '11.2 Khi không dùng thuốc',
          value: (sel2 != null && sel2.trim().isNotEmpty) ? sel2 : null,
          options: const [
            '< 1h',
            '1-6h',
            '6h-12h',
            '12-24h',
            'Không biết',
            'Khác (theo giờ)',
          ],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            final vv = v?.toString() ?? '';

            if (vv.trim().isNotEmpty) {
              m['11.2 Khi không dùng thuốc'] = vv;
            } else {
              m.remove('11.2 Khi không dùng thuốc');
            }

            if (vv != 'Khác (theo giờ)') {
              m.remove('Nhập khoảng thời gian (không dùng thuốc)');
            }

            widget.onChanged(m);
          },
        ),
        if (sel2 == 'Khác (theo giờ)')
          InputTextField(
            label: 'Nhập khoảng thời gian',
            textController: TextEditingController(text: input2),
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              final vv = v.toString();

              if (vv.trim().isNotEmpty) {
                m['Nhập khoảng thời gian (không dùng thuốc)'] = vv;
              } else {
                m.remove('Nhập khoảng thời gian (không dùng thuốc)');
              }

              widget.onChanged(m);
            },
          ),
      ],
    );
  }

  // 180/67: 2 radio 7.1/7.2
  Widget _buildSpecial180or67(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    final allValues = _asMap(widget.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CustomRadioGroup(
          label: '7.1 Khi dùng thuốc',
          value: allValues['7.1 Khi dùng thuốc']?.toString(),
          options: const ['< 3 mm', '3-10 mm', '10-50 mm', '> 50 mm'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            if (v != null && v.toString().trim().isNotEmpty) {
              m['7.1 Khi dùng thuốc'] = v;
            } else {
              m.remove('7.1 Khi dùng thuốc');
            }
            widget.onChanged(m);
          },
        ),
        CustomRadioGroup(
          label: '7.2 Khi không dùng thuốc',
          value: allValues['7.2 Khi không dùng thuốc']?.toString(),
          options: const ['< 3 mm', '3-10 mm', '10-50 mm', '> 50 mm'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            if (v != null && v.toString().trim().isNotEmpty) {
              m['7.2 Khi không dùng thuốc'] = v;
            } else {
              m.remove('7.2 Khi không dùng thuốc');
            }
            widget.onChanged(m);
          },
        ),
      ],
    );
  }

  // ===================== MAIN BUILD =====================
  @override
  Widget build(BuildContext context) {
    // 1) Special indicator guard
    final special = _buildSpecialIndicatorIfAny(context);
    if (special != null) return special;

    final indicator = widget.indicator;
    final valueType = widget.valueTypeOverride ?? indicator.valueType;
    final label = widget.labelOverride ?? indicator.name;

    final unit = (widget.unitOverride ?? widget.unit ?? indicator.unit)
        ?.toString()
        .trim();
    final displayLabel = _displayLabel(label, unit);

    final minValue = widget.minValueOverride ?? indicator.minValue;
    final maxValue = widget.maxValueOverride ?? indicator.maxValue;
    final valueOptions = widget.valueOptionsOverride ?? indicator.valueOptions;

    switch (parseFieldType(valueType)) {
      case FieldType.text:
      case FieldType.number:
        return InputTextField(
          label: displayLabel,
          keyboardType: valueType == 'number'
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          textController: _controller,
          hintText: _rangeHint(minValue, maxValue),
          onChanged: (newValue) {
            if (valueType == 'number') {
              final parsedValue = num.tryParse(newValue);
              widget.onChanged(
                  _isValueNotEmpty(parsedValue) ? parsedValue : newValue);
            } else {
              widget.onChanged(_isValueNotEmpty(newValue) ? newValue : '');
            }
          },
        );

      case FieldType.select:
        return Column(
          children: [
            //FieldLabel(displayLabel ?? ''),
            const SizedBox(height: 6),
            CustomRadioGroup(
              label: "",
              value: widget.value is String ? widget.value : null,
              options: valueOptions is List
                  ? List<String>.from(valueOptions.map((e) => e.toString()))
                  : <String>[],
              onChanged: widget.onChanged,
              isRequired: false,
              enabled: true,
            ),
          ],
        );

      case FieldType.multiSelection:
        // default: List<String> ở indicator-level
        final selected = (widget.value is List)
            ? List<String>.from(widget.value.map((e) => e.toString().trim()))
            : (widget.value is Map && (widget.value as Map)['values'] is List)
                ? List<String>.from(((widget.value as Map)['values'] as List)
                    .map((e) => e.toString().trim()))
                : <String>[];

        return CustomCheckboxGroup(
          label: displayLabel,
          selectedValues: selected,
          options: valueOptions is List
              ? List<String>.from(valueOptions.map((e) => e.toString().trim()))
              : <String>[],
          onChanged: (newValues) {
            if (widget.value is Map) {
              final updated = Map<String, dynamic>.from(widget.value as Map);
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
        final dateValue =
            widget.value is String && widget.value.toString().isNotEmpty
                ? DateTime.tryParse(widget.value.toString())
                : null;

        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              locale: const Locale('vi'),
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
              locale: const Locale('vi'),
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
        final min = double.tryParse(minValue?.toString() ?? '') ?? 0.0;
        final max = double.tryParse(maxValue?.toString() ?? '') ?? 100.0;

        final range = _parseRange(widget.value, min, max);
        final divisions = _rangeDivisions(min, max);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayLabel),
            const SizedBox(height: 8),
            Text(
              '${range.start.toStringAsFixed(0)} - ${range.end.toStringAsFixed(0)}'
              '${unit != null && unit.trim().isNotEmpty ? " $unit" : ""}',
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
                widget.onChanged({"start": v.start, "end": v.end});
              },
            ),
          ],
        );

      case FieldType.custom:
        // valueOptions shape: { group: [...] } (tham khảo IndicatorField)
        final groupJson = (valueOptions is Map) ? valueOptions['group'] : null;
        List<CustomFieldGroup> groups = [];
        if (groupJson is List) {
          groups = groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
        } else if (groupJson is Map<String, dynamic>) {
          groups = [CustomFieldGroup.fromJson(groupJson)];
        } else if (valueOptions is Map<String, dynamic>) {
          // fallback: parse field json
          final cf = CustomField.fromJson(valueOptions);
          groups = cf.groups ?? [];
        }

        return CustomFieldEditor(
          groups: groups,
          value: widget.value is Map
              ? Map<String, dynamic>.from(widget.value as Map)
              : <String, dynamic>{},
          onChanged: widget.onChanged,
        );

      default:
        return Text('Kiểu dữ liệu không hỗ trợ: $valueType');
    }
  }

  String? _rangeHint(dynamic min, dynamic max) {
    if (min != null || max != null) {
      return 'Giới hạn: ${min?.toString() ?? "−∞"} ~ ${max?.toString() ?? "+∞"}';
    }
    return null;
  }
}
