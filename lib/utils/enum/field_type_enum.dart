enum FieldType {
  text,
  number,
  select,
  multiSelection,
  range,
  fullYearRange,
  fullDate,
  custom, // nested group
  prescription,
  image,
  unknown,
}

FieldType parseFieldType(String? type) {
  switch (type) {
    case "text":
      return FieldType.text;
    case "number":
      return FieldType.number;
    case "select":
      return FieldType.select;
    case "selection":
      return FieldType.select;
    case "multi_selection":
      return FieldType.multiSelection;
    case "range": // NEW
      return FieldType.range;
    case "full_year_range":
      return FieldType.fullYearRange;
    case "full_date":
    case "fullDate":
      return FieldType.fullDate;
    case "custom":
      return FieldType.custom;
    case "prescription":
      return FieldType.prescription;
    case "image":
      return FieldType.image;
    default:
      return FieldType.unknown;
  }
}

// Cập nhật CustomField.fromJson
class CustomField {
  final String? label;
  final String? description;
  final FieldType type;
  final List<String>? options;
  final List<CustomFieldGroup>? groups; // Nhóm lồng nhau
  final List<CustomField>? requiredFields; // Có điều kiện
  final String? dependsOn;
  final List<String>? dependsOnValues;

  CustomField({
    this.label,
    this.description,
    required this.type,
    this.options,
    this.groups,
    this.requiredFields,
    this.dependsOn,
    this.dependsOnValues,
  });

  factory CustomField.fromJson(Map<String, dynamic> json) {
    // Phân tích groups từ valueOptions['group'] hoặc trực tiếp 'group' hoặc 'fields'
    final groupJson =
        json['valueOptions']?['group'] ?? json['group'] ?? json['fields'];
    List<CustomFieldGroup>? parsedGroups;
    if (groupJson != null) {
      if (groupJson is List) {
        parsedGroups =
            groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
      } else if (groupJson is Map<String, dynamic>) {
        parsedGroups = [CustomFieldGroup.fromJson(groupJson)];
      }
    }

    // Phân tích fields trực tiếp từ json['fields'] nếu có
    if (json['fields'] is List && parsedGroups == null) {
      parsedGroups = [
        CustomFieldGroup(
          label: json['label'],
          fields: (json['fields'] as List)
              .map((e) => CustomField.fromJson(e))
              .toList(),
        )
      ];
    }

    // Phân tích requiredFields
    List<CustomField>? parsedRequired;
    final reqFields = json['requiredFields'] as List?;
    if (reqFields != null) {
      parsedRequired = reqFields.map((f) => CustomField.fromJson(f)).toList();
    }

    // Xác định type
    FieldType type = parseFieldType(json['type']);
    if (type == FieldType.unknown &&
        (parsedGroups != null || json['fields'] is List)) {
      type = FieldType
          .custom; // Suy ra type custom nếu có fields hoặc groups lồng nhau
    }
    final fieldLabel =
        json['label'] ?? json['name'] ?? 'Field_${json['type'] ?? 'unknown'}';
    return CustomField(
      label: fieldLabel,
      description: json['description'],
      type: type,
      options: ((json['option'] ?? json['options']) as List?)
          ?.map((e) => e.toString())
          .toList(),
      groups: parsedGroups,
      requiredFields: parsedRequired,
    );
  }
}

// Cập nhật CustomFieldGroup.fromJson
class CustomFieldGroup {
  final String? label;
  final List<CustomField> fields;

  CustomFieldGroup({this.label, required this.fields});

  factory CustomFieldGroup.fromJson(Map<String, dynamic> json) {
    List<CustomField> parsedFields = [];

    // Xử lý key 'fields'
    if (json['fields'] is List) {
      parsedFields =
          (json['fields'] as List).map((e) => CustomField.fromJson(e)).toList();
    }
    // Xử lý key 'field'
    else if (json['field'] is List) {
      parsedFields =
          (json['field'] as List).map((e) => CustomField.fromJson(e)).toList();
    }
    // Xử lý trường hợp group là một field
    else if (json['type'] != null) {
      parsedFields = [CustomField.fromJson(json)];
    }

    return CustomFieldGroup(
      label: json['label'],
      fields: parsedFields,
    );
  }
}
