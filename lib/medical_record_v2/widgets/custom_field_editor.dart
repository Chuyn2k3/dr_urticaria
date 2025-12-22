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
// class CustomFieldEditor extends StatefulWidget {
//   final VitalIndicator indicator;
//   final List<CustomFieldGroup>? groups;
//   final Map<String, dynamic> value; // flat map (key can be "Group.Field")
//   final ValueChanged<Map<String, dynamic>> onChanged;
//
//   const CustomFieldEditor({
//     super.key,
//     this.groups,
//     required this.value,
//     required this.onChanged,
//     required this.indicator,
//   });
//
//   @override
//   State<CustomFieldEditor> createState() => _CustomFieldEditorState();
// }
//
// class _CustomFieldEditorState extends State<CustomFieldEditor> {
//   final Map<String, TextEditingController> _controllers = {};
//
//   // Split '.' an toàn: không cắt giữa 2 chữ số (vd "6.3 Bàn tay")
//   List<String> _splitKeyParts(String key) {
//     final parts = <String>[];
//     final buf = StringBuffer();
//     for (int i = 0; i < key.length; i++) {
//       final ch = key[i];
//       if (ch == '.') {
//         final prevIsDigit = i > 0 && _isDigit(key.codeUnitAt(i - 1));
//         final nextIsDigit =
//             i + 1 < key.length && _isDigit(key.codeUnitAt(i + 1));
//         if (!(prevIsDigit && nextIsDigit)) {
//           parts.add(buf.toString());
//           buf.clear();
//           continue;
//         }
//       }
//       buf.write(ch);
//     }
//     parts.add(buf.toString());
//     return parts;
//   }
//
//   bool _isDigit(int c) => c >= 48 && c <= 57;
//
//   bool _isValueNotEmpty(dynamic val) {
//     if (val == null) return false;
//     if (val is String) return val.trim().isNotEmpty;
//     if (val is num) return true;
//     if (val is List) return val.isNotEmpty;
//     if (val is Map) return val.isNotEmpty;
//     return true;
//   }
//
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
//
//   Map<String, dynamic> _expandFormValue(Map<String, dynamic> flat) {
//     final Map<String, dynamic> nested = {};
//
//     void putPath(String path, dynamic value) {
//       final parts = _splitKeyParts(path);
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
//
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
//
//     return nested;
//   }
//
//   @override
//   void didUpdateWidget(covariant CustomFieldEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     final expandedValue = _expandFormValue(widget.value);
//
//     for (final group in widget.groups ?? []) {
//       final gl = group.label?.trim() ?? '';
//       for (var i = 0; i < group.fields.length; i++) {
//         final field = group.fields[i];
//
//         // ✅ FIX precedence: ?? phải ôm cả biểu thức ternary
//         final fl = (field.label ?? (gl.isNotEmpty ? gl : 'field_$i')).trim();
//
//         final fullKey = _fullKey(gl, fl);
//
//         final fieldValue = _getValueByKey(expandedValue, fullKey) ??
//             (field.type == FieldType.custom ? {} : null);
//
//         if (field.type == FieldType.text ||
//             field.type == FieldType.number ||
//             field.type == FieldType.range) {
//           _controllers[fullKey] ??= TextEditingController();
//           final newText = _displayTextForController(field.type, fieldValue);
//           if (_controllers[fullKey]!.text != newText) {
//             _controllers[fullKey]!.text = newText;
//           }
//         }
//       }
//     }
//   }
//
//   String _displayTextForController(FieldType type, dynamic value) {
//     if (type == FieldType.range) {
//       final r = _parseDateRangeValue(value);
//       if (r == null) return '';
//       return '${_fmtDate(r.start)}  →  ${_fmtDate(r.end)}';
//     }
//     return value?.toString() ?? '';
//   }
//
//   @override
//   void dispose() {
//     for (final c in _controllers.values) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.groups == null || widget.groups!.isEmpty) {
//       return const Text('Không có trường dữ liệu');
//     }
//
//     final expandedValue = _expandFormValue(widget.value);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: widget.groups!.map((group) {
//         final groupLabel = group.label?.trim() ?? '';
//
//         return Card(
//           elevation: 1,
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (groupLabel.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: Text(
//                       groupLabel,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: AppColors.bgBlueDark,
//                       ),
//                     ),
//                   ),
//                 ...group.fields.asMap().entries.map((fieldEntry) {
//                   final field = fieldEntry.value;
//                   final fieldLabel =
//                       (field.label ?? 'field_${fieldEntry.key}').trim();
//                   final fullKey = _fullKey(groupLabel, fieldLabel);
//                   final resolvedValue = _getValueByKey(expandedValue, fullKey);
//
//                   // ===== Hard-coded special show/hide rules (đã có ở IndicatorField) =====
//                   if (!_shouldShowFieldBySpecialRules(
//                     group: group,
//                     groupLabel: groupLabel,
//                     fieldLabel: fieldLabel,
//                     expandedValue: expandedValue,
//                   )) {
//                     return const SizedBox.shrink();
//                   }
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     child: _buildFieldEditor(
//                       context: context,
//                       field: field,
//                       resolvedValue: resolvedValue,
//                       group: group,
//                       groupLabel: groupLabel,
//                       fieldLabel: fieldLabel,
//                       fullKey: fullKey,
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   // ====== Special show/hide rules copied (generic trigger by label) ======
//   bool _shouldShowFieldBySpecialRules({
//     required CustomFieldGroup group,
//     required String groupLabel,
//     required String fieldLabel,
//     required Map<String, dynamic> expandedValue,
//   }) {
//     // treatment-dependent fields
//     if ((fieldLabel == "Tên thuốc" ||
//             fieldLabel == "Liều thuốc (ghi thời gian nếu nhớ)" ||
//             fieldLabel == "Tình trạng tổn thương khi đang uống thuốc") &&
//         (widget.indicator.id == 175 || widget.indicator.id == 64)) {
//       String treatmentKey;
//       if (groupLabel.isEmpty) {
//         treatmentKey =
//             'Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)';
//       } else {
//         treatmentKey = groupLabel.isNotEmpty
//             ? '$groupLabel.Có điều trị hay không?'
//             : 'Có điều trị hay không?';
//       }
//
//       final tv = _getValueByKey(expandedValue, treatmentKey) ??
//           widget.value[treatmentKey];
//       final isYes = (tv is Map && tv[treatmentKey] == 'Có') ||
//           (tv is String && tv.trim() == 'Có');
//       return isYes;
//     }
//
//     // symptom-dependent field
//     if (fieldLabel == "Triệu chứng Giảm xuống/ Nặng lên là gì?") {
//       final statusKey = groupLabel.isNotEmpty
//           ? '$groupLabel.Tình trạng tổn thương khi đang uống thuốc'
//           : 'Tình trạng tổn thương khi đang uống thuốc';
//       final sv =
//           _getValueByKey(expandedValue, statusKey) ?? widget.value[statusKey];
//       final ok = (sv is Map &&
//               (sv['Tình trạng tổn thương khi đang uống thuốc'] ==
//                       'Giảm xuống' ||
//                   sv['Tình trạng tổn thương khi đang uống thuốc'] ==
//                       'Nặng lên')) ||
//           (sv is String &&
//               (sv.trim() == 'Giảm xuống' || sv.trim() == 'Nặng lên'));
//       return ok;
//     }
//
//     // only show "Số đợt..." when "Trước đây..." == Có
//     if (fieldLabel.contains("Số đợt bị tương tự như đợt này")) {
//       final prevKey = group.fields.map((x) => x.label?.trim() ?? '').firstWhere(
//             (l) =>
//                 l.contains(
//                     "Trước đây bạn đã từng bị đợt nào tương tự như vậy chưa?") ||
//                 l.contains("Trước đây bạn đã từng bị đợt nào tương tự"),
//             orElse: () => '',
//           );
//
//       if (prevKey.isEmpty) return false;
//
//       final pv =
//           _getValueByKey(expandedValue, prevKey) ?? widget.value[prevKey];
//       final isYes = (pv is String && pv.trim() == 'Có') ||
//           (pv is Map && pv[prevKey]?.toString().trim() == 'Có');
//       return isYes;
//     }
//
//     return true;
//   }
//
//   // ====== Date range helpers (FieldType.range = date range) ======
//   String _fmtDate(DateTime d) {
//     final dd = d.day.toString().padLeft(2, '0');
//     final mm = d.month.toString().padLeft(2, '0');
//     return '$dd/$mm/${d.year}';
//   }
//
//   DateTimeRange? _parseDateRangeValue(dynamic value) {
//     if (value == null) return null;
//
//     if (value is Map) {
//       final s = value['start']?.toString();
//       final e = value['end']?.toString();
//       final sd = s == null ? null : DateTime.tryParse(s);
//       final ed = e == null ? null : DateTime.tryParse(e);
//       if (sd != null && ed != null) return DateTimeRange(start: sd, end: ed);
//     }
//
//     if (value is List && value.length >= 2) {
//       final sd = DateTime.tryParse(value[0].toString());
//       final ed = DateTime.tryParse(value[1].toString());
//       if (sd != null && ed != null) return DateTimeRange(start: sd, end: ed);
//     }
//
//     return null;
//   }
//
//   int? _weeksFromDateRange(DateTimeRange? r) {
//     if (r == null) return null;
//     final days = r.end.difference(r.start).inDays;
//     if (days < 0) return null;
//     return (days / 7).ceil();
//   }
//
//   // ====== Core editor ======
//   Widget _buildFieldEditor({
//     required BuildContext context,
//     required CustomField field,
//     required dynamic resolvedValue,
//     required CustomFieldGroup group,
//     required String groupLabel,
//     required String fieldLabel,
//     required String fullKey,
//   }) {
//     // dependsOn
//     if (field.dependsOn != null && field.dependsOnValues != null) {
//       final depKey = field.dependsOn!.trim();
//       final expanded = _expandFormValue(widget.value);
//       final depFullKey = groupLabel.isNotEmpty ? '$groupLabel.$depKey' : depKey;
//
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
//
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
//             final updated = Map<String, dynamic>.from(widget.value);
//
//             if (newValue.trim().isNotEmpty) {
//               updated[fullKey] = field.type == FieldType.number
//                   ? (num.tryParse(newValue) ?? newValue)
//                   : newValue;
//             } else {
//               updated.remove(fullKey);
//             }
//
//             widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//           },
//         );
//
//       case FieldType.select:
//         // - select có ảnh: "key": "Option", "key_image": "URL"
//         // - image-only: "key": "URL"
//         final needsImage = (field.requiredFields ?? [])
//             .any((rf) => rf.type == FieldType.image);
//         final options = field.options ?? [];
//         final bool imageOnly = needsImage && options.length <= 1;
//
//         if (imageOnly) {
//           String? url;
//           if (resolvedValue is String && resolvedValue.trim().isNotEmpty) {
//             url = resolvedValue;
//           } else if (resolvedValue is Map) {
//             final k = field.label ?? '';
//             url = (resolvedValue['${k}_image'] as String?) ??
//                 (resolvedValue['image'] as String?);
//           }
//
//           return ImageUploadField(
//             label: field.label ?? 'Ảnh',
//             templateId: 16,
//             initialImageUrl: url,
//             onChanged: (link) {
//               final updated = Map<String, dynamic>.from(widget.value);
//               if (link != null && link.isNotEmpty) {
//                 updated[fullKey] = link;
//               } else {
//                 updated.remove(fullKey);
//               }
//               widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//             },
//           );
//         }
//
//         final expanded = _expandFormValue(widget.value);
//         final imageUrl =
//             _getValueByKey(expanded, '${fullKey}_image')?.toString();
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomRadioGroup(
//               label: field.label ?? '',
//               value: resolvedValue is String ? resolvedValue : null,
//               options: options,
//               onChanged: (newValue) {
//                 final updated = Map<String, dynamic>.from(widget.value);
//                 if (newValue != null && newValue.toString().trim().isNotEmpty) {
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
//             if (needsImage &&
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
//
//       case FieldType.multiSelection:
//         final needsImage = (field.requiredFields ?? [])
//             .any((rf) => rf.type == FieldType.image);
//
//         if (needsImage) {
//           Map<String, String?> selectedWithImages = {};
//           List<String> selectedValues = [];
//
//           if (resolvedValue is Map<String, dynamic>) {
//             selectedWithImages =
//                 resolvedValue.map((k, v) => MapEntry(k, v?.toString()));
//             selectedValues = selectedWithImages.keys.toList();
//           }
//
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
//                         data[opt] = selectedWithImages[opt];
//                       }
//                       if (data.isNotEmpty) {
//                         updated[fullKey] = data;
//                       } else {
//                         updated.remove(fullKey);
//                       }
//                       setState(() {
//                         selectedWithImages = data;
//                         selectedValues = newValues;
//                       });
//                       widget.onChanged(
//                           _flattenFormValue(_expandFormValue(updated)));
//                     },
//                     isRequired: false,
//                     enabled: true,
//                   ),
//                   ...selectedValues.map((option) {
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: ImageUploadField(
//                         label: "Ảnh cho $option",
//                         templateId: 16,
//                         initialImageUrl: selectedWithImages[option],
//                         onChanged: (imageUrl) {
//                           final updated =
//                               Map<String, dynamic>.from(widget.value);
//                           final current =
//                               _getValueByKey(_expandFormValue(updated), fullKey)
//                                       as Map<String, dynamic>? ??
//                                   {};
//                           final next = Map<String, String?>.from(
//                             current.map((k, v) => MapEntry(k, v?.toString())),
//                           );
//                           next[option] =
//                               (imageUrl != null && imageUrl.isNotEmpty)
//                                   ? imageUrl
//                                   : null;
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
//         }
//
//         return CustomCheckboxGroup(
//           label: field.label ?? '',
//           selectedValues: resolvedValue is List<String>
//               ? resolvedValue
//               : (resolvedValue is List
//                   ? List<String>.from(resolvedValue.map((e) => e.toString()))
//                   : <String>[]),
//           options: field.options ?? [],
//           onChanged: (newValues) {
//             final updated = Map<String, dynamic>.from(widget.value);
//             if (newValues.isNotEmpty) {
//               updated[fullKey] = newValues;
//             } else {
//               updated.remove(fullKey);
//             }
//             widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//           },
//           isRequired: false,
//           enabled: true,
//         );
//
//       case FieldType.fullDate:
//         return InkWell(
//           onTap: () async {
//             DateTime initial = DateTime.now();
//             if (resolvedValue is String && resolvedValue.isNotEmpty) {
//               final parsed = DateTime.tryParse(resolvedValue);
//               if (parsed != null) initial = parsed;
//             } else if (resolvedValue is DateTime) {
//               initial = resolvedValue;
//             }
//
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: initial,
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );
//
//             if (picked != null) {
//               final updated = Map<String, dynamic>.from(widget.value);
//               final normalized =
//                   DateTime(picked.year, picked.month, picked.day);
//               updated[fullKey] = normalized.toIso8601String();
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
//             child: Text(_formatDisplayDate(resolvedValue)),
//           ),
//         );
//
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
//
//       case FieldType.range:
//         final current = _parseDateRangeValue(resolvedValue);
//         final display = (current == null)
//             ? ''
//             : '${_fmtDate(current.start)}  →  ${_fmtDate(current.end)}';
//
//         _controllers[fullKey] ??= TextEditingController(text: display);
//         if (_controllers[fullKey]!.text != display) {
//           _controllers[fullKey]!.text = display;
//         }
//
//         return InkWell(
//           onTap: () async {
//             final picked = await showDateRangePicker(
//               context: context,
//               firstDate: DateTime(1970),
//               lastDate: DateTime(2100),
//               initialDateRange: current,
//             );
//
//             final updated = Map<String, dynamic>.from(widget.value);
//
//             if (picked == null) {
//               updated.remove(fullKey);
//               _cleanupWeeksIfAny(updated, groupLabel: groupLabel, group: group);
//               widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//               return;
//             }
//
//             updated[fullKey] = {
//               "start": picked.start.toIso8601String(),
//               "end": picked.end.toIso8601String(),
//             };
//
//             // auto-set "Số tuần bị đợt này" (nếu có trong cùng group)
//             _autoSetWeeksIfAny(updated,
//                 groupLabel: groupLabel, group: group, rangeKey: fullKey);
//
//             widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
//           },
//           child: IgnorePointer(
//             child: InputTextField(
//               label: field.label ?? 'Chọn khoảng thời gian',
//               enabled: false,
//               prefixIcon: const Icon(Icons.date_range),
//               textController: _controllers[fullKey],
//               onChanged: (_) {},
//             ),
//           ),
//         );
//
//       case FieldType.custom:
//         return CustomFieldEditor(
//           indicator: widget.indicator,
//           groups: field.groups,
//           value: resolvedValue is Map<String, dynamic>
//               ? resolvedValue
//               : <String, dynamic>{},
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
//
//       default:
//         return Text('⚠️ Kiểu dữ liệu không hỗ trợ: ${field.type}');
//     }
//   }
//
//   void _autoSetWeeksIfAny(
//     Map<String, dynamic> flat, {
//     required String groupLabel,
//     required CustomFieldGroup group,
//     required String rangeKey,
//   }) {
//     final weekField = group.fields.firstWhere(
//       (x) => (x.label ?? '').contains("Số tuần bị đợt này"),
//       orElse: () =>
//           CustomField(label: null, description: null, type: FieldType.unknown),
//     );
//
//     final weekLabel = weekField.label?.trim();
//     if (weekLabel == null || weekLabel.isEmpty) return;
//
//     final weekKey =
//         groupLabel.isNotEmpty ? '$groupLabel.$weekLabel' : weekLabel;
//     final r = _parseDateRangeValue(flat[rangeKey]);
//     final weeks = _weeksFromDateRange(r);
//
//     if (weeks != null) {
//       flat[weekKey] = weeks;
//     } else {
//       flat.remove(weekKey);
//     }
//   }
//
//   void _cleanupWeeksIfAny(
//     Map<String, dynamic> flat, {
//     required String groupLabel,
//     required CustomFieldGroup group,
//   }) {
//     final weekField = group.fields.firstWhere(
//       (x) => (x.label ?? '').contains("Số tuần bị đợt này"),
//       orElse: () =>
//           CustomField(label: null, description: null, type: FieldType.unknown),
//     );
//     final weekLabel = weekField.label?.trim();
//     if (weekLabel == null || weekLabel.isEmpty) return;
//
//     final weekKey =
//         groupLabel.isNotEmpty ? '$groupLabel.$weekLabel' : weekLabel;
//     flat.remove(weekKey);
//   }
//
//   String _fullKey(String groupLabel, String fieldLabel) {
//     return groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;
//   }
//
//   dynamic _getValueByKey(Map<String, dynamic> map, String fullKey) {
//     final parts = _splitKeyParts(fullKey);
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
//
//   String _formatDisplayDate(dynamic raw) {
//     if (raw == null) return 'Chọn ngày';
//     DateTime? dt;
//     if (raw is DateTime) {
//       dt = raw;
//     } else if (raw is String) {
//       dt = DateTime.tryParse(raw);
//     }
//     if (dt == null) return 'Chọn ngày';
//     return DateFormat('dd/MM/yyyy').format(dt);
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

class CustomFieldEditor extends StatefulWidget {
  final VitalIndicator indicator;
  final List<CustomFieldGroup>? groups;
  final Map<String, dynamic> value; // flat map (key can be "Group.Field")
  final ValueChanged<Map<String, dynamic>> onChanged;
  const CustomFieldEditor({
    super.key,
    this.groups,
    required this.value,
    required this.onChanged,
    required this.indicator,
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

  bool _isValueNotEmpty(dynamic val) {
    if (val == null) return false;
    if (val is String) return val.trim().isNotEmpty;
    if (val is num) return true;
    if (val is List) return val.isNotEmpty;
    if (val is Map) return val.isNotEmpty;
    return true;
  }

  Map<String, dynamic> _flattenFormValue(
    Map<String, dynamic> nested, {
    String prefix = '',
  }) {
    final Map<String, dynamic> flat = {};
    nested.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        flat.addAll(_flattenFormValue(value, prefix: newKey));
      } else if (value is List && value.every((e) => e is String)) {
        // Nếu là list URL ảnh, flatten as is (nhưng giữ nguyên list)
        if (value.isNotEmpty) {
          flat[newKey] = value;
        }
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
      final gl = group.label?.trim() ?? '';
      for (var i = 0; i < group.fields.length; i++) {
        final field = group.fields[i];
        // ✅ FIX precedence: ?? phải ôm cả biểu thức ternary
        final fl = (field.label ?? (gl.isNotEmpty ? gl : 'field_$i')).trim();
        final fullKey = _fullKey(gl, fl);
        final fieldValue = _getValueByKey(expandedValue, fullKey) ??
            (field.type == FieldType.custom ? {} : null);
        if (field.type == FieldType.text ||
            field.type == FieldType.number ||
            field.type == FieldType.range) {
          _controllers[fullKey] ??= TextEditingController();
          final newText = _displayTextForController(field.type, fieldValue);
          if (_controllers[fullKey]!.text != newText) {
            _controllers[fullKey]!.text = newText;
          }
        }
      }
    }
  }

  String _displayTextForController(FieldType type, dynamic value) {
    if (type == FieldType.range) {
      final r = _parseDateRangeValue(value);
      if (r == null) return '';
      return '${_fmtDate(r.start)} → ${_fmtDate(r.end)}';
    }
    return value?.toString() ?? '';
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groups == null || widget.groups!.isEmpty) {
      return const Text('Không có trường dữ liệu');
    }
    final expandedValue = _expandFormValue(widget.value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.groups!.map((group) {
        final groupLabel = group.label?.trim() ?? '';
        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (groupLabel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      groupLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.bgBlueDark,
                      ),
                    ),
                  ),
                ...group.fields.asMap().entries.map((fieldEntry) {
                  final field = fieldEntry.value;
                  final fieldLabel =
                      (field.label ?? 'field_${fieldEntry.key}').trim();
                  final fullKey = _fullKey(groupLabel, fieldLabel);
                  final resolvedValue = _getValueByKey(expandedValue, fullKey);
                  // ===== Hard-coded special show/hide rules (đã có ở IndicatorField) =====
                  if (!_shouldShowFieldBySpecialRules(
                    group: group,
                    groupLabel: groupLabel,
                    fieldLabel: fieldLabel,
                    expandedValue: expandedValue,
                  )) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: _buildFieldEditor(
                      context: context,
                      field: field,
                      resolvedValue: resolvedValue,
                      group: group,
                      groupLabel: groupLabel,
                      fieldLabel: fieldLabel,
                      fullKey: fullKey,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ====== Special show/hide rules copied (generic trigger by label) ======
  bool _shouldShowFieldBySpecialRules({
    required CustomFieldGroup group,
    required String groupLabel,
    required String fieldLabel,
    required Map<String, dynamic> expandedValue,
  }) {
    // treatment-dependent fields
    if ((fieldLabel == "Tên thuốc" ||
            fieldLabel == "Liều thuốc (ghi thời gian nếu nhớ)" ||
            fieldLabel == "Tình trạng tổn thương khi đang uống thuốc") &&
        (widget.indicator.id == 175 || widget.indicator.id == 64)) {
      String treatmentKey;
      if (groupLabel.isEmpty) {
        treatmentKey =
            'Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)';
      } else {
        treatmentKey = groupLabel.isNotEmpty
            ? '$groupLabel.Có điều trị hay không?'
            : 'Có điều trị hay không?';
      }
      final tv = _getValueByKey(expandedValue, treatmentKey) ??
          widget.value[treatmentKey];
      final isYes = (tv is Map && tv[treatmentKey] == 'Có') ||
          (tv is String && tv.trim() == 'Có');
      return isYes;
    }
    // symptom-dependent field
    if (fieldLabel == "Triệu chứng Giảm xuống/ Nặng lên là gì?") {
      final statusKey = groupLabel.isNotEmpty
          ? '$groupLabel.Tình trạng tổn thương khi đang uống thuốc'
          : 'Tình trạng tổn thương khi đang uống thuốc';
      final sv =
          _getValueByKey(expandedValue, statusKey) ?? widget.value[statusKey];
      final ok = (sv is Map &&
              (sv['Tình trạng tổn thương khi đang uống thuốc'] ==
                      'Giảm xuống' ||
                  sv['Tình trạng tổn thương khi đang uống thuốc'] ==
                      'Nặng lên')) ||
          (sv is String &&
              (sv.trim() == 'Giảm xuống' || sv.trim() == 'Nặng lên'));
      return ok;
    }
    // only show "Số đợt..." when "Trước đây..." == Có
    if (fieldLabel.contains("Số đợt bị tương tự như đợt này")) {
      final prevKey = group.fields.map((x) => x.label?.trim() ?? '').firstWhere(
            (l) =>
                l.contains(
                    "Trước đây bạn đã từng bị đợt nào tương tự như vậy chưa?") ||
                l.contains("Trước đây bạn đã từng bị đợt nào tương tự"),
            orElse: () => '',
          );
      if (prevKey.isEmpty) return false;
      final pv =
          _getValueByKey(expandedValue, prevKey) ?? widget.value[prevKey];
      final isYes = (pv is String && pv.trim() == 'Có') ||
          (pv is Map && pv[prevKey]?.toString().trim() == 'Có');
      return isYes;
    }
    return true;
  }

  // ====== Date range helpers (FieldType.range = date range) ======
  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  DateTimeRange? _parseDateRangeValue(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final s = value['start']?.toString();
      final e = value['end']?.toString();
      final sd = s == null ? null : DateTime.tryParse(s);
      final ed = e == null ? null : DateTime.tryParse(e);
      if (sd != null && ed != null) return DateTimeRange(start: sd, end: ed);
    }
    if (value is List && value.length >= 2) {
      final sd = DateTime.tryParse(value[0].toString());
      final ed = DateTime.tryParse(value[1].toString());
      if (sd != null && ed != null) return DateTimeRange(start: sd, end: ed);
    }
    return null;
  }

  int? _weeksFromDateRange(DateTimeRange? r) {
    if (r == null) return null;
    final days = r.end.difference(r.start).inDays;
    if (days < 0) return null;
    return (days / 7).ceil();
  }

  // ====== Core editor ======
  Widget _buildFieldEditor({
    required BuildContext context,
    required CustomField field,
    required dynamic resolvedValue,
    required CustomFieldGroup group,
    required String groupLabel,
    required String fieldLabel,
    required String fullKey,
  }) {
    // dependsOn
    if (field.dependsOn != null && field.dependsOnValues != null) {
      final depKey = field.dependsOn!.trim();
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
            if (newValue.trim().isNotEmpty) {
              updated[fullKey] = field.type == FieldType.number
                  ? (num.tryParse(newValue) ?? newValue)
                  : newValue;
            } else {
              updated.remove(fullKey);
            }
            widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
          },
        );
      case FieldType.select:
        // - select có ảnh: "key": "Option", "key_image": ["URL1", "URL2", ...]
        // - image-only: "key": ["URL1", "URL2", ...]
        final needsImage = (field.requiredFields ?? [])
            .any((rf) => rf.type == FieldType.image);
        final options = field.options ?? [];
        final bool imageOnly = needsImage && options.length <= 1;
        if (imageOnly) {
          List<String> urls = [];
          if (resolvedValue is List) {
            urls = List<String>.from(resolvedValue.where((e) => e is String));
          } else if (resolvedValue is Map) {
            final k = field.label ?? '';
            final imageValue =
                resolvedValue['${k}_image'] ?? resolvedValue['image'];
            if (imageValue is List) {
              urls = List<String>.from(imageValue);
            } else if (imageValue is String) {
              urls = [imageValue];
            }
          }
          return ImageUploadField(
            label: field.label ?? 'Ảnh',
            templateId: 16,
            initialImageUrls: urls,
            onChanged: (newImages) {
              final updated = Map<String, dynamic>.from(widget.value);
              if (newImages != null && newImages.isNotEmpty) {
                updated[fullKey] = newImages;
              } else {
                updated.remove(fullKey);
              }
              widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
            },
          );
        }
        final expanded = _expandFormValue(widget.value);
        dynamic imageValue = _getValueByKey(expanded, '${fullKey}_image');
        final List<String> imageUrls = imageValue is List
            ? List<String>.from(imageValue.map((e) => e.toString()))
            : [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRadioGroup(
              label: field.label ?? '',
              value: resolvedValue is String ? resolvedValue : null,
              options: options,
              onChanged: (newValue) {
                final updated = Map<String, dynamic>.from(widget.value);
                if (newValue != null && newValue.toString().trim().isNotEmpty) {
                  updated[fullKey] = newValue;
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
                  initialImageUrls: imageUrls,
                  onChanged: (newImages) {
                    final updated = Map<String, dynamic>.from(widget.value);
                    if (newImages != null && newImages.isNotEmpty) {
                      updated['${fullKey}_image'] = newImages;
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
          Map<String, List<String>> selectedWithImages = {};
          List<String> selectedValues = [];
          if (resolvedValue is Map<String, dynamic>) {
            selectedWithImages = resolvedValue.map((k, v) => MapEntry(
                k,
                v is List
                    ? List<String>.from(v)
                    : (v != null ? [v.toString()] : [])));
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
                      final data = <String, List<String>>{};
                      for (final opt in newValues) {
                        data[opt] = selectedWithImages[opt] ?? [];
                      }
                      if (data.isNotEmpty) {
                        updated[fullKey] = data;
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
                        initialImageUrls: selectedWithImages[option],
                        onChanged: (newImages) {
                          final updated =
                              Map<String, dynamic>.from(widget.value);
                          final current =
                              _getValueByKey(_expandFormValue(updated), fullKey)
                                      as Map<String, dynamic>? ??
                                  {};
                          final next = Map<String, List<String>>.from(
                              current.map((k, v) => MapEntry(
                                  k, v is List ? List<String>.from(v) : [])));
                          next[option] = newImages ?? [];
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
        }
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
              updated[fullKey] = newValues;
            } else {
              updated.remove(fullKey);
            }
            widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
          },
          isRequired: false,
          enabled: true,
        );
      case FieldType.fullDate:
        return InkWell(
          onTap: () async {
            DateTime initial = DateTime.now();
            if (resolvedValue is String && resolvedValue.isNotEmpty) {
              final parsed = DateTime.tryParse(resolvedValue);
              if (parsed != null) initial = parsed;
            } else if (resolvedValue is DateTime) {
              initial = resolvedValue;
            }
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              final updated = Map<String, dynamic>.from(widget.value);
              final normalized =
                  DateTime(picked.year, picked.month, picked.day);
              updated[fullKey] = normalized.toIso8601String();
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
            child: Text(_formatDisplayDate(resolvedValue)),
          ),
        );
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
      case FieldType.range:
        final current = _parseDateRangeValue(resolvedValue);
        final display = (current == null)
            ? ''
            : '${_fmtDate(current.start)} → ${_fmtDate(current.end)}';
        _controllers[fullKey] ??= TextEditingController(text: display);
        if (_controllers[fullKey]!.text != display) {
          _controllers[fullKey]!.text = display;
        }
        return InkWell(
          onTap: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
              initialDateRange: current,
            );
            final updated = Map<String, dynamic>.from(widget.value);
            if (picked == null) {
              updated.remove(fullKey);
              _cleanupWeeksIfAny(updated, groupLabel: groupLabel, group: group);
              widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
              return;
            }
            updated[fullKey] = {
              "start": picked.start.toIso8601String(),
              "end": picked.end.toIso8601String(),
            };
            // auto-set "Số tuần bị đợt này" (nếu có trong cùng group)
            _autoSetWeeksIfAny(updated,
                groupLabel: groupLabel, group: group, rangeKey: fullKey);
            widget.onChanged(_flattenFormValue(_expandFormValue(updated)));
          },
          child: IgnorePointer(
            child: InputTextField(
              label: field.label ?? 'Chọn khoảng thời gian',
              enabled: false,
              prefixIcon: const Icon(Icons.date_range),
              textController: _controllers[fullKey],
              onChanged: (_) {},
            ),
          ),
        );
      case FieldType.custom:
        return CustomFieldEditor(
          indicator: widget.indicator,
          groups: field.groups,
          value: resolvedValue is Map<String, dynamic>
              ? resolvedValue
              : <String, dynamic>{},
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

  void _autoSetWeeksIfAny(
    Map<String, dynamic> flat, {
    required String groupLabel,
    required CustomFieldGroup group,
    required String rangeKey,
  }) {
    final weekField = group.fields.firstWhere(
      (x) => (x.label ?? '').contains("Số tuần bị đợt này"),
      orElse: () =>
          CustomField(label: null, description: null, type: FieldType.unknown),
    );
    final weekLabel = weekField.label?.trim();
    if (weekLabel == null || weekLabel.isEmpty) return;
    final weekKey =
        groupLabel.isNotEmpty ? '$groupLabel.$weekLabel' : weekLabel;
    final r = _parseDateRangeValue(flat[rangeKey]);
    final weeks = _weeksFromDateRange(r);
    if (weeks != null) {
      flat[weekKey] = weeks;
    } else {
      flat.remove(weekKey);
    }
  }

  void _cleanupWeeksIfAny(
    Map<String, dynamic> flat, {
    required String groupLabel,
    required CustomFieldGroup group,
  }) {
    final weekField = group.fields.firstWhere(
      (x) => (x.label ?? '').contains("Số tuần bị đợt này"),
      orElse: () =>
          CustomField(label: null, description: null, type: FieldType.unknown),
    );
    final weekLabel = weekField.label?.trim();
    if (weekLabel == null || weekLabel.isEmpty) return;
    final weekKey =
        groupLabel.isNotEmpty ? '$groupLabel.$weekLabel' : weekLabel;
    flat.remove(weekKey);
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

  String _formatDisplayDate(dynamic raw) {
    if (raw == null) return 'Chọn ngày';
    DateTime? dt;
    if (raw is DateTime) {
      dt = raw;
    } else if (raw is String) {
      dt = DateTime.tryParse(raw);
    }
    if (dt == null) return 'Chọn ngày';
    return DateFormat('dd/MM/yyyy').format(dt);
  }
}
