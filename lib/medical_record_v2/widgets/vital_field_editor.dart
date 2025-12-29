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
  final FocusNode _dummyFocusNode = FocusNode(debugLabel: 'dummy_focus');
  late TextEditingController _ctrl185_1;
  late TextEditingController _ctrl185_2;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
    final allValues = _asMap(widget.value);
    _ctrl185_1 = TextEditingController(
      text: (allValues['Nhập khoảng thời gian (dùng thuốc)'] ?? '').toString(),
    );
    _ctrl185_2 = TextEditingController(
      text: (allValues['Nhập khoảng thời gian (không dùng thuốc)'] ?? '')
          .toString(),
    );
  }

  @override
  void didUpdateWidget(covariant VitalFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value?.toString() != oldWidget.value?.toString()) {
      _controller.text = widget.value?.toString() ?? '';
    }
    final newMap = _asMap(widget.value);
    final t1 = (newMap['Nhập khoảng thời gian (dùng thuốc)'] ?? '').toString();
    final t2 =
        (newMap['Nhập khoảng thời gian (không dùng thuốc)'] ?? '').toString();

    if (_ctrl185_1.text != t1) _ctrl185_1.text = t1;
    if (_ctrl185_2.text != t2) _ctrl185_2.text = t2;
  }

  @override
  void dispose() {
    _dummyFocusNode.dispose();
    _controller.dispose();
    _ctrl185_1.dispose();
    _ctrl185_2.dispose();
    super.dispose();
  }

  void _releaseKeyboardFocus() {
    // 1) Unfocus ngay lập tức
    FocusManager.instance.primaryFocus?.unfocus();
    // 2) Request dummy focus để Flutter không restore focus về TextField cũ
    FocusScope.of(context).requestFocus(_dummyFocusNode);
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
    final minValue = widget.indicator.minValue ?? '';
    final maxValue = widget.indicator.maxValue ?? '';
    if (u == null || u.isEmpty)
      return "$label ${_getRangeText(minValue, maxValue)}";
    return '$label ($u)${_getRangeText(minValue, maxValue)}';
  }

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

      case 81:
      case 41:
        return _buildSpecial81or41(context);

      case 180:
      case 67:
        return _buildSpecial180or67(context);
      case 209:
      case 204:
        return _buildSpecial209Or204BreathShortness(context);
      case 89:
      case 90:
        return _buildSpecial89or90(context);
      case 217:
        return _buildSpecial217(context);

      default:
        return null;
    }
  }

  // 209,204: Khó thở - chọn "Có" mới hiện ô "Số lần bị khó thở"
  Widget _buildSpecial209Or204BreathShortness(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString()
        .trim();
    final displayLabel = _displayLabel(label, unit);

    // valueOptions: { group: [ { fields: [...] } ] }
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
    final allValues = (widget.value is Map)
        ? Map<String, dynamic>.from(widget.value as Map)
        : <String, dynamic>{};

    // Với JSON bạn gửi: group[0].fields[0] selection label=""
    // group[0].fields[1] text label="Số lần bị khó thở"
    final root = groups.isNotEmpty ? groups.first : null;
    final groupLabel = (root?.label ?? '').trim();

    // label="" => trong IndicatorField bạn có thể đang fallback field_0
    // Ở đây làm chắc chắn: dùng key field_0
    final selectKey = groupLabel.isNotEmpty ? '$groupLabel.field_0' : 'field_0';

    const timesLabel = 'Số lần bị khó thở';
    final timesKey =
        groupLabel.isNotEmpty ? '$groupLabel.$timesLabel' : timesLabel;

    final selected = allValues[selectKey]?.toString().trim();
    final isYes = selected == 'Có';

    final timesText = (allValues[timesKey] ?? '').toString();
    _controller.text = timesText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị câu hỏi
        //Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),

        // Có / Không
        CustomRadioGroup(
          label: '',
          value: selected,
          options: const ['Có', 'Không'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            final vv = v?.toString().trim() ?? '';

            if (vv.isEmpty) {
              m.remove(selectKey);
            } else {
              m[selectKey] = vv;
            }

            // Nếu chọn Không => xoá số lần
            if (vv != 'Có') {
              m.remove(timesKey);
            }

            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),

        // Chỉ hiện ô nhập khi chọn Có
        if (isYes) ...[
          const SizedBox(height: 8),
          InputTextField(
            label: timesLabel,
            keyboardType: TextInputType.number,
            textController: _controller,
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              final t = v.trim();
              if (t.isEmpty) {
                m.remove(timesKey);
              } else {
                m[timesKey] = t;
              }
              widget.onChanged(m);
            },
          ),
        ],
      ],
    );
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
        // Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        // const SizedBox(height: 8),

        // Root group
        CustomFieldEditor(
          indicator: widget.indicator,
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
                    indicator: widget.indicator,
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

  Widget _buildSpecial89or90(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    // Getting the value options (grouping of fields)
    final valueOptions =
        widget.valueOptionsOverride ?? widget.indicator.valueOptions;
    final groupJson = (valueOptions is Map) ? valueOptions['group'] : null;

    List<CustomFieldGroup> groups = [];
    if (groupJson is List) {
      groups = groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
    } else if (groupJson is Map<String, dynamic>) {
      groups = [CustomFieldGroup.fromJson(groupJson)];
    }

    // Map of all the values for easier access
    final allValues = _asMap(widget.value);

    // Define the field keys for "Tiền sử bản thân" or "Tiền sử gia đình" fields
    final groupLabel = groups.isNotEmpty ? groups.first.label ?? '' : '';
    final fieldPrefix =
        widget.indicator.id == 89 ? 'Tiền sử bản thân' : 'Tiền sử gia đình';

    // Initialize _controller values with data from allValues for each specific field
    TextEditingController _controllerBenhLyCoDia = TextEditingController(
      text: allValues['ghi_chu_$fieldPrefix mắc bệnh lý cơ địa']?.toString() ??
          '',
    );

    TextEditingController _controllerBenhLyTuyenGiap = TextEditingController(
      text: allValues['ghi_chu_$fieldPrefix bệnh lý tuyến giáp']?.toString() ??
          '',
    );

    TextEditingController _controllerBenhTuMien = TextEditingController(
      text: allValues['ghi_chu$fieldPrefix bệnh tự miễn']?.toString() ?? '',
    );

    TextEditingController _controllerBenhLyKhac = TextEditingController(
      text: allValues['ghi_chu_$fieldPrefix bệnh lý khác']?.toString() ?? '',
    );

    TextEditingController _controllerDaiUng = TextEditingController(
      text: allValues['ghi_chu$fieldPrefix dị ứng thuốc, thức ăn khác']
              ?.toString() ??
          '',
    );

    TextEditingController _controllerPhanVe = TextEditingController(
      text: allValues['ghi_chu_$fieldPrefix phản vệ']?.toString() ?? '',
    );

    // Form fields for each radio option and their respective text fields
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Displaying the label for the question
        Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Radio buttons for each specific condition (Có / Không / Không biết)
        CustomRadioGroup(
          label: '$fieldPrefix mắc bệnh lý cơ địa',
          value: allValues['$fieldPrefix mắc bệnh lý cơ địa']?.toString(),
          options: const ['Có', 'Không', 'Không biết'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            m['$fieldPrefix mắc bệnh lý cơ địa'] = v;

            if (v != 'Có') {
              m.remove('ghi_chu_$fieldPrefix mắc bệnh lý cơ địa');
            }

            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),
        // Only show the "Ghi rõ tên" text field if "Có" is selected
        if ((allValues['$fieldPrefix mắc bệnh lý cơ địa'] as String?) == 'Có')
          InputTextField(
            label: 'Ghi rõ tên',
            textController: _controllerBenhLyCoDia,
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              m['ghi_chu_$fieldPrefix mắc bệnh lý cơ địa'] = v;
              widget.onChanged(m);
            },
          ),

        // Repeat for each additional field (Tiền sử bệnh lý tuyến giáp, Tiền sử bệnh tự miễn, etc.)
        // Tiền sử bệnh lý tuyến giáp
        CustomRadioGroup(
          label: '$fieldPrefix bệnh lý tuyến giáp',
          value: allValues['$fieldPrefix bệnh lý tuyến giáp']?.toString(),
          options: const ['Có', 'Không', 'Không biết'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            m['$fieldPrefix bệnh lý tuyến giáp'] = v;

            if (v != 'Có') {
              m.remove('ghi_chu_$fieldPrefix bệnh lý tuyến giáp');
            }

            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),
        if ((allValues['$fieldPrefix bệnh lý tuyến giáp'] as String?) == 'Có')
          InputTextField(
            label: 'Ghi rõ tên tuyến giáp',
            textController: _controllerBenhLyTuyenGiap,
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              m['ghi_chu_$fieldPrefix bệnh lý tuyến giáp'] = v;
              widget.onChanged(m);
            },
          ),

        // Tiền sử bệnh tự miễn
        CustomRadioGroup(
          label: '$fieldPrefix bệnh tự miễn',
          value: allValues['$fieldPrefix bệnh tự miễn']?.toString(),
          options: const ['Có', 'Không', 'Không biết'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            m['$fieldPrefix bệnh tự miễn'] = v;

            if (v != 'Có') {
              m.remove('ghi_chu_$fieldPrefix bệnh tự miễn');
            }

            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),
        if ((allValues['$fieldPrefix bệnh tự miễn'] as String?) == 'Có')
          InputTextField(
            label: 'Ghi rõ tên bệnh tự miễn',
            textController: _controllerBenhTuMien,
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              m['ghi_chu_$fieldPrefix bệnh tự miễn'] = v;
              widget.onChanged(m);
            },
          ),

        // Tiền sử bệnh lý khác
        CustomRadioGroup(
          label: '$fieldPrefix bệnh lý khác',
          value: allValues['$fieldPrefix bệnh lý khác']?.toString(),
          options: const ['Có', 'Không', 'Không biết'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            m['$fieldPrefix bệnh lý khác'] = v;

            if (v != 'Có') {
              m.remove('ghi_chu_$fieldPrefix bệnh lý khác');
            }

            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),
        if ((allValues['$fieldPrefix bệnh lý khác'] as String?) == 'Có')
          InputTextField(
            label: 'Ghi rõ tên bệnh lý khác',
            textController: _controllerBenhLyKhac,
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              m['ghi_chu_$fieldPrefix bệnh lý khác'] = v;
              widget.onChanged(m);
            },
          ),

        // Tiền sử dị ứng
        CustomRadioGroup(
          label: '$fieldPrefix dị ứng thuốc, thức ăn khác',
          value:
              allValues['$fieldPrefix dị ứng thuốc, thức ăn khác']?.toString(),
          options: const ['Có', 'Không', 'Không biết'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            m['$fieldPrefix dị ứng thuốc, thức ăn khác'] = v;

            if (v != 'Có') {
              m.remove('ghi_chu_$fieldPrefix dị ứng thuốc, thức ăn khác');
            }

            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),
        if ((allValues['$fieldPrefix dị ứng thuốc, thức ăn khác'] as String?) ==
            'Có')
          InputTextField(
            label: 'Ghi rõ tên dị ứng',
            textController: _controllerDaiUng,
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              m['ghi_chu_$fieldPrefix dị ứng thuốc, thức ăn khác'] = v;
              widget.onChanged(m);
            },
          ),

        // Tiền sử phản vệ
        CustomRadioGroup(
          label: '$fieldPrefix phản vệ',
          value: allValues['$fieldPrefix phản vệ']?.toString(),
          options: const ['Có', 'Không', 'Không biết'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            m['$fieldPrefix phản vệ'] = v;

            if (v != 'Có') {
              m.remove('ghi_chu_$fieldPrefix phản vệ');
            }

            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),
        if ((allValues['$fieldPrefix phản vệ'] as String?) == 'Có')
          InputTextField(
            label: 'Ghi rõ tên phản vệ',
            textController: _controllerPhanVe,
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              m['ghi_chu_$fieldPrefix phản vệ'] = v;
              widget.onChanged(m);
            },
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
    _controller.text = selected.contains('Thức ăn')
        ? (allValues['Chi tiết thức ăn làm nặng bệnh'] ?? '').toString()
        : (allValues['Chi tiết thuốc làm nặng bệnh'] ?? '').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        // const SizedBox(height: 8),
        CustomCheckboxGroup(
          label: '',
          selectedValues: selected,
          options: const ["Căng thẳng", "Thức ăn", "Thuốc"],
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
            if (!normalized.contains('Thuốc')) {
              m.remove('Chi tiết thuốc làm nặng bệnh');
            }

            widget.onChanged(m);
          },
          enabled: true,
        ),
        if (selected.contains('Thức ăn'))
          InputTextField(
            label: 'Chi tiết thức ăn làm nặng bệnh',
            textController: _controller,
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
        if (selected.contains('Thuốc'))
          InputTextField(
            label: 'Chi tiết thuốc làm nặng bệnh',
            textController: _controller,
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
    _controller.text = otherText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        // const SizedBox(height: 8),
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
            textController: _controller,
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
  // Widget _buildSpecial185or71(BuildContext context) {
  //   final label = widget.labelOverride ?? widget.indicator.name;
  //   final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
  //       ?.toString();
  //   final displayLabel = _displayLabel(label, unit);
  //
  //   // ✅ không cast cứng nữa
  //   final allValues = _asMap(widget.value);
  //
  //   final sel1 = allValues['11.1 Khi dùng thuốc']?.toString();
  //   final sel2 = allValues['11.2 Khi không dùng thuốc']?.toString();
  //
  //   final input1 =
  //       (allValues['Nhập khoảng thời gian (dùng thuốc)'] ?? '').toString();
  //   final input2 = (allValues['Nhập khoảng thời gian (không dùng thuốc)'] ?? '')
  //       .toString();
  //   if (sel1 == 'Khác (theo giờ)') {
  //     _controller.text = input1;
  //   }
  //   if (sel2 == 'Khác (theo giờ)') {
  //     _controller.text = input2;
  //   }
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
  //       // const SizedBox(height: 8),
  //       CustomRadioGroup(
  //         label: '11.1 Khi dùng thuốc',
  //         value: (sel1 != null && sel1.trim().isNotEmpty) ? sel1 : null,
  //         options: const [
  //           '< 1h',
  //           '1-6h',
  //           '6h-12h',
  //           '12-24h',
  //           'Không biết',
  //           'Khác (theo giờ)',
  //         ],
  //         onChanged: (v) {
  //           final m = Map<String, dynamic>.from(allValues);
  //           final vv = v?.toString() ?? '';
  //
  //           if (vv.trim().isNotEmpty) {
  //             m['11.1 Khi dùng thuốc'] = vv;
  //           } else {
  //             m.remove('11.1 Khi dùng thuốc');
  //           }
  //
  //           if (vv != 'Khác (theo giờ)') {
  //             m.remove('Nhập khoảng thời gian (dùng thuốc)');
  //           }
  //
  //           widget.onChanged(m);
  //         },
  //       ),
  //       if (sel1 == 'Khác (theo giờ)')
  //         InputTextField(
  //           label: 'Nhập khoảng thời gian',
  //           textController: _controller,
  //           onChanged: (v) {
  //             final m = Map<String, dynamic>.from(allValues);
  //             final vv = v.toString();
  //
  //             if (vv.trim().isNotEmpty) {
  //               m['Nhập khoảng thời gian (dùng thuốc)'] = vv;
  //             } else {
  //               m.remove('Nhập khoảng thời gian (dùng thuốc)');
  //             }
  //
  //             widget.onChanged(m);
  //           },
  //         ),
  //       CustomRadioGroup(
  //         label: '11.2 Khi không dùng thuốc',
  //         value: (sel2 != null && sel2.trim().isNotEmpty) ? sel2 : null,
  //         options: const [
  //           '< 1h',
  //           '1-6h',
  //           '6h-12h',
  //           '12-24h',
  //           'Không biết',
  //           'Khác (theo giờ)',
  //         ],
  //         onChanged: (v) {
  //           final m = Map<String, dynamic>.from(allValues);
  //           final vv = v?.toString() ?? '';
  //
  //           if (vv.trim().isNotEmpty) {
  //             m['11.2 Khi không dùng thuốc'] = vv;
  //           } else {
  //             m.remove('11.2 Khi không dùng thuốc');
  //           }
  //
  //           if (vv != 'Khác (theo giờ)') {
  //             m.remove('Nhập khoảng thời gian (không dùng thuốc)');
  //           }
  //
  //           widget.onChanged(m);
  //         },
  //       ),
  //       if (sel2 == 'Khác (theo giờ)')
  //         InputTextField(
  //           label: 'Nhập khoảng thời gian',
  //           textController: _controller,
  //           onChanged: (v) {
  //             final m = Map<String, dynamic>.from(allValues);
  //             final vv = v.toString();
  //
  //             if (vv.trim().isNotEmpty) {
  //               m['Nhập khoảng thời gian (không dùng thuốc)'] = vv;
  //             } else {
  //               m.remove('Nhập khoảng thời gian (không dùng thuốc)');
  //             }
  //
  //             widget.onChanged(m);
  //           },
  //         ),
  //     ],
  //   );
  // }
  Widget _buildSpecial185or71(BuildContext context) {
    final allValues = _asMap(widget.value);

    final sel1 = allValues['11.1 Khi dùng thuốc']?.toString();
    final sel2 = allValues['11.2 Khi không dùng thuốc']?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            final vv = v?.toString().trim() ?? '';

            if (vv.isNotEmpty) {
              m['11.1 Khi dùng thuốc'] = vv;
            } else {
              m.remove('11.1 Khi dùng thuốc');
            }

            // nếu không phải "Khác" thì xoá input + reset controller riêng
            if (vv != 'Khác (theo giờ)') {
              m.remove('Nhập khoảng thời gian (dùng thuốc)');
              if (_ctrl185_1.text.isNotEmpty) _ctrl185_1.clear();
            }

            widget.onChanged(m);
          },
        ),
        if (sel1 == 'Khác (theo giờ)')
          InputTextField(
            label: 'Nhập khoảng thời gian',
            textController: _ctrl185_1, // controller riêng
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              final text = v.trim();
              if (text.isNotEmpty) {
                m['Nhập khoảng thời gian (dùng thuốc)'] = text;
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
            final vv = v?.toString().trim() ?? '';

            if (vv.isNotEmpty) {
              m['11.2 Khi không dùng thuốc'] = vv;
            } else {
              m.remove('11.2 Khi không dùng thuốc');
            }

            if (vv != 'Khác (theo giờ)') {
              m.remove('Nhập khoảng thời gian (không dùng thuốc)');
              if (_ctrl185_2.text.isNotEmpty) _ctrl185_2.clear();
            }

            widget.onChanged(m);
          },
        ),
        if (sel2 == 'Khác (theo giờ)')
          InputTextField(
            label: 'Nhập khoảng thời gian',
            textController: _ctrl185_2, // controller riêng
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              final text = v.trim();
              if (text.isNotEmpty) {
                m['Nhập khoảng thời gian (không dùng thuốc)'] = text;
              } else {
                m.remove('Nhập khoảng thời gian (không dùng thuốc)');
              }
              widget.onChanged(m);
            },
          ),
      ],
    );
  }

  Widget _buildSpecial81or41(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    // ✅ không cast cứng nữa
    final allValues = _asMap(widget.value);

    final sel1 = allValues['4.1 Khi dùng thuốc']?.toString();
    final sel2 = allValues['4.2 Khi không dùng thuốc']?.toString();

    final input1 =
        (allValues['Nhập khoảng thời gian (dùng thuốc)'] ?? '').toString();
    final input2 = (allValues['Nhập khoảng thời gian (không dùng thuốc)'] ?? '')
        .toString();
    if (sel1 == 'Khác (theo giờ)') {
      _controller.text = input1;
    }
    if (sel2 == 'Khác (theo giờ)') {
      _controller.text = input2;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        // const SizedBox(height: 8),
        CustomRadioGroup(
          label: '4.1 Khi dùng thuốc',
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
              m['4.1 Khi dùng thuốc'] = vv;
            } else {
              m.remove('4.1 Khi dùng thuốc');
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
            textController: _controller,
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
          label: '4.2 Khi không dùng thuốc',
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
              m['4.2 Khi không dùng thuốc'] = vv;
            } else {
              m.remove('4.2 Khi không dùng thuốc');
            }

            if (vv != 'Khác (theo giờ)') {
              m.remove('Nhập khoảng thời gian (không dùng thuốc)');
            }

            widget.onChanged(m);
          },
        ),
        if (sel2 == 'Khác (theo giờ)')
          InputTextField(
            keyboardType: TextInputType.text,
            label: 'Nhập khoảng thời gian',
            textController: _controller,
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
        // Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        // const SizedBox(height: 8),
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

  Widget _buildSpecial217(BuildContext context) {
    final label = widget.labelOverride ?? widget.indicator.name;
    final unit = (widget.unitOverride ?? widget.unit ?? widget.indicator.unit)
        ?.toString();
    final displayLabel = _displayLabel(label, unit);

    final allValues = _asMap(widget.value);

    final controllerTienSuDiUng = TextEditingController(
      text: allValues['Chi tiết tiền sử dị ứng']?.toString() ?? '',
    );
    final controllerThuoc = TextEditingController(
      text: allValues['Chi tiết thuốc']?.toString() ?? '',
    );
    final controllerYeuToKhac = TextEditingController(
      text: allValues['Yếu tố khác']?.toString() ?? '',
    );

    Widget buildRadioWithDetail({
      required String label,
      required String detailKey,
      required TextEditingController controller,
    }) {
      final selected = allValues[label]?.toString();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomRadioGroup(
            label: label,
            value: selected,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (v) {
              final m = Map<String, dynamic>.from(allValues);
              m[label] = v;
              if (v != 'Có') {
                m.remove(detailKey);
              }
              widget.onChanged(m);
            },
            isRequired: false,
            enabled: true,
          ),
          if (selected == 'Có')
            InputTextField(
              label: detailKey,
              textController: controller,
              onChanged: (v) {
                final m = Map<String, dynamic>.from(allValues);
                m[detailKey] = v;
                widget.onChanged(m);
              },
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        buildRadioWithDetail(
          label: 'Tiền sử dị ứng',
          detailKey: 'Chi tiết tiền sử dị ứng',
          controller: controllerTienSuDiUng,
        ),
        buildRadioWithDetail(
          label: 'Thuốc',
          detailKey: 'Chi tiết thuốc',
          controller: controllerThuoc,
        ),
        CustomRadioGroup(
          label: 'Mày đay',
          value: allValues['Mày đay']?.toString(),
          options: const ['Có', 'Không', 'Không biết'],
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            m['Mày đay'] = v;
            widget.onChanged(m);
          },
          isRequired: false,
          enabled: true,
        ),
        InputTextField(
          label: 'Yếu tố khác',
          textController: controllerYeuToKhac,
          onChanged: (v) {
            final m = Map<String, dynamic>.from(allValues);
            m['Yếu tố khác'] = v;
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
          label: "",
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
        _controller.text = dateValue != null
            ? "${dateValue.day.toString().padLeft(2, '0')}/"
                "${dateValue.month.toString().padLeft(2, '0')}/"
                "${dateValue.year}"
            : '';
        return InkWell(
          onTap: () async {
            _releaseKeyboardFocus();
            final picked = await showDatePicker(
              locale: const Locale('vi'),
              context: context,
              initialDate: dateValue ?? DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
            );
            _releaseKeyboardFocus();
            if (picked != null) {
              widget.onChanged(picked.toIso8601String());
            }
          },
          child: IgnorePointer(
            child: InputTextField(
              label: displayLabel,
              enabled: false,
              prefixIcon: const Icon(Icons.calendar_today),
              textController: _controller,
            ),
          ),
        );

      case FieldType.fullYearRange:
        return InkWell(
          onTap: () async {
            _releaseKeyboardFocus();
            final picked = await showDatePicker(
              locale: const Locale('vi'),
              context: context,
              initialDate: DateTime.tryParse(widget.value?.toString() ?? '') ??
                  DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            _releaseKeyboardFocus();
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
          indicator: widget.indicator,
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
