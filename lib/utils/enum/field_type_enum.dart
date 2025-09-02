enum FieldType {
  text,
  number,
  select,
  multiSelection,
  fullYearRange,
  custom, // nested group
  prescription,
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
    case "multi_selection":
      return FieldType.multiSelection;
    case "full_year_range":
      return FieldType.fullYearRange;
    case "custom":
      return FieldType.custom;
    case "prescription":
      return FieldType.prescription;
    default:
      return FieldType.unknown;
  }
}

// class CustomField {
//   final String? label;
//   final String? description;
//   final FieldType type;
//   final List<String>? options;
//   final List<CustomFieldGroup>? groups; // nested groups
//   final List<CustomField>? requiredFields; // conditional
//
//   CustomField({
//     this.label,
//     this.description,
//     required this.type,
//     this.options,
//     this.groups,
//     this.requiredFields,
//   });
//
//   factory CustomField.fromJson(Map<String, dynamic> json) {
//     // parse groups từ valueOptions['group'] hoặc group
//     final groupJson = json['valueOptions']?['group'] ?? json['group'];
//     List<CustomFieldGroup>? parsedGroups;
//     if (groupJson != null) {
//       if (groupJson is List) {
//         parsedGroups =
//             groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
//       } else if (groupJson is Map<String, dynamic>) {
//         parsedGroups = [CustomFieldGroup.fromJson(groupJson)];
//       }
//     }
//
//     // parse requiredFields
//     List<CustomField>? parsedRequired;
//     final reqFields = json['requiredFields'] as List?;
//     if (reqFields != null) {
//       parsedRequired = reqFields.map((f) => CustomField.fromJson(f)).toList();
//     }
//
//     // kiểm tra fields lồng nhau
//     final hasNestedFields = json['fields'] is List;
//
//     // xác định type
//     FieldType type;
//     if (json['type'] != null) {
//       type = parseFieldType(json['type']);
//     } else if (hasNestedFields || parsedGroups != null) {
//       type = FieldType.custom; // đây là nhóm chứa fields con
//     } else {
//       type = FieldType.unknown;
//     }
//
//     return CustomField(
//       label: json['label'],
//       description: json['description'],
//       type: type,
//       options: ((json['option'] ?? json['options']) as List?)
//           ?.map((e) => e.toString())
//           .toList(),
//       groups: parsedGroups,
//       requiredFields: parsedRequired,
//     );
//   }
// }
//
// class CustomFieldGroup {
//   final String? label;
//   final List<CustomField> fields;
//
//   CustomFieldGroup({this.label, required this.fields});
//
//   factory CustomFieldGroup.fromJson(Map<String, dynamic> json) {
//     List<CustomField> parsedFields = [];
//
//     // case: "fields" key
//     if (json['fields'] is List) {
//       parsedFields =
//           (json['fields'] as List).map((e) => CustomField.fromJson(e)).toList();
//     }
//     // case: "field" key
//     else if (json['field'] is List) {
//       parsedFields =
//           (json['field'] as List).map((e) => CustomField.fromJson(e)).toList();
//     }
//     // case: direct type on group (group itself is a field)
//     else if (json['type'] != null) {
//       parsedFields = [CustomField.fromJson(json)];
//     }
//
//     return CustomFieldGroup(
//       label: json['label'],
//       fields: parsedFields,
//     );
//   }
//}
// Cập nhật CustomField.fromJson
class CustomField {
  final String? label;
  final String? description;
  final FieldType type;
  final List<String>? options;
  final List<CustomFieldGroup>? groups; // Nhóm lồng nhau
  final List<CustomField>? requiredFields; // Có điều kiện

  CustomField({
    this.label,
    this.description,
    required this.type,
    this.options,
    this.groups,
    this.requiredFields,
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

    return CustomField(
      label: json['label'],
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
// import 'package:flutter/material.dart';
//
// // ---------- Enum ----------
// enum FieldType {
//   text,
//   number,
//   select,
//   multiSelection,
//   fullYearRange,
//   custom,
//   prescription,
//   unknown,
// }
//
// FieldType parseFieldType(String? type) {
//   switch (type) {
//     case "text":
//       return FieldType.text;
//     case "number":
//       return FieldType.number;
//     case "select":
//       return FieldType.select;
//     case "multi_selection":
//       return FieldType.multiSelection;
//     case "full_year_range":
//       return FieldType.fullYearRange;
//     case "custom":
//       return FieldType.custom;
//     case "prescription":
//       return FieldType.prescription;
//     default:
//       return FieldType.unknown;
//   }
// }
//
// // ---------- CustomField ----------
// class CustomField {
//   final String? label;
//   final String? description;
//   final FieldType type;
//   final List<String>? options;
//   final List<CustomFieldGroup>? groups; // nested groups
//   final List<CustomField>? requiredFields; // conditional
//
//   CustomField({
//     this.label,
//     this.description,
//     required this.type,
//     this.options,
//     this.groups,
//     this.requiredFields,
//   });
//
//   factory CustomField.fromJson(Map<String, dynamic> json) {
//     // parse groups từ valueOptions['group'] hoặc group
//     final groupJson = json['valueOptions']?['group'] ?? json['group'];
//     List<CustomFieldGroup>? parsedGroups;
//     if (groupJson != null) {
//       if (groupJson is List) {
//         parsedGroups =
//             groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
//       } else if (groupJson is Map<String, dynamic>) {
//         parsedGroups = [CustomFieldGroup.fromJson(groupJson)];
//       }
//     }
//
//     // parse requiredFields
//     List<CustomField>? parsedRequired;
//     final reqFields = json['requiredFields'] as List?;
//     if (reqFields != null) {
//       parsedRequired = reqFields.map((f) => CustomField.fromJson(f)).toList();
//     }
//
//     // kiểm tra fields lồng nhau
//     final hasNestedFields = json['fields'] is List;
//
//     // xác định type
//     FieldType type;
//     if (json['type'] != null) {
//       type = parseFieldType(json['type']);
//     } else if (hasNestedFields || parsedGroups != null) {
//       type = FieldType.custom;
//     } else {
//       type = FieldType.unknown;
//     }
//
//     return CustomField(
//       label: json['label'],
//       description: json['description'],
//       type: type,
//       options: ((json['option'] ?? json['options']) as List?)
//           ?.map((e) => e.toString())
//           .toList(),
//       groups: parsedGroups,
//       requiredFields: parsedRequired,
//     );
//   }
// }
//
// // ---------- CustomFieldGroupOrField ----------
// class CustomFieldOrGroup {
//   final CustomField? field;
//   final CustomFieldGroup? group;
//
//   CustomFieldOrGroup({this.field, this.group});
//
//   factory CustomFieldOrGroup.fromJson(Map<String, dynamic> json) {
//     if (json['fields'] is List) {
//       return CustomFieldOrGroup(group: CustomFieldGroup.fromJson(json));
//     } else {
//       return CustomFieldOrGroup(field: CustomField.fromJson(json));
//     }
//   }
// }
//
// // ---------- CustomFieldGroup ----------
// class CustomFieldGroup {
//   final String? label;
//   final List<CustomFieldOrGroup> fields;
//
//   CustomFieldGroup({this.label, required this.fields});
//
//   factory CustomFieldGroup.fromJson(Map<String, dynamic> json) {
//     List<CustomFieldOrGroup> parsedFields = [];
//     if (json['fields'] is List) {
//       parsedFields = (json['fields'] as List)
//           .map((e) => CustomFieldOrGroup.fromJson(e as Map<String, dynamic>))
//           .toList();
//     }
//     return CustomFieldGroup(
//       label: json['label'],
//       fields: parsedFields,
//     );
//   }
// }
//
// // ---------- buildCustomField ----------
// Widget buildCustomField(
//     dynamic fieldOrGroup, dynamic value, Function(dynamic) onChanged) {
//   if (fieldOrGroup is CustomFieldGroup) {
//     final group = fieldOrGroup;
//     List<Widget> children = [];
//     if (group.label != null) {
//       children.add(
//           Text(group.label!, style: TextStyle(fontWeight: FontWeight.bold)));
//     }
//     for (final fg in group.fields) {
//       if (fg.group != null) {
//         children.add(buildCustomField(fg.group!, value, onChanged));
//       } else if (fg.field != null) {
//         children.add(buildCustomField(fg.field!, value, onChanged));
//       }
//     }
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start, children: children);
//   }
//
//   if (fieldOrGroup is CustomField) {
//     final field = fieldOrGroup;
//     List<Widget> widgets = [];
//
//     switch (field.type) {
//       case FieldType.text:
//         widgets.add(Text(field.label ?? 'Text Field'));
//         break;
//       case FieldType.number:
//         widgets.add(Text(field.label ?? 'Number Field'));
//         break;
//       case FieldType.select:
//         widgets.add(Text(field.label ?? 'Select Field'));
//         break;
//       case FieldType.multiSelection:
//         widgets.add(Text(field.label ?? 'MultiSelection Field'));
//         break;
//       case FieldType.fullYearRange:
//         widgets.add(Text(field.label ?? 'Year Range Field'));
//         break;
//       case FieldType.prescription:
//         widgets.add(Text(field.label ?? 'Prescription Field'));
//         break;
//       case FieldType.custom:
//         if (field.groups != null) {
//           for (final g in field.groups!) {
//             widgets.add(buildCustomField(g, value, onChanged));
//           }
//         } else if (field.requiredFields != null) {
//           // fallback: có requiredFields -> render như fields
//           for (final rf in field.requiredFields!) {
//             widgets.add(buildCustomField(rf, value, onChanged));
//           }
//         }
//         break;
//       default:
//         widgets.add(Text("⚠️ Unsupported field type ${field.type}"));
//     }
//
//     // render requiredFields
//     if (field.requiredFields != null) {
//       for (final rf in field.requiredFields!) {
//         widgets.add(buildCustomField(rf, value, onChanged));
//       }
//     }
//
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
//   }
//
//   // nếu là Map json lẻ rơi vào
//   if (fieldOrGroup is Map<String, dynamic>) {
//     return buildCustomField(
//         CustomField.fromJson(fieldOrGroup), value, onChanged);
//   }
//
//   return SizedBox.shrink();
// }
