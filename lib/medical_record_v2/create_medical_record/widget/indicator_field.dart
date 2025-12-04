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
    switch (widget.indicator.valueType) {
      case "text":
        return InputTextField(
          label: widget.indicator.name,
          textController: _textCtrl,
          onChanged: widget.onChanged,
        );

      case "number":
        return InputTextField(
          label: widget.indicator.name,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textController: _numCtrl,
          onChanged: (val) => widget.onChanged(num.tryParse(val) ?? val),
        );

      case "boolean":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.indicator.name,
                style: Theme.of(context).textTheme.bodyMedium),
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
              _buildIndicatorLabel(),
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
          label: widget.indicator.name,
          value: widget.value,
          options: options,
          onChanged: widget.onChanged,
        );

      case "multi_selection":
        final options = widget.indicator.valueOptions as List<String>? ?? [];

        // Đặc thù 65/190 giữ nguyên
        if (widget.indicator.id == 65 || widget.indicator.id == 190) {
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
                label: widget.indicator.name,
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
                  options: options,
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
          label: widget.indicator.name,
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
              label: widget.indicator.name,
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
              label: widget.indicator.name,
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
            Text(widget.indicator.name),
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

        // Đặc thù 64/175 giữ nguyên
        if (widget.indicator.id == 64 || widget.indicator.id == 175) {
          final allValues = (widget.value as Map<String, dynamic>?) ?? {};

          final previousEpisodeKey =
              "Trước đây bạn đã từng bị đợt nào như vậy chưa?";
          final previousEpisodeValue = allValues[previousEpisodeKey];
          final shouldShowEpisodeDropdown = (previousEpisodeValue is Map &&
                  previousEpisodeValue[previousEpisodeKey] == 'Có') ||
              (previousEpisodeValue is String &&
                  previousEpisodeValue.trim() == 'Có');

          final episodeCountKey = "${widget.indicator.name}_episode_count";
          final episodeCount =
              shouldShowEpisodeDropdown ? (allValues[episodeCountKey] ?? 1) : 1;

          List<CustomFieldGroup> filteredGroups = [];
          if (groups.isNotEmpty) filteredGroups.add(groups[0]);
          if (shouldShowEpisodeDropdown && episodeCount > 1) {
            filteredGroups.addAll(groups.skip(1).take(episodeCount - 1));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.indicator.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (filteredGroups.isNotEmpty)
                buildCustomField(filteredGroups[0], widget.value,
                    (updatedValue) {
                  final updatedValues = Map<String, dynamic>.from(allValues);
                  if (updatedValue is Map<String, dynamic>) {
                    updatedValues.addAll(updatedValue);
                  }
                  final newPrev = updatedValues[previousEpisodeKey];
                  final newShouldShow =
                      (newPrev is Map && newPrev[previousEpisodeKey] == 'Có') ||
                          (newPrev is String && newPrev.trim() == 'Có');

                  if (!newShouldShow) {
                    updatedValues.remove(episodeCountKey);
                    for (int i = 1; i < groups.length; i++) {
                      final group = groups[i];
                      final groupLabel = group.label?.trim() ?? '';
                      for (final field in group.fields) {
                        final fieldLabel = field.label?.trim() ?? '';
                        final fk = groupLabel.isNotEmpty
                            ? '$groupLabel.$fieldLabel'
                            : fieldLabel;
                        updatedValues.remove(fk);
                        updatedValues.remove("${fk}_image");
                      }
                    }
                  }
                  widget.onChanged(updatedValues);
                }),
              if (shouldShowEpisodeDropdown) ...[
                const SizedBox(height: 16),
                Text("Chọn số đợt đã trải qua:",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor)),
                const SizedBox(height: 8),
                DropdownButton<int>(
                  value: episodeCount,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("1 đợt")),
                    DropdownMenuItem(value: 2, child: Text("2 đợt")),
                    DropdownMenuItem(value: 3, child: Text("3 đợt")),
                    DropdownMenuItem(value: 4, child: Text("4 đợt")),
                  ],
                  onChanged: (newCount) {
                    if (newCount != null) {
                      final updatedValues =
                          Map<String, dynamic>.from(allValues);
                      updatedValues[episodeCountKey] = newCount;
                      for (int i = newCount; i < groups.length; i++) {
                        final group = groups[i];
                        final groupLabel = group.label?.trim() ?? '';
                        for (final field in group.fields) {
                          final fieldLabel = field.label?.trim() ?? '';
                          final fk = groupLabel.isNotEmpty
                              ? '$groupLabel.$fieldLabel'
                              : fieldLabel;
                          updatedValues.remove(fk);
                          updatedValues.remove("${fk}_image");
                        }
                      }
                      widget.onChanged(updatedValues);
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (shouldShowEpisodeDropdown && episodeCount > 1)
                ...filteredGroups.skip(1).map((group) =>
                    buildCustomField(group, widget.value, (updatedValue) {
                      final updatedValues =
                          Map<String, dynamic>.from(allValues);
                      if (updatedValue is Map<String, dynamic>) {
                        updatedValues.addAll(updatedValue);
                      }
                      widget.onChanged(updatedValues);
                    })),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.indicator.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            buildCustomField(groups, widget.value, widget.onChanged),
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
            .map((e) =>
                buildCustomField(e, value, onChanged, parentLabel: parentLabel))
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
      }

      for (int idx = 0; idx < group.fields.length; idx++) {
        final f = group.fields[idx];
        final fieldLabel = f.label?.trim() ?? 'field_$idx';
        final fieldKey =
            groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;

        bool shouldShowField = true;

        // Điều kiện “Có điều trị hay không?”
        if (fieldLabel == "Tên thuốc" ||
            fieldLabel == "Liều thuốc (ghi thời gian nếu nhớ)" ||
            fieldLabel == "Tình trạng tổn thương khi đang uống thuốc") {
          final treatmentKey = groupLabel.isNotEmpty
              ? '$groupLabel.Có điều trị hay không?'
              : 'Có điều trị hay không?';
          final tv = allValues[treatmentKey];
          final isYes = (tv is Map && tv['Có điều trị hay không?'] == 'Có') ||
              (tv is String && tv.trim() == 'Có');
          shouldShowField = isYes;
        }

        if (fieldLabel == "Triệu chứng Giảm xuống/Nặng lên là gì?") {
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

        if (!shouldShowField) continue;

        final fieldValue = allValues[fieldKey];

        children.add(
          buildCustomField(
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
                } else {
                  newMap.remove(fieldKey);
                }
              }

              // Cleanup khi đổi điều trị
              if (fieldLabel == "Có điều trị hay không?") {
                final isYes = updatedValue == "Có" ||
                    (updatedValue is Map &&
                        updatedValue['Có điều trị hay không?'] == 'Có');
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
                  newMap.remove(drugNameKey);
                  newMap.remove(drugDoseKey);
                  newMap.remove(statusKey);
                }
              }

              if (fieldLabel == "Tình trạng tổn thương khi đang uống thuốc") {
                final keep =
                    updatedValue == "Giảm xuống" || updatedValue == "Nặng lên";
                if (!keep) {
                  final symptomKey = groupLabel.isNotEmpty
                      ? '$groupLabel.Triệu chứng Giảm xuống/Nặng lên là gì?'
                      : 'Triệu chứng Giảm xuống/Nặng lên là gì?';
                  newMap.remove(symptomKey);
                }
              }

              onChanged(newMap);
            },
            parentLabel: groupLabel,
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
              // image-only: chỉ uploader ảnh, trả URL trực tiếp
              String? url;
              if (value is String && value.trim().isNotEmpty) {
                url = value;
              } else if (value is Map) {
                final k = field.label ?? '';
                url = (value['${k}_image'] as String?) ??
                    (value['image'] as String?);
              }
              widgets.add(
                ImageUploadField(
                  label: field.label ?? 'Ảnh',
                  templateId: widget.templateId,
                  //initialImageUrl: url,
                  onChanged: (link) => onChanged(
                      (link != null && link.isNotEmpty) ? link : null),
                ),
              );
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
                    onChanged: (opt) => onChanged(
                        (opt != null && opt.toString().trim().isNotEmpty)
                            ? opt
                            : null),
                  ),
                  if (needsImage && (selected != null && selected.isNotEmpty))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ImageUploadField(
                        label: "Ảnh cho $selected",
                        templateId: widget.templateId,
                        onChanged: (link) {
                          // Gửi patch ảnh -> parent group sẽ ghi "<key>_image"
                          onChanged({_kImagePatchKey: link});
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
              // Map<option, url|null>
              final Map<String, String?> current = (value is Map)
                  ? Map<String, String?>.from(
                      (value as Map).map((k, v) => MapEntry(
                            k.toString(),
                            v == null ? null : v.toString(),
                          )))
                  : <String, String?>{};
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
                        final next = <String, String?>{};
                        for (final opt in vals) {
                          next[opt] = current[opt]; // giữ url cũ
                        }
                        onChanged(next); // trả map phẳng
                      },
                      isRequired: false,
                      enabled: true,
                    ),
                    ...selected.map((opt) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ImageUploadField(
                            label: "Ảnh cho $opt",
                            templateId: widget.templateId,
                            //initialImageUrl: current[opt],
                            selectedOption: opt,
                            onChanged: (link) {
                              final next = Map<String, String?>.from(current);
                              next[opt] = (link != null && link.isNotEmpty)
                                  ? link
                                  : null;
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
                label: widget.indicator.name,
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
