import 'package:dr_urticaria/models/vital_indicator_model.dart';
import 'package:dr_urticaria/utils/enum/field_type_enum.dart';
import 'package:dr_urticaria/utils/navigation_service.dart';
import 'package:dr_urticaria/widget/text_field/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_radio_group.dart';
import '../../../constant/color.dart';

class VitalFieldEditor extends StatelessWidget {
  final VitalIndicatorModel indicator;
  final dynamic value;
  final String? unit;
  final Function(dynamic) onChanged;

  const VitalFieldEditor({
    super.key,
    required this.indicator,
    this.value,
    this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Create suffixIcon from unit string
    final suffixIcon = unit != null
        ? IconButton(
            onPressed: null, // No action needed for unit display
            icon: Text(
              unit!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyColor,
                  ),
            ),
          )
        : null;

    switch (indicator.valueType) {
      case "text":
        return InputTextField(
          label: indicator.name,
          textController: TextEditingController(text: value?.toString() ?? ""),
          onChanged: onChanged,
          iconButton: suffixIcon,
          decoration: _decoration(context, label: indicator.name),
        );

      case "number":
        return InputTextField(
          label: indicator.name,
          textController: TextEditingController(text: value?.toString() ?? ""),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (val) => onChanged(num.tryParse(val)),
          iconButton: suffixIcon,
          decoration: _decoration(
            context,
            label: indicator.name,
            hint: _rangeHint(),
          ),
        );

      case "boolean":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicator.name, style: Theme.of(context).textTheme.bodyMedium),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Có"),
                    value: true,
                    groupValue: value,
                    onChanged: onChanged,
                    activeColor: AppColors.primaryColor,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Không"),
                    value: false,
                    groupValue: value,
                    onChanged: onChanged,
                    activeColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        );

      case "selection":
        final options = indicator.valueOptions is List
            ? List<String>.from(indicator.valueOptions as List)
            : <String>[];
        return CustomRadioGroup(
          label: indicator.name,
          value: (value != null && options.contains(value)) ? value : null,
          options: options,
          onChanged: onChanged,
        );

      case "multi_selection":
        final options = indicator.valueOptions is List
            ? List<String>.from(indicator.valueOptions as List)
            : <String>[];
        final selected = (value as List<String>?) ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicator.name, style: Theme.of(context).textTheme.bodyMedium),
            Wrap(
              spacing: 6,
              children: options.map((opt) {
                final checked = selected.contains(opt);
                return FilterChip(
                  label: Text(opt),
                  selected: checked,
                  selectedColor: AppColors.primaryColor.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryColor,
                  backgroundColor: AppColors.whiteColor,
                  onSelected: (sel) {
                    final updated = List<String>.from(selected);
                    if (sel) {
                      updated.add(opt);
                    } else {
                      updated.remove(opt);
                    }
                    onChanged(updated);
                  },
                );
              }).toList(),
            ),
          ],
        );

      case "full_date":
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(value?.toString() ?? "") ?? DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onChanged(DateFormat("yyyy-MM-dd").format(picked));
            }
          },
          child: InputTextField(
            label: indicator.name,
            enabled: false,
            prefixIcon: const Icon(Icons.calendar_today),
            textController: TextEditingController(
              text: value != null
                  ? DateTime.tryParse(value.toString()) != null
                      ? DateFormat("yyyy-MM-dd").format(DateTime.parse(value.toString()))
                      : value.toString()
                  : "Chọn ngày",
            ),
            decoration: _decoration(context, label: indicator.name, hint: "Chọn ngày"),
          ),
        );

      case "range":
        final min = num.tryParse(indicator.minValue ?? '0')?.toDouble() ?? 0;
        final max = num.tryParse(indicator.maxValue ?? '100')?.toDouble() ?? 100;
        final range = (value as RangeValues?) ?? RangeValues(min, max);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicator.name, style: Theme.of(context).textTheme.bodyMedium),
            RangeSlider(
              values: range,
              min: min,
              max: max,
              divisions: ((max - min) / 5).round(),
              activeColor: AppColors.primaryColor,
              onChanged: onChanged,
              labels: RangeLabels(
                range.start.toStringAsFixed(1),
                range.end.toStringAsFixed(1),
              ),
            ),
          ],
        );

      case "custom":
        final groupJson = indicator.valueOptions is Map<String, dynamic>
            ? indicator.valueOptions['group']
            : null;
        List<CustomFieldGroup> groups = [];

        if (groupJson is List) {
          groups = groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
        } else if (groupJson is Map<String, dynamic>) {
          groups = [CustomFieldGroup.fromJson(groupJson)];
        } else {
          groups = [];
        }
        //return Text("hehe");
        return _buildCustomField(groups, value, onChanged);

      default:
        return Text("⚠️ Chưa hỗ trợ loại: ${indicator.valueType}");
    }
  }

  Widget _buildCustomField(
      dynamic fieldOrGroup, dynamic value, Function(dynamic) onChanged) {
    if (fieldOrGroup is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fieldOrGroup
            .map((e) => _buildCustomField(e, value, onChanged))
            .toList(),
      );
    }

    if (fieldOrGroup is CustomFieldGroup) {
      final group = fieldOrGroup;
      List<Widget> children = [];
      if (group.label != null) {
        children.add(
          Text(
            group.label!,
            style: Theme.of(getContext)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      }
      for (final f in group.fields) {
        children.add(_buildCustomField(f, value, onChanged));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    if (fieldOrGroup is CustomField) {
      final field = fieldOrGroup;
      List<Widget> widgets = [];
      final suffixIcon = unit != null
          ? IconButton(
              onPressed: null,
              icon: Text(
                unit!,
                style: Theme.of(getContext).textTheme.bodyMedium?.copyWith(
                      color: AppColors.greyColor,
                    ),
              ),
            )
          : null;

      switch (field.type) {
        case FieldType.text:
          widgets.add(
            InputTextField(
              label: field.label ?? '',
              textController: TextEditingController(text: value?.toString() ?? ""),
              onChanged: onChanged,
              iconButton: suffixIcon,
              decoration: _decoration(getContext, label: field.label),
            ),
          );
          break;
        case FieldType.number:
          widgets.add(
            InputTextField(
              label: field.label ?? '',
              textController: TextEditingController(text: value?.toString() ?? ""),
              keyboardType: TextInputType.number,
             // onChanged: (val) => onChanged(num.tryParse(val)),
              iconButton: suffixIcon,
              decoration: _decoration(getContext, label: field.label),
            ),
          );
          break;
        case FieldType.select:
          widgets.add(
            CustomRadioGroup(
              label: field.label ?? '',
              value: value,
              options: field.options ?? [],
              onChanged: onChanged,
            ),
          );
          break;
        case FieldType.multiSelection:
          final selected = (value as List<String>?) ?? [];
          widgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.label ?? '',
                    style: Theme.of(getContext).textTheme.bodyMedium),
                Wrap(
                  spacing: 6,
                  children: (field.options ?? []).map((opt) {
                    final checked = selected.contains(opt);
                    return FilterChip(
                      backgroundColor: AppColors.whiteColor,
                      label: Text(opt),
                      selected: checked,
                      selectedColor: AppColors.primaryColor.withOpacity(0.2),
                      checkmarkColor: AppColors.primaryColor,
                      onSelected: (sel) {
                        final updated = List<String>.from(selected);
                        if (sel) {
                          updated.add(opt);
                        } else {
                          updated.remove(opt);
                        }
                        onChanged(updated);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
          break;
        case FieldType.fullYearRange:
          widgets.add(
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: getContext,
                  initialDate: DateTime.tryParse(value?.toString() ?? "") ?? DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                );
                if (picked != null) onChanged(picked.toIso8601String());
              },
              child: InputTextField(
                label: field.label ?? "Khoảng năm",
                enabled: false,
                prefixIcon: const Icon(Icons.calendar_today),
                textController: TextEditingController(
                  text: value != null
                      ? DateTime.tryParse(value.toString()) != null
                          ? DateFormat("yyyy-MM-dd").format(DateTime.parse(value.toString()))
                          : value.toString()
                      : "Chọn ngày",
                ),
                decoration: _decoration(getContext, label: field.label, hint: "Chọn ngày"),
              ),
            ),
          );
          break;
        case FieldType.prescription:
          widgets.add(
            InputTextField(
              label: field.label ?? 'Kê đơn thuốc',
              textController: TextEditingController(text: value?.toString() ?? ""),
              onChanged: (value) => onChanged(value),
              hintText: 'Nhập tên thuốc hoặc thông tin đơn thuốc',
              prefixIcon: const Icon(Icons.medical_services),
              iconButton: suffixIcon,
              decoration: _decoration(getContext, label: field.label, hint: "Nhập tên thuốc"),
            ),
          );
          break;
        case FieldType.custom:
          if (field.groups != null && field.groups!.isNotEmpty) {
            for (final g in field.groups!) {
              widgets.add(_buildCustomField(g, value, onChanged));
            }
          } else {
            widgets.add(
              Text(
                field.label ?? 'Custom Field',
                style: Theme.of(getContext)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }
          break;
        default:
          widgets.add(Text("⚠️ Chưa hỗ trợ loại: ${field.type}"));
      }

      if (field.requiredFields != null) {
        for (final rf in field.requiredFields!) {
          widgets.add(_buildCustomField(rf, value, onChanged));
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }

    if (fieldOrGroup is Map<String, dynamic>) {
      return _buildCustomField(CustomField.fromJson(fieldOrGroup), value, onChanged);
    }

    return const SizedBox.shrink();
  }

  String? _rangeHint() {
    final min = indicator.minValue;
    final max = indicator.maxValue;
    if (min != null || max != null) {
      return 'Giới hạn: ${min?.toString() ?? "−∞"} ~ ${max?.toString() ?? "+∞"}';
    }
    return null;
  }

  InputDecoration _decoration(BuildContext context,
      {String? label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}