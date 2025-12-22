// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
//
// import '../../../constant/color.dart';
// import '../../../models/vital_indicator_model.dart';
// import '../../../utils/enum/field_type_enum.dart';
// import '../../../widget/text_field/input_text_field.dart';
// import '../../widgets/custom_checkbox_group.dart';
// import '../../widgets/custom_radio_group.dart';
// import '../../widgets/image_upload_field.dart';
//
// class IndicatorField extends StatefulWidget {
//   final VitalIndicator indicator;
//   final dynamic value;
//   final Function(dynamic) onChanged;
//   final int templateId;
//
//   const IndicatorField({
//     super.key,
//     required this.indicator,
//     required this.value,
//     required this.onChanged,
//     required this.templateId,
//   });
//
//   @override
//   State<IndicatorField> createState() => _IndicatorFieldState();
// }
//
// class _IndicatorFieldState extends State<IndicatorField> {
//   // Controllers bền theo vòng đời để tránh nhảy con trỏ
//   late final TextEditingController _textCtrl = TextEditingController();
//   late final TextEditingController _numCtrl = TextEditingController();
//   // Controllers cho custom fields (key = fullKey)
//   final Map<String, TextEditingController> _customCtrls = {};
//
//   // Patch key để child SELECT (custom) gửi ảnh: parent ghi "<key>_image"
//   static const String _kImagePatchKey = '__field_image__patch';
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.indicator.valueType == 'text') {
//       _textCtrl.text = (widget.value ?? '').toString();
//     } else if (widget.indicator.valueType == 'number') {
//       _numCtrl.text = widget.value?.toString() ?? '';
//     }
//   }
//
//   @override
//   void didUpdateWidget(covariant IndicatorField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.indicator.valueType == 'text') {
//       final newText = (widget.value ?? '').toString();
//       if (_textCtrl.text != newText) _textCtrl.text = newText;
//     } else if (widget.indicator.valueType == 'number') {
//       final newText = widget.value?.toString() ?? '';
//       if (_numCtrl.text != newText) _numCtrl.text = newText;
//     }
//   }
//
//   @override
//   void dispose() {
//     _textCtrl.dispose();
//     _numCtrl.dispose();
//     for (final c in _customCtrls.values) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   // ====== Helpers ======
//   bool _isValueNotEmpty(dynamic val) {
//     if (val == null) return false;
//     if (val is String) return val.trim().isNotEmpty;
//     if (val is num) return true;
//     if (val is List) return val.isNotEmpty;
//     if (val is Map) return val.isNotEmpty;
//     return true;
//   }
//
//   TextEditingController _ctrlFor(String key, String initial) {
//     final c = _customCtrls[key];
//     if (c == null) {
//       final nc = TextEditingController(text: initial);
//       _customCtrls[key] = nc;
//       return nc;
//     }
//     if (c.text != initial) c.text = initial;
//     return c;
//   }
//
//   bool _hasHtml(String s) {
//     // Tạm thời nhận diện rất đơn giản: có thẻ <img>, <br>, <p>, ...
//     return s.contains('<img') || s.contains('<br') || s.contains('<p');
//   }
//
//   String _fmtDate(DateTime d) {
//     final dd = d.day.toString().padLeft(2, '0');
//     final mm = d.month.toString().padLeft(2, '0');
//     return '$dd/$mm/${d.year}';
//   }
//
//   DateTimeRange? _parseDateRangeValue(dynamic value) {
//     if (value == null) return null;
//
//     // shape recommended: {"start": "...iso...", "end": "...iso..."}
//     if (value is Map) {
//       final s = value['start']?.toString();
//       final e = value['end']?.toString();
//       final sd = s == null ? null : DateTime.tryParse(s);
//       final ed = e == null ? null : DateTime.tryParse(e);
//       if (sd != null && ed != null) return DateTimeRange(start: sd, end: ed);
//     }
//
//     // fallback: List [startIso, endIso]
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
//     // Công thức: số ngày giữa 2 mốc / 7
//     return (days / 7).ceil();
//   }
//
// // ✅ 1) THÊM helper label có unit (áp dụng cho Xét nghiệm: WBC (G/L), CRP (mg/L)...)
//   String _indicatorLabelWithUnit() {
//     final name = widget.indicator.name;
//     final unit = widget.indicator.unit?.toString().trim();
//     final minValue = widget.indicator.minValue ?? '';
//     final maxValue = widget.indicator.maxValue ?? '';
//
//     // Tránh phá HTML label
//     if (_hasHtml(name)) return name;
//
//     // Nếu có unit, hiển thị với đơn vị
//     if (unit != null && unit.isNotEmpty) {
//       return '$name ($unit)${_getRangeText(minValue, maxValue)}';
//     }
//
//     // Nếu không có unit, chỉ hiển thị tên
//     return '$name${_getRangeText(minValue, maxValue)}';
//   }
//
// // Phương thức giúp định dạng thêm min/max vào nhãn
//   String _getRangeText(String minValue, String maxValue) {
//     if (minValue.isNotEmpty && maxValue.isNotEmpty) {
//       return ' (Giới hạn: $minValue - $maxValue)';
//     } else if (minValue.isNotEmpty) {
//       return ' (Giới hạn: >= $minValue)';
//     } else if (maxValue.isNotEmpty) {
//       return ' (Giới hạn: <= $maxValue)';
//     }
//     return '';
//   }
//
//   Widget _buildIndicatorLabel({
//     String? textOverride,
//     TextStyle? textStyle,
//   }) {
//     final raw = textOverride ?? widget.indicator.name;
//     // Nếu có HTML, dùng Html widget
//     if (_hasHtml(raw)) {
//       return Html(
//         data: raw,
//         style: {
//           // style thân
//           'body': Style(
//             margin: Margins.zero,
//             padding: HtmlPaddings.zero,
//             fontSize: FontSize(14),
//             fontWeight: FontWeight.w500,
//           ),
//           // style ảnh
//           'img': Style(
//             margin: Margins.only(bottom: 8),
//             // có thể giới hạn width nếu muốn
//             // width: Width(200),
//           ),
//         },
//       );
//     }
//
//     // Nếu không có HTML thì hiển thị Text bình thường
//     return Text(
//       raw,
//       style: textStyle ??
//           const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//     );
//   }
//
//   // ====== Build ======
//   @override
//   Widget build(BuildContext context) {
//     final indicatorLabel = _indicatorLabelWithUnit();
//     switch (widget.indicator.valueType) {
//       case "text":
//         return InputTextField(
//           label: indicatorLabel,
//           textController: _textCtrl,
//           onChanged: widget.onChanged,
//         );
//
//       case "number":
//         return InputTextField(
//           label: indicatorLabel,
//           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           textController: _numCtrl,
//           onChanged: (val) => widget.onChanged(num.tryParse(val) ?? val),
//         );
//
//       case "boolean":
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(indicatorLabel, style: Theme.of(context).textTheme.bodyMedium),
//             Row(
//               children: [
//                 Expanded(
//                   child: RadioListTile<bool>(
//                     title: const Text("Có"),
//                     value: true,
//                     groupValue: widget.value as bool?,
//                     onChanged: widget.onChanged,
//                     activeColor: AppColors.primaryColor,
//                   ),
//                 ),
//                 Expanded(
//                   child: RadioListTile<bool>(
//                     title: const Text("Không"),
//                     value: false,
//                     groupValue: widget.value as bool?,
//                     onChanged: widget.onChanged,
//                     activeColor: AppColors.primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//
//       case "selection":
//         final options = widget.indicator.valueOptions as List<String>? ?? [];
//
//         // Nếu trong name có HTML/ảnh (ví dụ id 192), hiển thị label riêng
//         if (_hasHtml(widget.indicator.name)) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildIndicatorLabel(textOverride: widget.indicator.name),
//               const SizedBox(height: 8),
//               CustomRadioGroup(
//                 label: '', // không cần label text nữa
//                 value: widget.value,
//                 options: options,
//                 onChanged: widget.onChanged,
//               ),
//             ],
//           );
//         }
//
//         // Các indicator selection bình thường
//         return CustomRadioGroup(
//           label: indicatorLabel,
//           value: widget.value,
//           options: options,
//           onChanged: widget.onChanged,
//         );
//
//       case "multi_selection":
//         final options = widget.indicator.valueOptions as List<String>? ?? [];
//
//         // Đặc thù 190 giữ nguyên (tương tự 65 cũ, nhưng chỉ 190 ở đây)
//         if (widget.indicator.id == 190 || widget.indicator.id == 65) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//           final radioKey = "${widget.indicator.name}_radio";
//           final radioValue =
//               allValues[radioKey] as String? ?? "Một cách ngẫu nhiên";
//           final selected =
//               (allValues[widget.indicator.id.toString()] as List<dynamic>?)
//                       ?.cast<String>() ??
//                   [];
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomRadioGroup(
//                 label: indicatorLabel,
//                 value: radioValue,
//                 options: const [
//                   "Một cách ngẫu nhiên",
//                   "Khi có các yếu tố kích thích"
//                 ],
//                 onChanged: (val) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   if (val is String && val.isNotEmpty) {
//                     m[radioKey] = val;
//                   } else {
//                     m.remove(radioKey);
//                   }
//                   if (val == "Một cách ngẫu nhiên") {
//                     m.remove(widget.indicator.id.toString());
//                   }
//                   widget.onChanged(m);
//                 },
//               ),
//               if (radioValue == "Khi có các yếu tố kích thích")
//                 CustomCheckboxGroup(
//                   label: "Chọn các yếu tố kích thích",
//                   selectedValues: selected,
//                   options:
//                       options.skip(2).toList(), // Bỏ 2 option đầu cho checkbox
//                   onChanged: (newValues) {
//                     final m = Map<String, dynamic>.from(allValues);
//                     if (newValues.isNotEmpty) {
//                       m[widget.indicator.id.toString()] = newValues;
//                     } else {
//                       m.remove(widget.indicator.id.toString());
//                     }
//                     widget.onChanged(m);
//                   },
//                   enabled: true,
//                 ),
//             ],
//           );
//         }
//
//         // Mặc định indicator-level (không ảnh)
//         final selected = (widget.value as List<String>?) ?? [];
//         return CustomCheckboxGroup(
//           label: indicatorLabel,
//           selectedValues: selected,
//           options: options,
//           onChanged: widget.onChanged,
//           enabled: true,
//         );
//
//       case "full_date":
//         final dateValue = widget.value is String && widget.value.isNotEmpty
//             ? DateTime.tryParse(widget.value)
//             : null;
//
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               // locale: const Locale('vi'),
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
//               label: indicatorLabel,
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
//       case "fullDate":
//         final dateValue = widget.value is String && widget.value.isNotEmpty
//             ? DateTime.tryParse(widget.value)
//             : null;
//
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               // locale: const Locale('vi'),
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
//               label: indicatorLabel,
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
//       case "range":
//         final range =
//             (widget.value as RangeValues?) ?? const RangeValues(0, 100);
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(indicatorLabel),
//             RangeSlider(
//               values: range,
//               min: 0,
//               max: 100,
//               divisions: 20,
//               activeColor: AppColors.primaryColor,
//               onChanged: widget.onChanged,
//             ),
//           ],
//         );
//
//       case "custom":
//         final groupJson = widget.indicator.valueOptions['group'];
//         List<CustomFieldGroup> groups = [];
//         if (groupJson is List) {
//           groups = groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
//         } else if (groupJson is Map<String, dynamic>) {
//           groups = [CustomFieldGroup.fromJson(groupJson)];
//         }
//
//         // Đặc thù 175: hiển thị nhóm Thông tin đợt 1/2/3 theo lựa chọn "Số đợt bị tương tự như đợt này"
//         if (widget.indicator.id == 175 || widget.indicator.id == 64) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//
//           String? _findFieldLabelContains(CustomFieldGroup g, String needle) {
//             for (final f in g.fields) {
//               final l = f.label?.trim();
//               if (l != null && l.contains(needle)) return l;
//             }
//             return null;
//           }
//
//           bool _isYes(dynamic v, String key) {
//             if (v is String) return v.trim() == 'Có';
//             if (v is Map) return v[key]?.toString().trim() == 'Có';
//             return false;
//           }
//
//           int _parseCount(dynamic v) {
//             if (v == null) return 0;
//             if (v is num) return v.toInt();
//             final s = v.toString();
//             final m = RegExp(r'(\d+)').firstMatch(s);
//             return m == null ? 0 : (int.tryParse(m.group(1)!) ?? 0);
//           }
//
//           final rootGroup = groups.isNotEmpty ? groups.first : null;
//
//           // Tìm đúng label theo JSON (tránh hardcode sai câu)
//           final prevLabel = rootGroup == null
//               ? null
//               : _findFieldLabelContains(
//                   rootGroup, "Trước đây bạn đã từng bị đợt nào tương tự");
//           final countLabel = rootGroup == null
//               ? null
//               : _findFieldLabelContains(
//                   rootGroup, "Số đợt bị tương tự như đợt này");
//
//           final prevYes = (prevLabel != null)
//               ? _isYes(allValues[prevLabel], prevLabel)
//               : false;
//
//           // Count lấy trực tiếp từ field selection "1 đợt/2 đợt/3 đợt"
//           final count = (prevYes && countLabel != null)
//               ? _parseCount(allValues[countLabel])
//               : 0;
//
//           // Root (Thông tin đợt này) luôn có
//           // Nếu count = 1 => show Thông tin đợt 1
//           // Nếu count = 2 => show Thông tin đợt 1 + 2
//           // Nếu count = 3 => show 1 + 2 + 3
//           final List<CustomFieldGroup> filteredGroups = [];
//           if (groups.isNotEmpty) filteredGroups.add(groups[0]);
//           if (prevYes && count > 0) {
//             filteredGroups
//                 .addAll(groups.skip(1).take(count.clamp(0, groups.length - 1)));
//           }
//
//           void _cleanupHiddenEpisodeGroups(Map<String, dynamic> map,
//               {required int keepCount}) {
//             // Xóa dữ liệu các group "Thông tin đợt i" bị ẩn (i > keepCount)
//             // groups[0] = root, groups[1] = đợt 1, groups[2] = đợt 2, groups[3] = đợt 3
//             for (int i = 1 + keepCount; i < groups.length; i++) {
//               final g = groups[i];
//               final gl = g.label?.trim() ?? '';
//               for (final field in g.fields) {
//                 final fl = field.label?.trim() ?? '';
//                 final fk = gl.isNotEmpty ? '$gl.$fl' : fl;
//                 map.remove(fk);
//                 map.remove('${fk}_image');
//               }
//             }
//           }
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(widget.indicator.name,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//
//               // Root group: chứa "Trước đây..." và "Số đợt..." (field "Số đợt" sẽ được ẩn nếu chọn "Không" ở phần 2 bên dưới)
//               if (filteredGroups.isNotEmpty)
//                 buildCustomField(filteredGroups[0], widget.value,
//                     (updatedValue) {
//                   final updated = (updatedValue is Map<String, dynamic>)
//                       ? Map<String, dynamic>.from(updatedValue)
//                       : Map<String, dynamic>.from(allValues);
//
//                   // Nếu đổi từ "Có" -> "Không": xóa count + xóa toàn bộ nhóm đợt 1/2/3
//                   final newPrevYes = (prevLabel != null)
//                       ? _isYes(updated[prevLabel], prevLabel)
//                       : false;
//
//                   // dọn luôn key dropdown cũ nếu còn tồn tại (do code cũ tạo)
//                   updated.remove("${widget.indicator.name}_episode_count");
//
//                   if (!newPrevYes) {
//                     if (countLabel != null) updated.remove(countLabel);
//                     _cleanupHiddenEpisodeGroups(updated, keepCount: 0);
//                   } else {
//                     // Nếu có "Có" thì dọn theo count hiện tại (nếu người dùng giảm số đợt)
//                     final newCount = (countLabel != null)
//                         ? _parseCount(updated[countLabel])
//                         : 0;
//                     _cleanupHiddenEpisodeGroups(updated,
//                         keepCount: newCount.clamp(0, 3));
//                   }
//
//                   widget.onChanged(updated);
//                 }),
//
//               // Render nhóm Thông tin đợt 1/2/3 theo count
//               if (prevYes && count > 0)
//                 ...filteredGroups.skip(1).map(
//                     (g) => buildCustomField(g, widget.value, (updatedValue) {
//                           final updated = (updatedValue is Map<String, dynamic>)
//                               ? Map<String, dynamic>.from(updatedValue)
//                               : Map<String, dynamic>.from(allValues);
//                           widget.onChanged(updated);
//                         })),
//             ],
//           );
//         }
//         if (widget.indicator.id == 209 || widget.indicator.id == 204) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//
//           // Với JSON bạn đưa: group[0].fields[0] = selection (Có/Không)
//           // group[0].fields[1] = text "Số lần bị khó thở"
//           final root = groups.isNotEmpty ? groups.first : null;
//
//           // key lưu selection và text được build theo logic của buildCustomField:
//           // fieldKey = (groupLabel.isNotEmpty ? "$groupLabel.$fieldLabel" : fieldLabel)
//           final groupLabel = (root?.label ?? '').trim();
//
//           // Do field đầu tiên label="" => code buildCustomField đang fallback "field_0"
//           final selectKey =
//               groupLabel.isNotEmpty ? '$groupLabel.field_0' : 'field_0';
//
//           // Field thứ 2 label="Số lần bị khó thở"
//           const timesLabel = 'Số lần bị khó thở';
//           final timesKey =
//               groupLabel.isNotEmpty ? '$groupLabel.$timesLabel' : timesLabel;
//
//           final selected = allValues[selectKey]?.toString().trim();
//           final isYes = selected == 'Có';
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // label câu hỏi (indicator name)
//               Text(
//                 widget.indicator.name,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//
//               // Selection Có/Không
//               CustomRadioGroup(
//                 label: '',
//                 value: selected,
//                 options: const ['Có', 'Không'],
//                 onChanged: (v) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   if (v == null || v.toString().trim().isEmpty) {
//                     m.remove(selectKey);
//                   } else {
//                     m[selectKey] = v.toString();
//                   }
//
//                   // Nếu chọn "Không" => xóa luôn ô số lần
//                   if (v.toString().trim() != 'Có') {
//                     m.remove(timesKey);
//                   }
//
//                   widget.onChanged(m);
//                 },
//               ),
//
//               // Chỉ hiện ô nhập khi chọn Có
//               if (isYes)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: InputTextField(
//                     label: timesLabel,
//                     keyboardType: TextInputType.number,
//                     onChanged: (txt) {
//                       final m = Map<String, dynamic>.from(allValues);
//                       final t = txt.trim();
//                       if (t.isEmpty) {
//                         m.remove(timesKey);
//                       } else {
//                         m[timesKey] = t;
//                       }
//                       widget.onChanged(m);
//                     },
//                   ),
//                 ),
//             ],
//           );
//         }
//         // Xử lý cho id 196: Yếu tố làm nặng bệnh - hiển thị chi tiết nếu chọn "Thức ăn" hoặc "Chống viêm, giảm đau (Paracetalmon,...)"
//         if (widget.indicator.id == 196 || widget.indicator.id == 66) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//           final selected =
//               (allValues[widget.indicator.id.toString()] as List<String>?) ??
//                   [];
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(indicatorLabel,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               CustomCheckboxGroup(
//                 label: '',
//                 selectedValues: selected,
//                 options: [
//                   "Stress",
//                   "Thức ăn",
//                   "Chống viêm, giảm đau (Paracetalmon,...)"
//                 ],
//                 onChanged: (newValues) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   m[widget.indicator.id.toString()] = newValues;
//                   // Cleanup chi tiết nếu không chọn
//                   if (!newValues.contains('Thức ăn')) {
//                     m.remove('Chi tiết thức ăn');
//                   }
//                   if (!newValues
//                       .contains('Chống viêm, giảm đau (Paracetalmon,...)')) {
//                     m.remove('Chi tiết thuốc');
//                   }
//                   widget.onChanged(m);
//                 },
//                 enabled: true,
//               ),
//               if (selected.contains('Thức ăn'))
//                 InputTextField(
//                   label: 'Chi tiết thức ăn',
//                   onChanged: (v) {
//                     final m = Map<String, dynamic>.from(allValues);
//                     m['Chi tiết thức ăn'] = v;
//                     widget.onChanged(m);
//                   },
//                 ),
//               if (selected.contains('Chống viêm, giảm đau (Paracetalmon,...)'))
//                 InputTextField(
//                   label: 'Chi tiết thuốc',
//                   onChanged: (v) {
//                     final m = Map<String, dynamic>.from(allValues);
//                     m['Chi tiết thuốc'] = v;
//                     widget.onChanged(m);
//                   },
//                 ),
//             ],
//           );
//         }
//
//         // Xử lý cho id 182: Hình dạng - hiển thị mô tả nếu chọn "Hình dạng khác"
//         if (widget.indicator.id == 182 || widget.indicator.id == 69) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//           final selected =
//               (allValues[widget.indicator.id.toString()] as List<String>?) ??
//                   [];
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(indicatorLabel,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               CustomCheckboxGroup(
//                 label: 'Chọn hình dạng bạn gặp phải',
//                 selectedValues: selected,
//                 options: ['Tròn/Oval', 'Dài', 'Hình dạng khác'],
//                 onChanged: (newValues) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   m[widget.indicator.id.toString()] = newValues;
//                   if (!newValues.contains('Hình dạng khác')) {
//                     m.remove('Mô tả hình dạng khác');
//                   }
//                   widget.onChanged(m);
//                 },
//                 enabled: true,
//               ),
//               if (selected.contains('Hình dạng khác'))
//                 InputTextField(
//                   label: 'Mô tả hình dạng khác',
//                   onChanged: (v) {
//                     final m = Map<String, dynamic>.from(allValues);
//                     m['Mô tả hình dạng khác'] = v;
//                     widget.onChanged(m);
//                   },
//                 ),
//             ],
//           );
//         }
//
//         // Xử lý cho id 185: Thời gian tồn tại - hiển thị nhập nếu chọn "Khác (theo giờ)"
//         if (widget.indicator.id == 185 || widget.indicator.id == 71) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//           final sel1 = allValues['11.1 Khi dùng thuốc'] as String?;
//           final sel2 = allValues['11.2 Khi không dùng thuốc'] as String?;
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(indicatorLabel,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               CustomRadioGroup(
//                 label: '11.1 Khi dùng thuốc',
//                 value: sel1,
//                 options: [
//                   '< 1h',
//                   '1-6h',
//                   '6h-12h',
//                   '12-24h',
//                   'Không biết',
//                   'Khác (theo giờ)'
//                 ],
//                 onChanged: (v) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   m['11.1 Khi dùng thuốc'] = v;
//                   if (v != 'Khác (theo giờ)') {
//                     m.remove('Nhập khoảng thời gian (dùng thuốc)');
//                   }
//                   widget.onChanged(m);
//                 },
//               ),
//               if (sel1 == 'Khác (theo giờ)')
//                 InputTextField(
//                   label: 'Nhập khoảng thời gian',
//                   onChanged: (v) {
//                     final m = Map<String, dynamic>.from(allValues);
//                     m['Nhập khoảng thời gian (dùng thuốc)'] = v;
//                     widget.onChanged(m);
//                   },
//                 ),
//               CustomRadioGroup(
//                 label: '11.2 Khi không dùng thuốc',
//                 value: sel2,
//                 options: [
//                   '< 1h',
//                   '1-6h',
//                   '6h-12h',
//                   '12-24h',
//                   'Không biết',
//                   'Khác (theo giờ)'
//                 ],
//                 onChanged: (v) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   m['11.2 Khi không dùng thuốc'] = v;
//                   if (v != 'Khác (theo giờ)') {
//                     m.remove('Nhập khoảng thời gian (không dùng thuốc)');
//                   }
//                   widget.onChanged(m);
//                 },
//               ),
//               if (sel2 == 'Khác (theo giờ)')
//                 InputTextField(
//                   label: 'Nhập khoảng thời gian',
//                   onChanged: (v) {
//                     final m = Map<String, dynamic>.from(allValues);
//                     m['Nhập khoảng thời gian (không dùng thuốc)'] = v;
//                     widget.onChanged(m);
//                   },
//                 ),
//             ],
//           );
//         }
//         if (widget.indicator.id == 81 || widget.indicator.id == 41) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//           final sel1 = allValues['4.1 Khi dùng thuốc'] as String?;
//           final sel2 = allValues['4.2 Khi không dùng thuốc'] as String?;
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(indicatorLabel,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               CustomRadioGroup(
//                 label: '4.1 Khi dùng thuốc',
//                 value: sel1,
//                 options: [
//                   '< 1h',
//                   '1-6h',
//                   '6h-12h',
//                   '12-24h',
//                   'Không biết',
//                   'Khác (theo giờ)'
//                 ],
//                 onChanged: (v) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   m['4.1 Khi dùng thuốc'] = v;
//                   if (v != 'Khác (theo giờ)') {
//                     m.remove('Nhập khoảng thời gian (dùng thuốc)');
//                   }
//                   widget.onChanged(m);
//                 },
//               ),
//               if (sel1 == 'Khác (theo giờ)')
//                 InputTextField(
//                   label: 'Nhập khoảng thời gian',
//                   onChanged: (v) {
//                     final m = Map<String, dynamic>.from(allValues);
//                     m['Nhập khoảng thời gian (dùng thuốc)'] = v;
//                     widget.onChanged(m);
//                   },
//                 ),
//               CustomRadioGroup(
//                 label: '4.2 Khi không dùng thuốc',
//                 value: sel2,
//                 options: [
//                   '< 1h',
//                   '1-6h',
//                   '6h-12h',
//                   '12-24h',
//                   'Không biết',
//                   'Khác (theo giờ)'
//                 ],
//                 onChanged: (v) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   m['4.2 Khi không dùng thuốc'] = v;
//                   if (v != 'Khác (theo giờ)') {
//                     m.remove('Nhập khoảng thời gian (không dùng thuốc)');
//                   }
//                   widget.onChanged(m);
//                 },
//               ),
//               if (sel2 == 'Khác (theo giờ)')
//                 InputTextField(
//                   label: 'Nhập khoảng thời gian',
//                   onChanged: (v) {
//                     final m = Map<String, dynamic>.from(allValues);
//                     m['Nhập khoảng thời gian (không dùng thuốc)'] = v;
//                     widget.onChanged(m);
//                   },
//                 ),
//             ],
//           );
//         }
//         if (widget.indicator.id == 89 || widget.indicator.id == 90) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//
//           // Hàm tiện ích cập nhật map
//           void updateValues(String label, dynamic newValue) {
//             final m = Map<String, dynamic>.from(allValues);
//             m[label] = newValue;
//             widget.onChanged(m);
//           }
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//
//               // 1. Tiền sử mắc bệnh lý cơ địa
//               CustomRadioGroup(
//                 label:
//                     'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa',
//                 value: (allValues[
//                             'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa']
//                         as String?) ??
//                     '',
//                 options: ['Có', 'Không', 'Không biết'],
//                 onChanged: (newValue) {
//                   updateValues(
//                       'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa',
//                       newValue);
//                   // Nếu không còn 'Có' thì xóa ghi chú
//                   if (newValue != 'Có') {
//                     allValues.remove(
//                         'ghi_chu_Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa');
//                     widget.onChanged(allValues);
//                   }
//                 },
//                 enabled: true,
//               ),
//               if ((allValues[
//                           'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa']
//                       as String?) ==
//                   'Có')
//                 InputTextField(
//                   label: 'Ghi rõ tên',
//                   onChanged: (v) => updateValues(
//                       'ghi_chu_Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa',
//                       v),
//                 ),
//
//               // 2. Tiền sử bệnh lý tuyến giáp
//               CustomRadioGroup(
//                 label: 'Tiền sử bệnh lý tuyến giáp',
//                 value:
//                     (allValues['Tiền sử bệnh lý tuyến giáp'] as String?) ?? '',
//                 options: ['Có', 'Không', 'Không biết'],
//                 onChanged: (newValue) {
//                   updateValues('Tiền sử bệnh lý tuyến giáp', newValue);
//                   if (newValue != 'Có') {
//                     allValues.remove('ghi_chu_Tiền sử bệnh lý tuyến giáp');
//                     widget.onChanged(allValues);
//                   }
//                 },
//                 enabled: true,
//               ),
//               if ((allValues['Tiền sử bệnh lý tuyến giáp'] as String?) == 'Có')
//                 InputTextField(
//                   label: 'Ghi rõ tên tuyến giáp',
//                   onChanged: (v) =>
//                       updateValues('ghi_chu_Tiền sử bệnh lý tuyến giáp', v),
//                 ),
//
//               // 3. Tiền sử bệnh tự miễn
//               CustomRadioGroup(
//                 label: 'Tiền sử bệnh tự miễn',
//                 value: (allValues['Tiền sử bệnh tự miễn'] as String?) ?? '',
//                 options: ['Có', 'Không', 'Không biết'],
//                 onChanged: (newValue) {
//                   updateValues('Tiền sử bệnh tự miễn', newValue);
//                   if (newValue != 'Có') {
//                     allValues.remove('ghi_chu_Tiền sử bệnh tự miễn');
//                     widget.onChanged(allValues);
//                   }
//                 },
//                 enabled: true,
//               ),
//               if ((allValues['Tiền sử bệnh tự miễn'] as String?) == 'Có')
//                 InputTextField(
//                   label: 'Ghi rõ tên bệnh tự miễn',
//                   onChanged: (v) =>
//                       updateValues('ghi_chu_Tiền sử bệnh tự miễn', v),
//                 ),
//
//               // 4. Tiền sử bệnh lý khác
//               CustomRadioGroup(
//                 label: 'Tiền sử bệnh lý khác',
//                 value: (allValues['Tiền sử bệnh lý khác'] as String?) ?? '',
//                 options: ['Có', 'Không', 'Không biết'],
//                 onChanged: (newValue) {
//                   updateValues('Tiền sử bệnh lý khác', newValue);
//                   if (newValue != 'Có') {
//                     allValues.remove('ghi_chu_Tiền sử bệnh lý khác');
//                     widget.onChanged(allValues);
//                   }
//                 },
//                 enabled: true,
//               ),
//               if ((allValues['Tiền sử bệnh lý khác'] as String?) == 'Có')
//                 InputTextField(
//                   label: 'Ghi rõ tên bệnh lý khác',
//                   onChanged: (v) =>
//                       updateValues('ghi_chu_Tiền sử bệnh lý khác', v),
//                 ),
//
//               // 5. Tiền sử dị ứng
//               CustomRadioGroup(
//                 label: 'Tiền sử dị ứng thuốc, thức ăn khác',
//                 value: (allValues['Tiền sử dị ứng thuốc, thức ăn khác']
//                         as String?) ??
//                     '',
//                 options: ['Có', 'Không', 'Không biết'],
//                 onChanged: (newValue) {
//                   updateValues('Tiền sử dị ứng thuốc, thức ăn khác', newValue);
//                   if (newValue != 'Có') {
//                     allValues
//                         .remove('ghi_chu_Tiền sử dị ứng thuốc, thức ăn khác');
//                     widget.onChanged(allValues);
//                   }
//                 },
//                 enabled: true,
//               ),
//               if ((allValues['Tiền sử dị ứng thuốc, thức ăn khác']
//                       as String?) ==
//                   'Có')
//                 InputTextField(
//                   label: 'Ghi rõ tên dị ứng',
//                   onChanged: (v) => updateValues(
//                       'ghi_chu_Tiền sử dị ứng thuốc, thức ăn khác', v),
//                 ),
//
//               // 6. Tiền sử phản vệ
//               CustomRadioGroup(
//                 label: 'Tiền sử phản vệ',
//                 value: (allValues['Tiền sử phản vệ'] as String?) ?? '',
//                 options: ['Có', 'Không', 'Không biết'],
//                 onChanged: (newValue) {
//                   updateValues('Tiền sử phản vệ', newValue);
//                   if (newValue != 'Có') {
//                     allValues.remove('ghi_chu_Tiền sử phản vệ');
//                     widget.onChanged(allValues);
//                   }
//                 },
//                 enabled: true,
//               ),
//               if ((allValues['Tiền sử phản vệ'] as String?) == 'Có')
//                 InputTextField(
//                   label: 'Ghi rõ tên phản vệ',
//                   onChanged: (v) => updateValues('ghi_chu_Tiền sử phản vệ', v),
//                 ),
//             ],
//           );
//         }
//
//         // Xử lý cho id 180: Kích thước - nhóm selection
//         if (widget.indicator.id == 180 || widget.indicator.id == 67) {
//           final allValues = (widget.value as Map<String, dynamic>?) ?? {};
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(indicatorLabel,
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               CustomRadioGroup(
//                 label: '7.1 Khi dùng thuốc',
//                 value: allValues['7.1 Khi dùng thuốc'],
//                 options: ['< 3 mm', '3-10 mm', '10-50 mm', '> 50 mm'],
//                 onChanged: (v) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   m['7.1 Khi dùng thuốc'] = v;
//                   widget.onChanged(m);
//                 },
//               ),
//               CustomRadioGroup(
//                 label: '7.2 Khi không dùng thuốc',
//                 value: allValues['7.2 Khi không dùng thuốc'],
//                 options: ['< 3 mm', '3-10 mm', '10-50 mm', '> 50 mm'],
//                 onChanged: (v) {
//                   final m = Map<String, dynamic>.from(allValues);
//                   m['7.2 Khi không dùng thuốc'] = v;
//                   widget.onChanged(m);
//                 },
//               ),
//             ],
//           );
//         }
//
//         // Mặc định cho các custom khác (như 179 với multi + image)
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(indicatorLabel,
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: buildCustomField(groups, widget.value, widget.onChanged),
//             ),
//           ],
//         );
//
//       default:
//         return Text("⚠️ Chưa hỗ trợ loại: ${widget.indicator.valueType}");
//     }
//   }
//
//   // --------------------------- CUSTOM BUILDER ---------------------------
//
//   Widget buildCustomField(
//     dynamic fieldOrGroup,
//     dynamic value,
//     Function(dynamic) onChanged, {
//     String parentLabel = '',
//   }) {
//     if (fieldOrGroup is List) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: fieldOrGroup
//             .map((e) => Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: buildCustomField(e, value, onChanged,
//                       parentLabel: parentLabel),
//                 ))
//             .toList(),
//       );
//     }
//
//     if (fieldOrGroup is CustomFieldGroup) {
//       final group = fieldOrGroup;
//       final List<Widget> children = [];
//       final allValues = (value as Map<String, dynamic>?) ?? {};
//       final groupLabel = group.label?.trim() ?? '';
//
//       if (groupLabel.isNotEmpty) {
//         children.add(Text(groupLabel,
//             style: const TextStyle(fontWeight: FontWeight.bold)));
//         children.add(SizedBox(
//           height: 4,
//         ));
//       }
//
//       for (int idx = 0; idx < group.fields.length; idx++) {
//         final f = group.fields[idx];
//         final fieldLabel = f.label?.trim() ?? 'field_$idx';
//         final fieldKey =
//             groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;
//
//         bool shouldShowField = true;
//
//         // Điều kiện cho root group: “Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)”
//         // và cho episode groups: “Có điều trị hay không?”
//         if ((fieldLabel == "Tên thuốc" ||
//                 fieldLabel == "Liều thuốc (ghi thời gian nếu nhớ)" ||
//                 fieldLabel == "Tình trạng tổn thương khi đang uống thuốc") &&
//             (widget.indicator.id == 175 || widget.indicator.id == 64)) {
//           String treatmentKey;
//           if (groupLabel.isEmpty) {
//             // Root group
//             treatmentKey = groupLabel.isNotEmpty
//                 ? '$groupLabel.Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)'
//                 : 'Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)';
//           } else {
//             // Episode groups
//             treatmentKey = groupLabel.isNotEmpty
//                 ? '$groupLabel.Có điều trị hay không?'
//                 : 'Có điều trị hay không?';
//           }
//           final tv = allValues[treatmentKey];
//           final isYes = (tv is Map && tv[treatmentKey] == 'Có') ||
//               (tv is String && tv.trim() == 'Có');
//           shouldShowField = isYes;
//         }
//
//         if (fieldLabel == "Triệu chứng Giảm xuống/ Nặng lên là gì?") {
//           final statusKey = groupLabel.isNotEmpty
//               ? '$groupLabel.Tình trạng tổn thương khi đang uống thuốc'
//               : 'Tình trạng tổn thương khi đang uống thuốc';
//           final sv = allValues[statusKey];
//           final ok = (sv is Map &&
//                   (sv['Tình trạng tổn thương khi đang uống thuốc'] ==
//                           'Giảm xuống' ||
//                       sv['Tình trạng tổn thương khi đang uống thuốc'] ==
//                           'Nặng lên')) ||
//               (sv is String &&
//                   (sv.trim() == 'Giảm xuống' || sv.trim() == 'Nặng lên'));
//           shouldShowField = ok;
//         }
// // Chỉ hiện "Số đợt bị tương tự như đợt này" khi câu "Trước đây bạn đã từng bị đợt nào tương tự như vậy chưa?" = Có
//         if (fieldLabel.contains("Số đợt bị tương tự như đợt này")) {
//           final prevKey = group.fields
//               .map((x) => x.label?.trim() ?? '')
//               .firstWhere(
//                   (l) => l.contains(
//                       "Trước đây bạn đã từng bị đợt nào tương tự như vậy chưa?"),
//                   orElse: () => '');
//
//           if (prevKey.isNotEmpty) {
//             final pv = allValues[prevKey];
//             final isYes = (pv is String && pv.trim() == 'Có') ||
//                 (pv is Map && pv[prevKey]?.toString().trim() == 'Có');
//             shouldShowField = isYes;
//           } else {
//             shouldShowField = false;
//           }
//         }
//
//         if (!shouldShowField) continue;
//
//         final fieldValue = allValues[fieldKey];
//
//         children.add(
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: buildCustomField(
//               f,
//               fieldValue,
//               (updatedValue) {
//                 final newMap = Map<String, dynamic>.from(allValues);
//                 final imageKey = "${fieldKey}_image";
//
//                 // Nhận patch ảnh từ SELECT có ảnh
//                 if (updatedValue is Map &&
//                     updatedValue.containsKey(_kImagePatchKey)) {
//                   final link = updatedValue[_kImagePatchKey];
//                   if (_isValueNotEmpty(link)) {
//                     newMap[imageKey] = link;
//                   } else {
//                     newMap.remove(imageKey);
//                   }
//                 } else {
//                   // Ghi phẳng giá trị field (String/List/Map/URL)
//                   if (_isValueNotEmpty(updatedValue)) {
//                     newMap[fieldKey] = updatedValue;
//                     // NEW: nếu field hiện tại là range (date range) -> tự tính "Số tuần bị đợt này"
//                     if (f.type == FieldType.range) {
//                       // tìm field "Số tuần bị đợt này" trong cùng group
//                       final weekField = group.fields.firstWhere(
//                         (x) => (x.label ?? '').contains("Số tuần bị đợt này"),
//                         orElse: () => CustomField(
//                             label: null,
//                             description: null,
//                             type: FieldType.unknown),
//                       );
//
//                       final weekLabel = weekField.label?.trim();
//                       if (weekLabel != null && weekLabel.isNotEmpty) {
//                         final weekKey = groupLabel.isNotEmpty
//                             ? '$groupLabel.$weekLabel'
//                             : weekLabel;
//
//                         final r = _parseDateRangeValue(newMap[fieldKey]);
//                         final weeks = _weeksFromDateRange(r);
//
//                         if (weeks != null) {
//                           newMap[weekKey] = weeks; // auto set number
//                         } else {
//                           newMap.remove(weekKey);
//                         }
//                       }
//                     }
//                   } else {
//                     newMap.remove(
//                         fieldKey); // NEW: nếu field hiện tại là range (date range) -> tự tính "Số tuần bị đợt này"
//                     if (f.type == FieldType.range) {
//                       // tìm field "Số tuần bị đợt này" trong cùng group
//                       final weekField = group.fields.firstWhere(
//                         (x) => (x.label ?? '').contains("Số tuần bị đợt này"),
//                         orElse: () => CustomField(
//                             label: null,
//                             description: null,
//                             type: FieldType.unknown),
//                       );
//
//                       final weekLabel = weekField.label?.trim();
//                       if (weekLabel != null && weekLabel.isNotEmpty) {
//                         final weekKey = groupLabel.isNotEmpty
//                             ? '$groupLabel.$weekLabel'
//                             : weekLabel;
//
//                         final r = _parseDateRangeValue(newMap[fieldKey]);
//                         final weeks = _weeksFromDateRange(r);
//
//                         if (weeks != null) {
//                           newMap[weekKey] = weeks; // auto set number
//                         } else {
//                           newMap.remove(weekKey);
//                         }
//                       }
//                     }
//                   }
//                 }
//
//                 // Cleanup khi đổi điều trị
//                 if (fieldLabel ==
//                         "Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)" ||
//                     fieldLabel == "Có điều trị hay không?") {
//                   final isYes = updatedValue == "Có" ||
//                       (updatedValue is Map && updatedValue[fieldLabel] == 'Có');
//                   if (!isYes) {
//                     final drugNameKey = groupLabel.isNotEmpty
//                         ? '$groupLabel.Tên thuốc'
//                         : 'Tên thuốc';
//                     final drugDoseKey = groupLabel.isNotEmpty
//                         ? '$groupLabel.Liều thuốc (ghi thời gian nếu nhớ)'
//                         : 'Liều thuốc (ghi thời gian nếu nhớ)';
//                     final statusKey = groupLabel.isNotEmpty
//                         ? '$groupLabel.Tình trạng tổn thương khi đang uống thuốc'
//                         : 'Tình trạng tổn thương khi đang uống thuốc';
//                     final symptomKey = groupLabel.isNotEmpty
//                         ? '$groupLabel.Triệu chứng Giảm xuống/ Nặng lên là gì?'
//                         : 'Triệu chứng Giảm xuống/ Nặng lên là gì?';
//                     newMap.remove(drugNameKey);
//                     newMap.remove(drugDoseKey);
//                     newMap.remove(statusKey);
//                     newMap.remove(symptomKey);
//                   }
//                 }
//
//                 if (fieldLabel == "Tình trạng tổn thương khi đang uống thuốc") {
//                   final keep = updatedValue == "Giảm xuống" ||
//                       updatedValue == "Nặng lên";
//                   if (!keep) {
//                     final symptomKey = groupLabel.isNotEmpty
//                         ? '$groupLabel.Triệu chứng Giảm xuống/ Nặng lên là gì?'
//                         : 'Triệu chứng Giảm xuống/ Nặng lên là gì?';
//                     newMap.remove(symptomKey);
//                   }
//                 }
//
//                 onChanged(newMap);
//               },
//               parentLabel: groupLabel,
//             ),
//           ),
//         );
//       }
//
//       return Column(
//           crossAxisAlignment: CrossAxisAlignment.start, children: children);
//     }
//
//     if (fieldOrGroup is CustomField) {
//       final field = fieldOrGroup;
//       final List<Widget> widgets = [];
//
//       // Tạo fullKey để lưu controller/phẳng key
//       final fullKey = parentLabel.isNotEmpty
//           ? '$parentLabel.${field.label ?? ''}'.trim()
//           : (field.label ?? '').trim();
//
//       switch (field.type) {
//         case FieldType.text:
//           {
//             final text = (value ?? '').toString();
//             final c = _ctrlFor(fullKey, text);
//             widgets.add(
//               InputTextField(
//                 label: field.label ?? '',
//                 textController: c,
//                 onChanged: (v) => onChanged(v.isNotEmpty ? v : null),
//               ),
//             );
//             break;
//           }
//
//         case FieldType.number:
//           {
//             final text = (value?.toString() ?? '');
//             final c = _ctrlFor(fullKey, text);
//             widgets.add(
//               InputTextField(
//                 label: field.label ?? '',
//                 keyboardType:
//                     const TextInputType.numberWithOptions(decimal: true),
//                 textController: c,
//                 onChanged: (v) {
//                   final parsed = num.tryParse(v);
//                   onChanged(parsed ?? v);
//                 },
//               ),
//             );
//             break;
//           }
//
//         case FieldType.select:
//           {
//             final needsImage = (field.requiredFields ?? [])
//                 .any((rf) => rf.type == FieldType.image);
//             final options = field.options ?? [];
//             final bool imageOnly = needsImage && options.length <= 1;
//
//             if (imageOnly) {
//               // image-only: chỉ uploader ảnh, trả URL trực tiếp
//               String? url;
//               if (value is String && value.trim().isNotEmpty) {
//                 url = value;
//               } else if (value is Map) {
//                 final k = field.label ?? '';
//                 url = (value['${k}_image'] as String?) ??
//                     (value['image'] as String?);
//               }
//               widgets.add(ImageUploadField(
//                 label: field.label ?? 'Ảnh',
//                 templateId: widget.templateId,
//                 onChanged: (link) {
//                   // Lấy danh sách ảnh hiện tại (nếu có)
//                   List<String> images = List<String>.from(widget.value ?? []);
//                   // Thêm ảnh mới vào danh sách
//                   if (link != null && link.isNotEmpty) {
//                     images.add(link); // Thêm ảnh vào cuối danh sách
//                   }
//                   // Cập nhật lại value với danh sách ảnh
//                   widget.onChanged(images);
//                 },
//               ));
//               break;
//             }
//
//             final String? selected =
//                 (value is String && value.trim().isNotEmpty) ? value : null;
//
//             widgets.add(
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomRadioGroup(
//                     label:
//                         field.label ?? widget.indicator.name ?? 'Chọn tùy chọn',
//                     value: selected,
//                     options: options,
//                     onChanged: (opt) {
//                       onChanged(
//                           (opt != null && opt.toString().trim().isNotEmpty)
//                               ? opt
//                               : null);
//                     },
//                   ),
//                   if (needsImage && (selected != null && selected.isNotEmpty))
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: ImageUploadField(
//                         label: "Ảnh cho $selected",
//                         templateId: widget.templateId,
//                         onChanged: (link) {
//                           // Giữ lại các ảnh đã tải lên và thêm ảnh mới
//                           List<String> images =
//                               List<String>.from(widget.value ?? []);
//                           if (link != null && link.isNotEmpty) {
//                             images.add(link); // Thêm ảnh vào danh sách
//                           }
//                           onChanged(images); // Cập nhật lại danh sách ảnh
//                         },
//                       ),
//                     ),
//                 ],
//               ),
//             );
//             break;
//           }
//
//         case FieldType.multiSelection:
//           {
//             final needsImage = (field.requiredFields ?? [])
//                 .any((rf) => rf.type == FieldType.image);
//
//             if (needsImage) {
//               // Map<option, url|null>
//               final Map<String, String?> current = (value is Map)
//                   ? Map<String, String?>.from(
//                       (value as Map).map((k, v) => MapEntry(
//                             k.toString(),
//                             v == null ? null : v.toString(),
//                           )))
//                   : <String, String?>{};
//               final selected = current.keys.toList();
//
//               widgets.add(
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomCheckboxGroup(
//                       label: field.label ??
//                           widget.indicator.name ??
//                           'Chọn tùy chọn',
//                       selectedValues: selected,
//                       options: field.options ?? [],
//                       onChanged: (vals) {
//                         final next = <String, String?>{};
//                         for (final opt in vals) {
//                           next[opt] = current[opt]; // giữ url cũ
//                         }
//                         onChanged(next); // trả map phẳng
//                       },
//                       isRequired: false,
//                       enabled: true,
//                     ),
//                     ...selected.map((opt) => Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: ImageUploadField(
//                             label: "Ảnh cho $opt",
//                             templateId: widget.templateId,
//                             //initialImageUrl: current[opt],
//                             selectedOption: opt,
//                             onChanged: (link) {
//                               final next = Map<String, String?>.from(current);
//                               next[opt] = (link != null && link.isNotEmpty)
//                                   ? link
//                                   : null;
//                               onChanged(next);
//                             },
//                           ),
//                         )),
//                   ],
//                 ),
//               );
//             } else {
//               // List<String>
//               final List<String> current = (value is List)
//                   ? List<String>.from(value.map((e) => e.toString().trim()))
//                   : <String>[];
//               widgets.add(
//                 CustomCheckboxGroup(
//                   label:
//                       field.label ?? widget.indicator.name ?? 'Chọn tùy chọn',
//                   selectedValues: current,
//                   options: field.options ?? [],
//                   onChanged: (vals) => onChanged(vals),
//                   isRequired: false,
//                   enabled: true,
//                 ),
//               );
//             }
//             break;
//           }
//         case FieldType.fullDate:
//           final dateValue = value is String && value.isNotEmpty
//               ? DateTime.tryParse(value)
//               : null;
//
//           widgets.add(
//             InkWell(
//               onTap: () async {
//                 final picked = await showDatePicker(
//                   // locale: const Locale('vi'),
//                   context: context,
//                   initialDate: dateValue ?? DateTime.now(),
//                   firstDate: DateTime(1970),
//                   lastDate: DateTime(2100),
//                 );
//                 if (picked != null) {
//                   onChanged(picked.toIso8601String());
//                 }
//               },
//               child: IgnorePointer(
//                 child: InputTextField(
//                   label: field.label ?? 'Chọn ngày',
//                   enabled: false,
//                   prefixIcon: const Icon(Icons.calendar_today),
//                   textController: TextEditingController(
//                     text: dateValue != null
//                         ? "${dateValue.day.toString().padLeft(2, '0')}/"
//                             "${dateValue.month.toString().padLeft(2, '0')}/"
//                             "${dateValue.year}"
//                         : '',
//                   ),
//                 ),
//               ),
//             ),
//           );
//           break;
//         case FieldType.fullYearRange:
//           {
//             final dateValue = value is String && value.isNotEmpty
//                 ? DateTime.tryParse(value)
//                 : null;
//             widgets.add(
//               InkWell(
//                 onTap: () async {
//                   final picked = await showDatePicker(
//                     //locale: const Locale('vi'),
//                     context: context, // FIX: không dùng getContext
//                     initialDate: dateValue ?? DateTime.now(),
//                     firstDate: DateTime(1970),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null) {
//                     onChanged(picked.toIso8601String());
//                   }
//                 },
//                 child: IgnorePointer(
//                   child: InputTextField(
//                     label: field.label ?? '',
//                     enabled: false,
//                     prefixIcon: const Icon(Icons.calendar_today),
//                     textController: TextEditingController(
//                       text: dateValue != null
//                           ? "${dateValue.day.toString().padLeft(2, '0')}/"
//                               "${dateValue.month.toString().padLeft(2, '0')}/"
//                               "${dateValue.year}"
//                           : '',
//                     ),
//                   ),
//                 ),
//               ),
//             );
//             break;
//           }
//         case FieldType.range:
//           {
//             final current = _parseDateRangeValue(value);
//             final display = (current == null)
//                 ? ''
//                 : '${_fmtDate(current.start)}  →  ${_fmtDate(current.end)}';
//
//             final c = _ctrlFor(fullKey, display);
//
//             widgets.add(
//               InkWell(
//                 onTap: () async {
//                   final picked = await showDateRangePicker(
//                     context: context,
//                     firstDate: DateTime(1970),
//                     lastDate: DateTime(2100),
//                     initialDateRange: current,
//                   );
//
//                   if (picked == null) {
//                     onChanged(null);
//                     return;
//                   }
//
//                   onChanged({
//                     "start": picked.start.toIso8601String(),
//                     "end": picked.end.toIso8601String(),
//                   });
//                 },
//                 child: IgnorePointer(
//                   child: InputTextField(
//                     label: field.label ?? 'Chọn khoảng thời gian',
//                     enabled: false,
//                     prefixIcon: const Icon(Icons.date_range),
//                     textController: c,
//                     onChanged: (_) {},
//                   ),
//                 ),
//               ),
//             );
//             break;
//           }
//
//         case FieldType.prescription:
//           {
//             final text = (value ?? '').toString();
//             final c = _ctrlFor(fullKey, text);
//             widgets.add(
//               InputTextField(
//                 label: field.label ?? 'Kê đơn thuốc',
//                 prefixIcon: const Icon(Icons.medical_services),
//                 textController: c,
//                 onChanged: (v) => onChanged(v.isNotEmpty ? v : null),
//               ),
//             );
//             break;
//           }
//
//         case FieldType.custom:
//           if (field.groups != null && field.groups!.isNotEmpty) {
//             for (final g in field.groups!) {
//               widgets.add(
//                 buildCustomField(g, value, onChanged,
//                     parentLabel: fullKey.isEmpty ? parentLabel : fullKey),
//               );
//             }
//           } else {
//             widgets.add(Text(field.label ?? 'Custom Field',
//                 style: const TextStyle(fontWeight: FontWeight.bold)));
//           }
//           break;
//
//         default:
//           widgets.add(Text("⚠️ Chưa hỗ trợ type ${field.type}"));
//       }
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: widgets,
//       );
//     }
//
//     if (fieldOrGroup is Map<String, dynamic>) {
//       return buildCustomField(
//         CustomField.fromJson(fieldOrGroup),
//         value,
//         onChanged,
//         parentLabel: parentLabel,
//       );
//     }
//
//     return const SizedBox.shrink();
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../constant/color.dart';
import '../../../models/vital_indicator_model.dart';
import '../../../utils/enum/field_type_enum.dart';
import '../../../widget/text_field/input_text_field.dart';
import '../../widgets/custom_checkbox_group.dart';
import '../../widgets/custom_radio_group.dart';
import '../../widgets/image_upload_field.dart';

class IndicatorField extends StatefulWidget {
  final VitalIndicator indicator;
  final dynamic value;
  final Function(dynamic) onChanged;
  final int templateId;
  const IndicatorField({
    super.key,
    required this.indicator,
    required this.value,
    required this.onChanged,
    required this.templateId,
  });
  @override
  State<IndicatorField> createState() => _IndicatorFieldState();
}

class _IndicatorFieldState extends State<IndicatorField> {
  // Controllers bền theo vòng đời để tránh nhảy con trỏ
  late final TextEditingController _textCtrl = TextEditingController();
  late final TextEditingController _numCtrl = TextEditingController();
  // Controllers cho custom fields (key = fullKey)
  final Map<String, TextEditingController> _customCtrls = {};
  // Patch key để child SELECT (custom) gửi ảnh: parent ghi "<key>_image"
  static const String _kImagePatchKey = '__field_image__patch';
  @override
  void initState() {
    super.initState();
    if (widget.indicator.valueType == 'text') {
      _textCtrl.text = (widget.value ?? '').toString();
    } else if (widget.indicator.valueType == 'number') {
      _numCtrl.text = widget.value?.toString() ?? '';
    }
  }

  @override
  void didUpdateWidget(covariant IndicatorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indicator.valueType == 'text') {
      final newText = (widget.value ?? '').toString();
      if (_textCtrl.text != newText) _textCtrl.text = newText;
    } else if (widget.indicator.valueType == 'number') {
      final newText = widget.value?.toString() ?? '';
      if (_numCtrl.text != newText) _numCtrl.text = newText;
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _numCtrl.dispose();
    for (final c in _customCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ====== Helpers ======
  bool _isValueNotEmpty(dynamic val) {
    if (val == null) return false;
    if (val is String) return val.trim().isNotEmpty;
    if (val is num) return true;
    if (val is List) return val.isNotEmpty;
    if (val is Map) return val.isNotEmpty;
    return true;
  }

  TextEditingController _ctrlFor(String key, String initial) {
    final c = _customCtrls[key];
    if (c == null) {
      final nc = TextEditingController(text: initial);
      _customCtrls[key] = nc;
      return nc;
    }
    if (c.text != initial) c.text = initial;
    return c;
  }

  bool _hasHtml(String s) {
    // Tạm thời nhận diện rất đơn giản: có thẻ <img>, <br>, <p>, ...
    return s.contains('<img') || s.contains('<br') || s.contains('<p');
  }

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  DateTimeRange? _parseDateRangeValue(dynamic value) {
    if (value == null) return null;
    // shape recommended: {"start": "...iso...", "end": "...iso..."}
    if (value is Map) {
      final s = value['start']?.toString();
      final e = value['end']?.toString();
      final sd = s == null ? null : DateTime.tryParse(s);
      final ed = e == null ? null : DateTime.tryParse(e);
      if (sd != null && ed != null) return DateTimeRange(start: sd, end: ed);
    }
    // fallback: List [startIso, endIso]
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
    // Công thức: số ngày giữa 2 mốc / 7
    return (days / 7).ceil();
  }

// ✅ 1) THÊM helper label có unit (áp dụng cho Xét nghiệm: WBC (G/L), CRP (mg/L)...)
  String _indicatorLabelWithUnit() {
    final name = widget.indicator.name;
    final unit = widget.indicator.unit?.toString().trim();
    final minValue = widget.indicator.minValue ?? '';
    final maxValue = widget.indicator.maxValue ?? '';
    // Tránh phá HTML label
    if (_hasHtml(name)) return name;
    // Nếu có unit, hiển thị với đơn vị
    if (unit != null && unit.isNotEmpty) {
      return '$name ($unit)${_getRangeText(minValue, maxValue)}';
    }
    // Nếu không có unit, chỉ hiển thị tên
    return '$name${_getRangeText(minValue, maxValue)}';
  }

// Phương thức giúp định dạng thêm min/max vào nhãn
  String _getRangeText(String minValue, String maxValue) {
    if (minValue.isNotEmpty && maxValue.isNotEmpty) {
      return ' (Giới hạn: $minValue - $maxValue)';
    } else if (minValue.isNotEmpty) {
      return ' (Giới hạn: >= $minValue)';
    } else if (maxValue.isNotEmpty) {
      return ' (Giới hạn: <= $maxValue)';
    }
    return '';
  }

  Widget _buildIndicatorLabel({
    String? textOverride,
    TextStyle? textStyle,
  }) {
    final raw = textOverride ?? widget.indicator.name;
    // Nếu có HTML, dùng Html widget
    if (_hasHtml(raw)) {
      return Html(
        data: raw,
        style: {
          // style thân
          'body': Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize(14),
            fontWeight: FontWeight.w500,
          ),
          // style ảnh
          'img': Style(
            margin: Margins.only(bottom: 8),
            // có thể giới hạn width nếu muốn
            // width: Width(200),
          ),
        },
      );
    }
    // Nếu không có HTML thì hiển thị Text bình thường
    return Text(
      raw,
      style: textStyle ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  // ====== Build ======
  @override
  Widget build(BuildContext context) {
    final indicatorLabel = _indicatorLabelWithUnit();
    switch (widget.indicator.valueType) {
      case "text":
        return InputTextField(
          label: indicatorLabel,
          textController: _textCtrl,
          onChanged: widget.onChanged,
        );
      case "number":
        return InputTextField(
          label: indicatorLabel,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textController: _numCtrl,
          onChanged: (val) => widget.onChanged(num.tryParse(val) ?? val),
        );
      case "boolean":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicatorLabel, style: Theme.of(context).textTheme.bodyMedium),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Có"),
                    value: true,
                    groupValue: widget.value as bool?,
                    onChanged: widget.onChanged,
                    activeColor: AppColors.primaryColor,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Không"),
                    value: false,
                    groupValue: widget.value as bool?,
                    onChanged: widget.onChanged,
                    activeColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        );
      case "selection":
        final options = widget.indicator.valueOptions as List<String>? ?? [];
        // Nếu trong name có HTML/ảnh (ví dụ id 192), hiển thị label riêng
        if (_hasHtml(widget.indicator.name)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIndicatorLabel(textOverride: widget.indicator.name),
              const SizedBox(height: 8),
              CustomRadioGroup(
                label: '', // không cần label text nữa
                value: widget.value,
                options: options,
                onChanged: widget.onChanged,
              ),
            ],
          );
        }
        // Các indicator selection bình thường
        return CustomRadioGroup(
          label: indicatorLabel,
          value: widget.value,
          options: options,
          onChanged: widget.onChanged,
        );
      case "multi_selection":
        final options = widget.indicator.valueOptions as List<String>? ?? [];
        // Đặc thù 190 giữ nguyên (tương tự 65 cũ, nhưng chỉ 190 ở đây)
        if (widget.indicator.id == 190 || widget.indicator.id == 65) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          final radioKey = "${widget.indicator.name}_radio";
          final radioValue =
              allValues[radioKey] as String? ?? "Một cách ngẫu nhiên";
          final selected =
              (allValues[widget.indicator.id.toString()] as List<dynamic>?)
                      ?.cast<String>() ??
                  [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRadioGroup(
                label: indicatorLabel,
                value: radioValue,
                options: const [
                  "Một cách ngẫu nhiên",
                  "Khi có các yếu tố kích thích"
                ],
                onChanged: (val) {
                  final m = Map<String, dynamic>.from(allValues);
                  if (val is String && val.isNotEmpty) {
                    m[radioKey] = val;
                  } else {
                    m.remove(radioKey);
                  }
                  if (val == "Một cách ngẫu nhiên") {
                    m.remove(widget.indicator.id.toString());
                  }
                  widget.onChanged(m);
                },
              ),
              if (radioValue == "Khi có các yếu tố kích thích")
                CustomCheckboxGroup(
                  label: "Chọn các yếu tố kích thích",
                  selectedValues: selected,
                  options:
                      options.skip(2).toList(), // Bỏ 2 option đầu cho checkbox
                  onChanged: (newValues) {
                    final m = Map<String, dynamic>.from(allValues);
                    if (newValues.isNotEmpty) {
                      m[widget.indicator.id.toString()] = newValues;
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
        // Mặc định indicator-level (không ảnh)
        final selected = (widget.value as List<String>?) ?? [];
        return CustomCheckboxGroup(
          label: indicatorLabel,
          selectedValues: selected,
          options: options,
          onChanged: widget.onChanged,
          enabled: true,
        );
      case "full_date":
        final dateValue = widget.value is String && widget.value.isNotEmpty
            ? DateTime.tryParse(widget.value)
            : null;
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              // locale: const Locale('vi'),
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
              label: indicatorLabel,
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
      case "fullDate":
        final dateValue = widget.value is String && widget.value.isNotEmpty
            ? DateTime.tryParse(widget.value)
            : null;
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              // locale: const Locale('vi'),
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
              label: indicatorLabel,
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
      case "range":
        final range =
            (widget.value as RangeValues?) ?? const RangeValues(0, 100);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicatorLabel),
            RangeSlider(
              values: range,
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: AppColors.primaryColor,
              onChanged: widget.onChanged,
            ),
          ],
        );
      case "custom":
        final groupJson = widget.indicator.valueOptions['group'];
        List<CustomFieldGroup> groups = [];
        if (groupJson is List) {
          groups = groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
        } else if (groupJson is Map<String, dynamic>) {
          groups = [CustomFieldGroup.fromJson(groupJson)];
        }
        // Đặc thù 175: hiển thị nhóm Thông tin đợt 1/2/3 theo lựa chọn "Số đợt bị tương tự như đợt này"
        if (widget.indicator.id == 175 || widget.indicator.id == 64) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          String? _findFieldLabelContains(CustomFieldGroup g, String needle) {
            for (final f in g.fields) {
              final l = f.label?.trim();
              if (l != null && l.contains(needle)) return l;
            }
            return null;
          }

          bool _isYes(dynamic v, String key) {
            if (v is String) return v.trim() == 'Có';
            if (v is Map) return v[key]?.toString().trim() == 'Có';
            return false;
          }

          int _parseCount(dynamic v) {
            if (v == null) return 0;
            if (v is num) return v.toInt();
            final s = v.toString();
            final m = RegExp(r'(\d+)').firstMatch(s);
            return m == null ? 0 : (int.tryParse(m.group(1)!) ?? 0);
          }

          final rootGroup = groups.isNotEmpty ? groups.first : null;
          // Tìm đúng label theo JSON (tránh hardcode sai câu)
          final prevLabel = rootGroup == null
              ? null
              : _findFieldLabelContains(
                  rootGroup, "Trước đây bạn đã từng bị đợt nào tương tự");
          final countLabel = rootGroup == null
              ? null
              : _findFieldLabelContains(
                  rootGroup, "Số đợt bị tương tự như đợt này");
          final prevYes = (prevLabel != null)
              ? _isYes(allValues[prevLabel], prevLabel)
              : false;
          // Count lấy trực tiếp từ field selection "1 đợt/2 đợt/3 đợt"
          final count = (prevYes && countLabel != null)
              ? _parseCount(allValues[countLabel])
              : 0;
          // Root (Thông tin đợt này) luôn có
          // Nếu count = 1 => show Thông tin đợt 1
          // Nếu count = 2 => show Thông tin đợt 1 + 2
          // Nếu count = 3 => show 1 + 2 + 3
          final List<CustomFieldGroup> filteredGroups = [];
          if (groups.isNotEmpty) filteredGroups.add(groups[0]);
          if (prevYes && count > 0) {
            filteredGroups
                .addAll(groups.skip(1).take(count.clamp(0, groups.length - 1)));
          }
          void _cleanupHiddenEpisodeGroups(Map<String, dynamic> map,
              {required int keepCount}) {
            // Xóa dữ liệu các group "Thông tin đợt i" bị ẩn (i > keepCount)
            // groups[0] = root, groups[1] = đợt 1, groups[2] = đợt 2, groups[3] = đợt 3
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
              Text(widget.indicator.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Root group: chứa "Trước đây..." và "Số đợt..." (field "Số đợt" sẽ được ẩn nếu chọn "Không" ở phần 2 bên dưới)
              if (filteredGroups.isNotEmpty)
                buildCustomField(filteredGroups[0], widget.value,
                    (updatedValue) {
                  final updated = (updatedValue is Map<String, dynamic>)
                      ? Map<String, dynamic>.from(updatedValue)
                      : Map<String, dynamic>.from(allValues);
                  // Nếu đổi từ "Có" -> "Không": xóa count + xóa toàn bộ nhóm đợt 1/2/3
                  final newPrevYes = (prevLabel != null)
                      ? _isYes(updated[prevLabel], prevLabel)
                      : false;
                  // dọn luôn key dropdown cũ nếu còn tồn tại (do code cũ tạo)
                  updated.remove("${widget.indicator.name}_episode_count");
                  if (!newPrevYes) {
                    if (countLabel != null) updated.remove(countLabel);
                    _cleanupHiddenEpisodeGroups(updated, keepCount: 0);
                  } else {
                    // Nếu có "Có" thì dọn theo count hiện tại (nếu người dùng giảm số đợt)
                    final newCount = (countLabel != null)
                        ? _parseCount(updated[countLabel])
                        : 0;
                    _cleanupHiddenEpisodeGroups(updated,
                        keepCount: newCount.clamp(0, 3));
                  }
                  widget.onChanged(updated);
                }),
              // Render nhóm Thông tin đợt 1/2/3 theo count
              if (prevYes && count > 0)
                ...filteredGroups.skip(1).map(
                    (g) => buildCustomField(g, widget.value, (updatedValue) {
                          final updated = (updatedValue is Map<String, dynamic>)
                              ? Map<String, dynamic>.from(updatedValue)
                              : Map<String, dynamic>.from(allValues);
                          widget.onChanged(updated);
                        })),
            ],
          );
        }
        if (widget.indicator.id == 209 || widget.indicator.id == 204) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          // Với JSON bạn đưa: group[0].fields[0] = selection (Có/Không)
          // group[0].fields[1] = text "Số lần bị khó thở"
          final root = groups.isNotEmpty ? groups.first : null;
          // key lưu selection và text được build theo logic của buildCustomField:
          // fieldKey = (groupLabel.isNotEmpty ? "$groupLabel.$fieldLabel" : fieldLabel)
          final groupLabel = (root?.label ?? '').trim();
          // Do field đầu tiên label="" => code buildCustomField đang fallback "field_0"
          final selectKey =
              groupLabel.isNotEmpty ? '$groupLabel.field_0' : 'field_0';
          // Field thứ 2 label="Số lần bị khó thở"
          const timesLabel = 'Số lần bị khó thở';
          final timesKey =
              groupLabel.isNotEmpty ? '$groupLabel.$timesLabel' : timesLabel;
          final selected = allValues[selectKey]?.toString().trim();
          final isYes = selected == 'Có';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // label câu hỏi (indicator name)
              Text(
                widget.indicator.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Selection Có/Không
              CustomRadioGroup(
                label: '',
                value: selected,
                options: const ['Có', 'Không'],
                onChanged: (v) {
                  final m = Map<String, dynamic>.from(allValues);
                  if (v == null || v.toString().trim().isEmpty) {
                    m.remove(selectKey);
                  } else {
                    m[selectKey] = v.toString();
                  }
                  // Nếu chọn "Không" => xóa luôn ô số lần
                  if (v.toString().trim() != 'Có') {
                    m.remove(timesKey);
                  }
                  widget.onChanged(m);
                },
              ),
              // Chỉ hiện ô nhập khi chọn Có
              if (isYes)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InputTextField(
                    label: timesLabel,
                    keyboardType: TextInputType.number,
                    onChanged: (txt) {
                      final m = Map<String, dynamic>.from(allValues);
                      final t = txt.trim();
                      if (t.isEmpty) {
                        m.remove(timesKey);
                      } else {
                        m[timesKey] = t;
                      }
                      widget.onChanged(m);
                    },
                  ),
                ),
            ],
          );
        }
        // Xử lý cho id 196: Yếu tố làm nặng bệnh - hiển thị chi tiết nếu chọn "Thức ăn" hoặc "Chống viêm, giảm đau (Paracetalmon,...)"
        if (widget.indicator.id == 196 || widget.indicator.id == 66) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          final selected =
              (allValues[widget.indicator.id.toString()] as List<String>?) ??
                  [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(indicatorLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomCheckboxGroup(
                label: '',
                selectedValues: selected,
                options: [
                  "Stress",
                  "Thức ăn",
                  "Chống viêm, giảm đau (Paracetalmon,...)"
                ],
                onChanged: (newValues) {
                  final m = Map<String, dynamic>.from(allValues);
                  m[widget.indicator.id.toString()] = newValues;
                  // Cleanup chi tiết nếu không chọn
                  if (!newValues.contains('Thức ăn')) {
                    m.remove('Chi tiết thức ăn');
                  }
                  if (!newValues
                      .contains('Chống viêm, giảm đau (Paracetalmon,...)')) {
                    m.remove('Chi tiết thuốc');
                  }
                  widget.onChanged(m);
                },
                enabled: true,
              ),
              if (selected.contains('Thức ăn'))
                InputTextField(
                  label: 'Chi tiết thức ăn',
                  onChanged: (v) {
                    final m = Map<String, dynamic>.from(allValues);
                    m['Chi tiết thức ăn'] = v;
                    widget.onChanged(m);
                  },
                ),
              if (selected.contains('Chống viêm, giảm đau (Paracetalmon,...)'))
                InputTextField(
                  label: 'Chi tiết thuốc',
                  onChanged: (v) {
                    final m = Map<String, dynamic>.from(allValues);
                    m['Chi tiết thuốc'] = v;
                    widget.onChanged(m);
                  },
                ),
            ],
          );
        }
        // Xử lý cho id 182: Hình dạng - hiển thị mô tả nếu chọn "Hình dạng khác"
        if (widget.indicator.id == 182 || widget.indicator.id == 69) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          final selected =
              (allValues[widget.indicator.id.toString()] as List<String>?) ??
                  [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(indicatorLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomCheckboxGroup(
                label: 'Chọn hình dạng bạn gặp phải',
                selectedValues: selected,
                options: ['Tròn/Oval', 'Dài', 'Hình dạng khác'],
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
                  onChanged: (v) {
                    final m = Map<String, dynamic>.from(allValues);
                    m['Mô tả hình dạng khác'] = v;
                    widget.onChanged(m);
                  },
                ),
            ],
          );
        }
        // Xử lý cho id 185: Thời gian tồn tại - hiển thị nhập nếu chọn "Khác (theo giờ)"
        if (widget.indicator.id == 185 || widget.indicator.id == 71) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          final sel1 = allValues['11.1 Khi dùng thuốc'] as String?;
          final sel2 = allValues['11.2 Khi không dùng thuốc'] as String?;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(indicatorLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomRadioGroup(
                label: '11.1 Khi dùng thuốc',
                value: sel1,
                options: [
                  '< 1h',
                  '1-6h',
                  '6h-12h',
                  '12-24h',
                  'Không biết',
                  'Khác (theo giờ)'
                ],
                onChanged: (v) {
                  final m = Map<String, dynamic>.from(allValues);
                  m['11.1 Khi dùng thuốc'] = v;
                  if (v != 'Khác (theo giờ)') {
                    m.remove('Nhập khoảng thời gian (dùng thuốc)');
                  }
                  widget.onChanged(m);
                },
              ),
              if (sel1 == 'Khác (theo giờ)')
                InputTextField(
                  label: 'Nhập khoảng thời gian',
                  onChanged: (v) {
                    final m = Map<String, dynamic>.from(allValues);
                    m['Nhập khoảng thời gian (dùng thuốc)'] = v;
                    widget.onChanged(m);
                  },
                ),
              CustomRadioGroup(
                label: '11.2 Khi không dùng thuốc',
                value: sel2,
                options: [
                  '< 1h',
                  '1-6h',
                  '6h-12h',
                  '12-24h',
                  'Không biết',
                  'Khác (theo giờ)'
                ],
                onChanged: (v) {
                  final m = Map<String, dynamic>.from(allValues);
                  m['11.2 Khi không dùng thuốc'] = v;
                  if (v != 'Khác (theo giờ)') {
                    m.remove('Nhập khoảng thời gian (không dùng thuốc)');
                  }
                  widget.onChanged(m);
                },
              ),
              if (sel2 == 'Khác (theo giờ)')
                InputTextField(
                  label: 'Nhập khoảng thời gian',
                  onChanged: (v) {
                    final m = Map<String, dynamic>.from(allValues);
                    m['Nhập khoảng thời gian (không dùng thuốc)'] = v;
                    widget.onChanged(m);
                  },
                ),
            ],
          );
        }
        if (widget.indicator.id == 81 || widget.indicator.id == 41) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          final sel1 = allValues['4.1 Khi dùng thuốc'] as String?;
          final sel2 = allValues['4.2 Khi không dùng thuốc'] as String?;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(indicatorLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomRadioGroup(
                label: '4.1 Khi dùng thuốc',
                value: sel1,
                options: [
                  '< 1h',
                  '1-6h',
                  '6h-12h',
                  '12-24h',
                  'Không biết',
                  'Khác (theo giờ)'
                ],
                onChanged: (v) {
                  final m = Map<String, dynamic>.from(allValues);
                  m['4.1 Khi dùng thuốc'] = v;
                  if (v != 'Khác (theo giờ)') {
                    m.remove('Nhập khoảng thời gian (dùng thuốc)');
                  }
                  widget.onChanged(m);
                },
              ),
              if (sel1 == 'Khác (theo giờ)')
                InputTextField(
                  label: 'Nhập khoảng thời gian',
                  onChanged: (v) {
                    final m = Map<String, dynamic>.from(allValues);
                    m['Nhập khoảng thời gian (dùng thuốc)'] = v;
                    widget.onChanged(m);
                  },
                ),
              CustomRadioGroup(
                label: '4.2 Khi không dùng thuốc',
                value: sel2,
                options: [
                  '< 1h',
                  '1-6h',
                  '6h-12h',
                  '12-24h',
                  'Không biết',
                  'Khác (theo giờ)'
                ],
                onChanged: (v) {
                  final m = Map<String, dynamic>.from(allValues);
                  m['4.2 Khi không dùng thuốc'] = v;
                  if (v != 'Khác (theo giờ)') {
                    m.remove('Nhập khoảng thời gian (không dùng thuốc)');
                  }
                  widget.onChanged(m);
                },
              ),
              if (sel2 == 'Khác (theo giờ)')
                InputTextField(
                  label: 'Nhập khoảng thời gian',
                  onChanged: (v) {
                    final m = Map<String, dynamic>.from(allValues);
                    m['Nhập khoảng thời gian (không dùng thuốc)'] = v;
                    widget.onChanged(m);
                  },
                ),
            ],
          );
        }
        if (widget.indicator.id == 89 || widget.indicator.id == 90) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          // Hàm tiện ích cập nhật map
          void updateValues(String label, dynamic newValue) {
            final m = Map<String, dynamic>.from(allValues);
            m[label] = newValue;
            widget.onChanged(m);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // 1. Tiền sử mắc bệnh lý cơ địa
              CustomRadioGroup(
                label:
                    'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa',
                value: (allValues[
                            'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa']
                        as String?) ??
                    '',
                options: ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) {
                  updateValues(
                      'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa',
                      newValue);
                  // Nếu không còn 'Có' thì xóa ghi chú
                  if (newValue != 'Có') {
                    allValues.remove(
                        'ghi_chu_Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa');
                    widget.onChanged(allValues);
                  }
                },
                enabled: true,
              ),
              if ((allValues[
                          'Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa']
                      as String?) ==
                  'Có')
                InputTextField(
                  label: 'Ghi rõ tên',
                  onChanged: (v) => updateValues(
                      'ghi_chu_Tiền sử ${widget.indicator.id == 89 ? 'bản thân' : 'gia đình'} mắc bệnh lý cơ địa',
                      v),
                ),
              // 2. Tiền sử bệnh lý tuyến giáp
              CustomRadioGroup(
                label: 'Tiền sử bệnh lý tuyến giáp',
                value:
                    (allValues['Tiền sử bệnh lý tuyến giáp'] as String?) ?? '',
                options: ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) {
                  updateValues('Tiền sử bệnh lý tuyến giáp', newValue);
                  if (newValue != 'Có') {
                    allValues.remove('ghi_chu_Tiền sử bệnh lý tuyến giáp');
                    widget.onChanged(allValues);
                  }
                },
                enabled: true,
              ),
              if ((allValues['Tiền sử bệnh lý tuyến giáp'] as String?) == 'Có')
                InputTextField(
                  label: 'Ghi rõ tên tuyến giáp',
                  onChanged: (v) =>
                      updateValues('ghi_chu_Tiền sử bệnh lý tuyến giáp', v),
                ),
              // 3. Tiền sử bệnh tự miễn
              CustomRadioGroup(
                label: 'Tiền sử bệnh tự miễn',
                value: (allValues['Tiền sử bệnh tự miễn'] as String?) ?? '',
                options: ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) {
                  updateValues('Tiền sử bệnh tự miễn', newValue);
                  if (newValue != 'Có') {
                    allValues.remove('ghi_chu_Tiền sử bệnh tự miễn');
                    widget.onChanged(allValues);
                  }
                },
                enabled: true,
              ),
              if ((allValues['Tiền sử bệnh tự miễn'] as String?) == 'Có')
                InputTextField(
                  label: 'Ghi rõ tên bệnh tự miễn',
                  onChanged: (v) =>
                      updateValues('ghi_chu_Tiền sử bệnh tự miễn', v),
                ),
              // 4. Tiền sử bệnh lý khác
              CustomRadioGroup(
                label: 'Tiền sử bệnh lý khác',
                value: (allValues['Tiền sử bệnh lý khác'] as String?) ?? '',
                options: ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) {
                  updateValues('Tiền sử bệnh lý khác', newValue);
                  if (newValue != 'Có') {
                    allValues.remove('ghi_chu_Tiền sử bệnh lý khác');
                    widget.onChanged(allValues);
                  }
                },
                enabled: true,
              ),
              if ((allValues['Tiền sử bệnh lý khác'] as String?) == 'Có')
                InputTextField(
                  label: 'Ghi rõ tên bệnh lý khác',
                  onChanged: (v) =>
                      updateValues('ghi_chu_Tiền sử bệnh lý khác', v),
                ),
              // 5. Tiền sử dị ứng
              CustomRadioGroup(
                label: 'Tiền sử dị ứng thuốc, thức ăn khác',
                value: (allValues['Tiền sử dị ứng thuốc, thức ăn khác']
                        as String?) ??
                    '',
                options: ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) {
                  updateValues('Tiền sử dị ứng thuốc, thức ăn khác', newValue);
                  if (newValue != 'Có') {
                    allValues
                        .remove('ghi_chu_Tiền sử dị ứng thuốc, thức ăn khác');
                    widget.onChanged(allValues);
                  }
                },
                enabled: true,
              ),
              if ((allValues['Tiền sử dị ứng thuốc, thức ăn khác']
                      as String?) ==
                  'Có')
                InputTextField(
                  label: 'Ghi rõ tên dị ứng',
                  onChanged: (v) => updateValues(
                      'ghi_chu_Tiền sử dị ứng thuốc, thức ăn khác', v),
                ),
              // 6. Tiền sử phản vệ
              CustomRadioGroup(
                label: 'Tiền sử phản vệ',
                value: (allValues['Tiền sử phản vệ'] as String?) ?? '',
                options: ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) {
                  updateValues('Tiền sử phản vệ', newValue);
                  if (newValue != 'Có') {
                    allValues.remove('ghi_chu_Tiền sử phản vệ');
                    widget.onChanged(allValues);
                  }
                },
                enabled: true,
              ),
              if ((allValues['Tiền sử phản vệ'] as String?) == 'Có')
                InputTextField(
                  label: 'Ghi rõ tên phản vệ',
                  onChanged: (v) => updateValues('ghi_chu_Tiền sử phản vệ', v),
                ),
            ],
          );
        }
        // Xử lý cho id 180: Kích thước - nhóm selection
        if (widget.indicator.id == 180 || widget.indicator.id == 67) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(indicatorLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomRadioGroup(
                label: '7.1 Khi dùng thuốc',
                value: allValues['7.1 Khi dùng thuốc'],
                options: ['< 3 mm', '3-10 mm', '10-50 mm', '> 50 mm'],
                onChanged: (v) {
                  final m = Map<String, dynamic>.from(allValues);
                  m['7.1 Khi dùng thuốc'] = v;
                  widget.onChanged(m);
                },
              ),
              CustomRadioGroup(
                label: '7.2 Khi không dùng thuốc',
                value: allValues['7.2 Khi không dùng thuốc'],
                options: ['< 3 mm', '3-10 mm', '10-50 mm', '> 50 mm'],
                onChanged: (v) {
                  final m = Map<String, dynamic>.from(allValues);
                  m['7.2 Khi không dùng thuốc'] = v;
                  widget.onChanged(m);
                },
              ),
            ],
          );
        }
        if (widget.indicator.id == 217) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};

          // Hàm tiện ích cập nhật map và gọi onChanged
          void updateValues(String key, dynamic newValue) {
            final m = allValues;
            if (newValue == null ||
                (newValue is String && newValue.trim().isEmpty)) {
              m.remove(key);
            } else {
              m[key] = newValue;
            }
            widget.onChanged(m);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề chính (indicator name)
              Text(
                widget.indicator.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 1. Tiền sử dị ứng
              CustomRadioGroup(
                label: 'Tiền sử dị ứng',
                value: allValues['Tiền sử dị ứng'] as String?,
                options: const ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) {
                  updateValues('Tiền sử dị ứng', newValue);

                  // Nếu không chọn 'Có' thì xóa chi tiết
                  if (newValue != 'Có') {
                    updateValues('Chi tiết tiền sử dị ứng', null);
                  }
                },
              ),
              if ((allValues['Tiền sử dị ứng'] as String?) == 'Có')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InputTextField(
                    label: 'Chi tiết tiền sử dị ứng',
                    onChanged: (v) =>
                        updateValues('Chi tiết tiền sử dị ứng', v),
                  ),
                ),

              const SizedBox(height: 16),

              // 2. Thuốc
              CustomRadioGroup(
                label: 'Thuốc',
                value: allValues['Thuốc'] as String?,
                options: const ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) {
                  // print(newValue);
                  updateValues('Thuốc', newValue);
                  if (newValue != 'Có') {
                    updateValues('Chi tiết thuốc', null);
                  }
                },
              ),
              if ((allValues['Thuốc'] as String?) == 'Có')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InputTextField(
                    label: 'Chi tiết thuốc',
                    onChanged: (v) => updateValues('Chi tiết thuốc', v),
                  ),
                ),

              const SizedBox(height: 16),

              // 3. Mày đay
              CustomRadioGroup(
                label: 'Mày đay',
                value: allValues['Mày đay'] as String?,
                options: const ['Có', 'Không', 'Không biết'],
                onChanged: (newValue) => updateValues('Mày đay', newValue),
              ),

              const SizedBox(height: 16),

              // 4. Yếu tố khác
              InputTextField(
                label: 'Yếu tố khác',
                onChanged: (v) => updateValues('Yếu tố khác', v),
              ),
            ],
          );
        }
        // Mặc định cho các custom khác (như 179 với multi + image)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicatorLabel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: buildCustomField(groups, widget.value, widget.onChanged),
            ),
          ],
        );
      default:
        return Text("⚠️ Chưa hỗ trợ loại: ${widget.indicator.valueType}");
    }
  }

  // --------------------------- CUSTOM BUILDER ---------------------------
  Widget buildCustomField(
    dynamic fieldOrGroup,
    dynamic value,
    Function(dynamic) onChanged, {
    String parentLabel = '',
  }) {
    if (fieldOrGroup is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fieldOrGroup
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildCustomField(e, value, onChanged,
                      parentLabel: parentLabel),
                ))
            .toList(),
      );
    }
    if (fieldOrGroup is CustomFieldGroup) {
      final group = fieldOrGroup;
      final List<Widget> children = [];
      final allValues = (value as Map<String, dynamic>?) ?? {};
      final groupLabel = group.label?.trim() ?? '';
      if (groupLabel.isNotEmpty) {
        children.add(Text(groupLabel,
            style: const TextStyle(fontWeight: FontWeight.bold)));
        children.add(SizedBox(
          height: 4,
        ));
      }
      for (int idx = 0; idx < group.fields.length; idx++) {
        final f = group.fields[idx];
        final fieldLabel = f.label?.trim() ?? 'field_$idx';
        final fieldKey =
            groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;
        bool shouldShowField = true;
        // Điều kiện cho root group: “Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)”
        // và cho episode groups: “Có điều trị hay không?”
        if ((fieldLabel == "Tên thuốc" ||
                fieldLabel == "Liều thuốc (ghi thời gian nếu nhớ)" ||
                fieldLabel == "Tình trạng tổn thương khi đang uống thuốc") &&
            (widget.indicator.id == 175 || widget.indicator.id == 64)) {
          String treatmentKey;
          if (groupLabel.isEmpty) {
            // Root group
            treatmentKey = groupLabel.isNotEmpty
                ? '$groupLabel.Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)'
                : 'Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)';
          } else {
            // Episode groups
            treatmentKey = groupLabel.isNotEmpty
                ? '$groupLabel.Có điều trị hay không?'
                : 'Có điều trị hay không?';
          }
          final tv = allValues[treatmentKey];
          final isYes = (tv is Map && tv[treatmentKey] == 'Có') ||
              (tv is String && tv.trim() == 'Có');
          shouldShowField = isYes;
        }
        if (fieldLabel == "Triệu chứng Giảm xuống/ Nặng lên là gì?") {
          final statusKey = groupLabel.isNotEmpty
              ? '$groupLabel.Tình trạng tổn thương khi đang uống thuốc'
              : 'Tình trạng tổn thương khi đang uống thuốc';
          final sv = allValues[statusKey];
          final ok = (sv is Map &&
                  (sv['Tình trạng tổn thương khi đang uống thuốc'] ==
                          'Giảm xuống' ||
                      sv['Tình trạng tổn thương khi đang uống thuốc'] ==
                          'Nặng lên')) ||
              (sv is String &&
                  (sv.trim() == 'Giảm xuống' || sv.trim() == 'Nặng lên'));
          shouldShowField = ok;
        }
// Chỉ hiện "Số đợt bị tương tự như đợt này" khi câu "Trước đây bạn đã từng bị đợt nào tương tự như vậy chưa?" = Có
        if (fieldLabel.contains("Số đợt bị tương tự như đợt này")) {
          final prevKey = group.fields
              .map((x) => x.label?.trim() ?? '')
              .firstWhere(
                  (l) => l.contains(
                      "Trước đây bạn đã từng bị đợt nào tương tự như vậy chưa?"),
                  orElse: () => '');
          if (prevKey.isNotEmpty) {
            final pv = allValues[prevKey];
            final isYes = (pv is String && pv.trim() == 'Có') ||
                (pv is Map && pv[prevKey]?.toString().trim() == 'Có');
            shouldShowField = isYes;
          } else {
            shouldShowField = false;
          }
        }
        if (!shouldShowField) continue;
        final fieldValue = allValues[fieldKey];
        children.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildCustomField(
              f,
              fieldValue,
              (updatedValue) {
                final newMap = Map<String, dynamic>.from(allValues);
                final imageKey = "${fieldKey}_image";
                // Nhận patch ảnh từ SELECT có ảnh
                if (updatedValue is Map &&
                    updatedValue.containsKey(_kImagePatchKey)) {
                  final link = updatedValue[_kImagePatchKey];
                  if (_isValueNotEmpty(link)) {
                    newMap[imageKey] = link;
                  } else {
                    newMap.remove(imageKey);
                  }
                } else {
                  // Ghi phẳng giá trị field (String/List/Map/URL)
                  if (_isValueNotEmpty(updatedValue)) {
                    newMap[fieldKey] = updatedValue;
                    // NEW: nếu field hiện tại là range (date range) -> tự tính "Số tuần bị đợt này"
                    if (f.type == FieldType.range) {
                      // tìm field "Số tuần bị đợt này" trong cùng group
                      final weekField = group.fields.firstWhere(
                        (x) => (x.label ?? '').contains("Số tuần bị đợt này"),
                        orElse: () => CustomField(
                            label: null,
                            description: null,
                            type: FieldType.unknown),
                      );
                      final weekLabel = weekField.label?.trim();
                      if (weekLabel != null && weekLabel.isNotEmpty) {
                        final weekKey = groupLabel.isNotEmpty
                            ? '$groupLabel.$weekLabel'
                            : weekLabel;
                        final r = _parseDateRangeValue(newMap[fieldKey]);
                        final weeks = _weeksFromDateRange(r);
                        if (weeks != null) {
                          newMap[weekKey] = weeks; // auto set number
                        } else {
                          newMap.remove(weekKey);
                        }
                      }
                    }
                  } else {
                    newMap.remove(
                        fieldKey); // NEW: nếu field hiện tại là range (date range) -> tự tính "Số tuần bị đợt này"
                    if (f.type == FieldType.range) {
                      // tìm field "Số tuần bị đợt này" trong cùng group
                      final weekField = group.fields.firstWhere(
                        (x) => (x.label ?? '').contains("Số tuần bị đợt này"),
                        orElse: () => CustomField(
                            label: null,
                            description: null,
                            type: FieldType.unknown),
                      );
                      final weekLabel = weekField.label?.trim();
                      if (weekLabel != null && weekLabel.isNotEmpty) {
                        final weekKey = groupLabel.isNotEmpty
                            ? '$groupLabel.$weekLabel'
                            : weekLabel;
                        final r = _parseDateRangeValue(newMap[fieldKey]);
                        final weeks = _weeksFromDateRange(r);
                        if (weeks != null) {
                          newMap[weekKey] = weeks; // auto set number
                        } else {
                          newMap.remove(weekKey);
                        }
                      }
                    }
                  }
                }
                // Cleanup khi đổi điều trị
                if (fieldLabel ==
                        "Đợt bệnh này bạn đã điều trị hay chưa? (1 đợt bệnh liên tục có nghĩa là bị ít nhất 2 ngày/tuần)" ||
                    fieldLabel == "Có điều trị hay không?") {
                  final isYes = updatedValue == "Có" ||
                      (updatedValue is Map && updatedValue[fieldLabel] == 'Có');
                  if (!isYes) {
                    final drugNameKey = groupLabel.isNotEmpty
                        ? '$groupLabel.Tên thuốc'
                        : 'Tên thuốc';
                    final drugDoseKey = groupLabel.isNotEmpty
                        ? '$groupLabel.Liều thuốc (ghi thời gian nếu nhớ)'
                        : 'Liều thuốc (ghi thời gian nếu nhớ)';
                    final statusKey = groupLabel.isNotEmpty
                        ? '$groupLabel.Tình trạng tổn thương khi đang uống thuốc'
                        : 'Tình trạng tổn thương khi đang uống thuốc';
                    final symptomKey = groupLabel.isNotEmpty
                        ? '$groupLabel.Triệu chứng Giảm xuống/ Nặng lên là gì?'
                        : 'Triệu chứng Giảm xuống/ Nặng lên là gì?';
                    newMap.remove(drugNameKey);
                    newMap.remove(drugDoseKey);
                    newMap.remove(statusKey);
                    newMap.remove(symptomKey);
                  }
                }
                if (fieldLabel == "Tình trạng tổn thương khi đang uống thuốc") {
                  final keep = updatedValue == "Giảm xuống" ||
                      updatedValue == "Nặng lên";
                  if (!keep) {
                    final symptomKey = groupLabel.isNotEmpty
                        ? '$groupLabel.Triệu chứng Giảm xuống/ Nặng lên là gì?'
                        : 'Triệu chứng Giảm xuống/ Nặng lên là gì?';
                    newMap.remove(symptomKey);
                  }
                }
                onChanged(newMap);
              },
              parentLabel: groupLabel,
            ),
          ),
        );
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children);
    }
    if (fieldOrGroup is CustomField) {
      final field = fieldOrGroup;
      final List<Widget> widgets = [];
      // Tạo fullKey để lưu controller/phẳng key
      final fullKey = parentLabel.isNotEmpty
          ? '$parentLabel.${field.label ?? ''}'.trim()
          : (field.label ?? '').trim();
      switch (field.type) {
        case FieldType.text:
          {
            final text = (value ?? '').toString();
            final c = _ctrlFor(fullKey, text);
            widgets.add(
              InputTextField(
                label: field.label ?? '',
                textController: c,
                onChanged: (v) => onChanged(v.isNotEmpty ? v : null),
              ),
            );
            break;
          }
        case FieldType.number:
          {
            final text = (value?.toString() ?? '');
            final c = _ctrlFor(fullKey, text);
            widgets.add(
              InputTextField(
                label: field.label ?? '',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textController: c,
                onChanged: (v) {
                  final parsed = num.tryParse(v);
                  onChanged(parsed ?? v);
                },
              ),
            );
            break;
          }
        case FieldType.select:
          {
            final needsImage = (field.requiredFields ?? [])
                .any((rf) => rf.type == FieldType.image);
            final options = field.options ?? [];
            final bool imageOnly = needsImage && options.length <= 1;
            if (imageOnly) {
              // image-only: chỉ uploader ảnh, trả List URL
              List<String> urls = [];
              if (value is List) {
                urls = List<String>.from(value.where((e) => e is String));
              } else if (value is Map) {
                final k = field.label ?? '';
                urls = List<String>.from(
                    (value['${k}_image'] ?? []) ?? (value['image'] ?? []));
              }
              widgets.add(ImageUploadField(
                label: field.label ?? 'Ảnh',
                templateId: widget.templateId,
                initialImageUrls: urls, // Sử dụng prop mới cho list
                onChanged: (newImages) {
                  onChanged(newImages); // Trả list trực tiếp
                },
              ));
              break;
            }
            final String? selected =
                (value is String && value.trim().isNotEmpty) ? value : null;
            widgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRadioGroup(
                    label:
                        field.label ?? widget.indicator.name ?? 'Chọn tùy chọn',
                    value: selected,
                    options: options,
                    onChanged: (opt) {
                      onChanged(
                          (opt != null && opt.toString().trim().isNotEmpty)
                              ? opt
                              : null);
                    },
                  ),
                  if (needsImage && (selected != null && selected.isNotEmpty))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ImageUploadField(
                        label: "Ảnh cho $selected",
                        templateId: widget.templateId,
                        selectedOption: selected,
                        initialImageUrls: List<String>.from(value is List
                            ? value
                            : []), // Giả sử value chứa list ảnh chung
                        onChanged: (newImages) {
                          onChanged(newImages); // Trả list mới
                        },
                      ),
                    ),
                ],
              ),
            );
            break;
          }
        case FieldType.multiSelection:
          {
            final needsImage = (field.requiredFields ?? [])
                .any((rf) => rf.type == FieldType.image);
            if (needsImage) {
              // Để hỗ trợ nhiều ảnh per option, dùng Map<String, List<String>>
              final Map<String, List<String>> current = (value is Map)
                  ? Map<String, List<String>>.from(
                      (value as Map).map((k, v) => MapEntry(
                            k.toString(),
                            v is List
                                ? List<String>.from(v)
                                : (v != null ? [v.toString()] : []),
                          )))
                  : <String, List<String>>{};
              final selected = current.keys.toList();
              widgets.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCheckboxGroup(
                      label: field.label ??
                          widget.indicator.name ??
                          'Chọn tùy chọn',
                      selectedValues: selected,
                      options: field.options ?? [],
                      onChanged: (vals) {
                        final next = <String, List<String>>{};
                        for (final opt in vals) {
                          next[opt] = current[opt] ?? []; // giữ list cũ
                        }
                        onChanged(next); // trả map phẳng với list per opt
                      },
                      isRequired: false,
                      enabled: true,
                    ),
                    ...selected.map((opt) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ImageUploadField(
                            label: "Ảnh cho $opt",
                            templateId: widget.templateId,
                            selectedOption: opt,
                            initialImageUrls: current[opt], // List per opt
                            onChanged: (newImages) {
                              final next =
                                  Map<String, List<String>>.from(current);
                              next[opt] = newImages ?? [];
                              onChanged(next);
                            },
                          ),
                        )),
                  ],
                ),
              );
            } else {
              // List<String>
              final List<String> current = (value is List)
                  ? List<String>.from(value.map((e) => e.toString().trim()))
                  : <String>[];
              widgets.add(
                CustomCheckboxGroup(
                  label:
                      field.label ?? widget.indicator.name ?? 'Chọn tùy chọn',
                  selectedValues: current,
                  options: field.options ?? [],
                  onChanged: (vals) => onChanged(vals),
                  isRequired: false,
                  enabled: true,
                ),
              );
            }
            break;
          }
        case FieldType.fullDate:
          final dateValue = value is String && value.isNotEmpty
              ? DateTime.tryParse(value)
              : null;
          widgets.add(
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  // locale: const Locale('vi'),
                  context: context,
                  initialDate: dateValue ?? DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  onChanged(picked.toIso8601String());
                }
              },
              child: IgnorePointer(
                child: InputTextField(
                  label: field.label ?? 'Chọn ngày',
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
            ),
          );
          break;
        case FieldType.fullYearRange:
          {
            final dateValue = value is String && value.isNotEmpty
                ? DateTime.tryParse(value)
                : null;
            widgets.add(
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    //locale: const Locale('vi'),
                    context: context, // FIX: không dùng getContext
                    initialDate: dateValue ?? DateTime.now(),
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    onChanged(picked.toIso8601String());
                  }
                },
                child: IgnorePointer(
                  child: InputTextField(
                    label: field.label ?? '',
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
              ),
            );
            break;
          }
        case FieldType.range:
          {
            final current = _parseDateRangeValue(value);
            final display = (current == null)
                ? ''
                : '${_fmtDate(current.start)} → ${_fmtDate(current.end)}';
            final c = _ctrlFor(fullKey, display);
            widgets.add(
              InkWell(
                onTap: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2100),
                    initialDateRange: current,
                  );
                  if (picked == null) {
                    onChanged(null);
                    return;
                  }
                  onChanged({
                    "start": picked.start.toIso8601String(),
                    "end": picked.end.toIso8601String(),
                  });
                },
                child: IgnorePointer(
                  child: InputTextField(
                    label: field.label ?? 'Chọn khoảng thời gian',
                    enabled: false,
                    prefixIcon: const Icon(Icons.date_range),
                    textController: c,
                    onChanged: (_) {},
                  ),
                ),
              ),
            );
            break;
          }
        case FieldType.prescription:
          {
            final text = (value ?? '').toString();
            final c = _ctrlFor(fullKey, text);
            widgets.add(
              InputTextField(
                label: field.label ?? 'Kê đơn thuốc',
                prefixIcon: const Icon(Icons.medical_services),
                textController: c,
                onChanged: (v) => onChanged(v.isNotEmpty ? v : null),
              ),
            );
            break;
          }
        case FieldType.custom:
          if (field.groups != null && field.groups!.isNotEmpty) {
            for (final g in field.groups!) {
              widgets.add(
                buildCustomField(g, value, onChanged,
                    parentLabel: fullKey.isEmpty ? parentLabel : fullKey),
              );
            }
          } else {
            widgets.add(Text(field.label ?? 'Custom Field',
                style: const TextStyle(fontWeight: FontWeight.bold)));
          }
          break;
        default:
          widgets.add(Text("⚠️ Chưa hỗ trợ type ${field.type}"));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }
    if (fieldOrGroup is Map<String, dynamic>) {
      return buildCustomField(
        CustomField.fromJson(fieldOrGroup),
        value,
        onChanged,
        parentLabel: parentLabel,
      );
    }
    return const SizedBox.shrink();
  }
}
