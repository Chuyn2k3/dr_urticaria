// import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
// import 'package:dr_urticaria/di/locator.dart';
// import 'package:dr_urticaria/models/vital_indicator_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../utils/enum/field_type_enum.dart';
// import 'vital_record_detail_state.dart';
//
// Map<String, dynamic> flattenVitalValue(
//     dynamic value, CustomFieldGroup? group, List<CustomField>? fields,
//     {String prefix = ''}) {
//   final result = <String, dynamic>{};
//   if (value == null) return result;
//
//   print(
//       "[VitalRecordDetailCubit] 🔍 Flattening value: $value | prefix: $prefix");
//
//   if (value is! Map<String, dynamic>) {
//     // Xử lý giá trị không phải bản đồ (string, number, list)
//     final key = group?.label ?? fields?.first.label ?? 'field_0';
//     if (value != null && value.toString().isNotEmpty) {
//       final finalKey = prefix.isEmpty ? key : '$prefix.$key';
//       result[finalKey] = value;
//       print(
//           "[VitalRecordDetailCubit] ➡️ Added non-map value: $finalKey=$value");
//     }
//     return result;
//   }
//
//   // Xử lý bản đồ
//   value.forEach((key, val) {
//     if (val == null || (val is String && val.isEmpty)) {
//       print("[VitalRecordDetailCubit] ⛔ Skipped empty value for key: $key");
//       return;
//     }
//
//     final field = fields?.firstWhere(
//       (f) => f.label == key,
//       orElse: () => CustomField(
//         label: key,
//         type: FieldType.unknown,
//       ),
//     );
//     final fieldLabel = field?.label ??
//         group?.label ??
//         'field_${value.keys.toList().indexOf(key)}';
//     final newKey = prefix.isEmpty ? fieldLabel : '$prefix.$fieldLabel';
//
//     if (val is Map<String, dynamic>) {
//       // Làm phẳng đệ quy cho bản đồ lồng nhau
//       final nestedGroup = field?.groups?.firstWhere(
//         (g) => g.label == key,
//         orElse: () => CustomFieldGroup(label: key, fields: []),
//       );
//       final nestedFields = field?.type == FieldType.custom
//           ? field?.groups?.expand((g) => g.fields).toList()
//           : null;
//       final nestedResult =
//           flattenVitalValue(val, nestedGroup, nestedFields, prefix: newKey);
//       result.addAll(nestedResult);
//       print(
//           "[VitalRecordDetailCubit] 🔄 Nested map flattened: $newKey -> $nestedResult");
//     } else if (val != null && val.toString().isNotEmpty) {
//       // Thêm giá trị không rỗng
//       result[newKey] = val;
//       print("[VitalRecordDetailCubit] ➡️ Added value: $newKey=$val");
//     }
//   });
//
//   return result;
// }
//
// class VitalRecordDetailCubit extends Cubit<VitalRecordDetailState> {
//   final repo = serviceLocator<VitalRecordRepository>();
//   final int medicalRecordId;
//
//   VitalRecordDetailCubit({required this.medicalRecordId})
//       : super(const VitalRecordDetailState());
//
//   Future<void> load() async {
//     print(
//         "[VitalRecordDetailCubit] 🔄 Loading medicalRecordId: $medicalRecordId");
//     emit(state.copyWith(loading: true, error: null, success: false));
//     try {
//       final groups = await repo.fetchVitalGroups(medicalRecordId);
//       print("[VitalRecordDetailCubit] ✅ Loaded ${groups.length} groups");
//       emit(state.copyWith(loading: false, groups: groups, success: false));
//     } catch (e) {
//       print("[VitalRecordDetailCubit] ❌ Load error: $e");
//       emit(state.copyWith(loading: false, error: e.toString(), success: false));
//     }
//   }
//
//   void editValue({required int vitalValueId, required dynamic newValue}) {
//     print(
//         "[VitalRecordDetailCubit] ✏️ Editing value: vitalValueId=$vitalValueId | newValue=$newValue");
//     final map = Map<int, dynamic>.from(state.editedValues);
//     map[vitalValueId] = newValue;
//     emit(state.copyWith(editedValues: map, success: false));
//     print("[VitalRecordDetailCubit] 📊 Current editedValues: ${map}");
//   }
//
//   void editNote({required int vitalValueId, String? note}) {
//     print(
//         "[VitalRecordDetailCubit] ✏️ Editing note: vitalValueId=$vitalValueId | note=$note");
//     final map = Map<int, String?>.from(state.editedNotes);
//     map[vitalValueId] = note;
//     emit(state.copyWith(editedNotes: map, success: false));
//     print("[VitalRecordDetailCubit] 📊 Current editedNotes: ${map}");
//   }
//
//   Future<void> saveAll() async {
//     if (state.editedValues.isEmpty && state.editedNotes.isEmpty) {
//       print("[VitalRecordDetailCubit] ⛔ No changes to save");
//       return;
//     }
//
//     // ✅ Validate required fields
//     for (final group in state.groups) {
//       for (final item in group.items) {
//         final indicator = item.indicator;
//
//         if (indicator.valueOptions != null) {
//           final options = indicator.valueOptions;
//
//           // Chỉ parse nếu options là List<Map>
//           if (options is List &&
//               options.isNotEmpty &&
//               options.first is Map<String, dynamic>) {
//             final customField = CustomField.fromJson({'fields': options});
//             for (final g in customField.groups ?? []) {
//               for (final f in g.fields) {
//                 if (f.requiredFields?.isNotEmpty == true) {
//                   final key =
//                       f.label ?? g.label ?? 'field_${g.fields.indexOf(f)}';
//                   final value =
//                       state.editedValues[item.value.id] ?? item.value.value;
//                   if (value == null || (value is String && value.isEmpty)) {
//                     emit(state.copyWith(
//                       loading: false,
//                       error: 'Vui lòng điền trường bắt buộc: $key',
//                       success: false,
//                     ));
//                     return;
//                   }
//                 }
//               }
//             }
//           } else {
//             print(
//                 "[VitalRecordDetailCubit] ⚠️ Skip parsing valueOptions vì không phải List<Map>: $options");
//           }
//         }
//       }
//     }
//
//     print(
//         "[VitalRecordDetailCubit] 🚀 Starting saveAll for medicalRecordId: $medicalRecordId");
//     print("[VitalRecordDetailCubit] 📋 Edited values: ${state.editedValues}");
//     print("[VitalRecordDetailCubit] 📝 Edited notes: ${state.editedNotes}");
//
//     emit(state.copyWith(loading: true, error: null, success: false));
//
//     try {
//       final vitalValues = <Map<String, dynamic>>[];
//       final allVitalIds = {
//         ...state.editedValues.keys,
//         ...state.editedNotes.keys
//       };
//
//       for (final vitalId in allVitalIds) {
//         print("[VitalRecordDetailCubit] 🔎 Processing vitalId: $vitalId");
//
//         final item = state.groups.expand((g) => g.items).firstWhere(
//             (item) => item.value.vitalIndicatorId == vitalId, orElse: () {
//           print(
//               "[VitalRecordDetailCubit] ❌ Item not found for vitalId: $vitalId");
//           throw Exception('Không tìm thấy item với vitalId: $vitalId');
//         });
//
//         final indicator = item.indicator;
//         final value = state.editedValues[vitalId] ?? item.value.value;
//         print("[VitalRecordDetailCubit] 📌 Value for vitalId $vitalId: $value");
//
//         final flattenedValue = indicator.valueType == 'custom'
//             ? flattenVitalValue(
//                 value,
//                 CustomFieldGroup(label: indicator.group?.name, fields: []),
//                 (indicator.valueOptions is List &&
//                         indicator.valueOptions.isNotEmpty &&
//                         indicator.valueOptions.first is Map<String, dynamic>)
//                     ? CustomField.fromJson({'fields': indicator.valueOptions})
//                         .groups
//                         ?.expand((g) => g.fields)
//                         .toList()
//                     : null,
//               )
//             : value;
//
//         print(
//             "[VitalRecordDetailCubit] ➡️ Flattened value for vitalId $vitalId: $flattenedValue");
//
//         vitalValues.add({
//           'vitalIndicatorId': item.value.vitalIndicatorId,
//           'value': flattenedValue,
//           'note': state.editedNotes[vitalId] ?? item.value.note,
//         });
//       }
//
//       final payload = {'vitalValues': vitalValues};
//       print("[VitalRecordDetailCubit] 📤 Sending payload to API: $payload");
//
//       await repo.updateVitalValues(
//         medicalRecordId: medicalRecordId,
//         vitalValues: payload,
//       );
//
//       print("[VitalRecordDetailCubit] ✅ Save successful");
//       emit(state.copyWith(
//           loading: false, editedValues: {}, editedNotes: {}, success: true));
//
//       print("[VitalRecordDetailCubit] 🔄 Reloading data after save");
//       await load();
//     } catch (e) {
//       print("[VitalRecordDetailCubit] ❌ Save error: $e");
//       emit(state.copyWith(loading: false, error: e.toString(), success: false));
//     }
//   }
// }
////////////////////////////////
// import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
// import 'package:dr_urticaria/di/locator.dart';
// import 'package:dr_urticaria/models/vital_indicator_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../utils/enum/field_type_enum.dart';
// import 'vital_record_detail_state.dart';

// /// Hàm flatten dữ liệu custom field theo quy tắc key
// Map<String, dynamic> flattenCustomFieldValue(
//   Map<String, dynamic> value,
//   List<CustomFieldGroup>? groups, {
//   String prefix = '',
// }) {
//   final result = <String, dynamic>{};

//   print("[flattenCustomFieldValue] 🔍 Input value: $value");
//   print(
//       "[flattenCustomFieldValue] 🔍 Groups: ${groups?.map((g) => g.label).toList()}");

//   // Nếu không có groups, làm phẳng toàn bộ value
//   if (groups == null || groups.isEmpty) {
//     value.forEach((key, val) {
//       final newKey = prefix.isEmpty ? key : '$prefix.$key';
//       if (val is Map<String, dynamic>) {
//         result.addAll(flattenCustomFieldValue(val, null, prefix: newKey));
//       } else if (val != null && !_isEmpty(val)) {
//         result[newKey] = val;
//       }
//     });
//     print("[flattenCustomFieldValue] ✅ No groups, result: $result");
//     return result;
//   }

//   // Duyệt qua groups và fields
//   for (int groupIndex = 0; groupIndex < groups.length; groupIndex++) {
//     final group = groups[groupIndex];
//     final groupLabel = group.label?.trim();

//     for (int fieldIndex = 0; fieldIndex < group.fields.length; fieldIndex++) {
//       final field = group.fields[fieldIndex];
//       final fieldLabel =
//           field.label?.trim() ?? groupLabel ?? 'field_$fieldIndex';
//       final fullKey = prefix.isEmpty ? fieldLabel : '$prefix.$fieldLabel';

//       // Tìm giá trị từ value, không cần _findValueInNestedMap
//       dynamic fieldValue = value[fieldLabel];
//       if (fieldValue == null && groupLabel != null) {
//         // Thử tìm trong nhóm lồng nhau
//         fieldValue = value[groupLabel]?.containsKey(fieldLabel) == true
//             ? value[groupLabel][fieldLabel]
//             : null;
//       }

//       if (fieldValue != null && !_isEmpty(fieldValue)) {
//         if (field.type == FieldType.custom &&
//             fieldValue is Map<String, dynamic>) {
//           // Đệ quy cho custom field
//           final nestedResult = flattenCustomFieldValue(
//             fieldValue,
//             field.groups,
//             prefix: fullKey,
//           );
//           result.addAll(nestedResult);
//           print(
//               "[flattenCustomFieldValue] 🔄 Nested result for $fullKey: $nestedResult");
//         } else {
//           result[fullKey] = fieldValue;
//           print("[flattenCustomFieldValue] ➡️ Added: $fullKey = $fieldValue");
//         }
//       } else {
//         print("[flattenCustomFieldValue] ⛔ Skipped empty value for: $fullKey");
//       }
//     }
//   }

//   // Xử lý các giá trị còn lại trong value không có trong groups
//   value.forEach((key, val) {
//     final fullKey = prefix.isEmpty ? key : '$prefix.$key';
//     if (!result.containsKey(fullKey) && val != null && !_isEmpty(val)) {
//       if (val is Map<String, dynamic>) {
//         result.addAll(flattenCustomFieldValue(val, null, prefix: fullKey));
//       } else {
//         result[fullKey] = val;
//       }
//     }
//   });

//   print("[flattenCustomFieldValue] ✅ Final result: $result");
//   return result;
// }

// /// Tìm giá trị trong nested map theo key path (giờ không cần thiết vì đã đổi logic)
// dynamic _findValueInNestedMap(Map<String, dynamic> map, String keyPath) {
//   final parts = keyPath.split('.');
//   dynamic current = map;

//   for (final part in parts) {
//     if (current is Map<String, dynamic> && current.containsKey(part)) {
//       current = current[part];
//     } else {
//       return null;
//     }
//   }

//   return current;
// }

// /// Kiểm tra giá trị có rỗng không
// bool _isEmpty(dynamic value) {
//   if (value == null) return true;
//   if (value is String) return value.trim().isEmpty;
//   if (value is List) return value.isEmpty;
//   if (value is Map) return value.isEmpty;
//   return false;
// }

// class VitalRecordDetailCubit extends Cubit<VitalRecordDetailState> {
//   final repo = serviceLocator<VitalRecordRepository>();
//   final int medicalRecordId;

//   VitalRecordDetailCubit({required this.medicalRecordId})
//       : super(const VitalRecordDetailState());

//   Future<void> load() async {
//     print(
//         "[VitalRecordDetailCubit] 🔄 Loading medicalRecordId: $medicalRecordId");
//     emit(state.copyWith(loading: true, error: null, success: false));
//     try {
//       final groups = await repo.fetchVitalGroups(medicalRecordId);
//       print("[VitalRecordDetailCubit] ✅ Loaded ${groups.length} groups");
//       emit(state.copyWith(loading: false, groups: groups, success: false));
//     } catch (e) {
//       print("[VitalRecordDetailCubit] ❌ Load error: $e");
//       emit(state.copyWith(loading: false, error: e.toString(), success: false));
//     }
//   }

//   void editValue({required int vitalValueId, required dynamic newValue}) {
//     print(
//         "[VitalRecordDetailCubit] ✏️ Editing value: vitalValueId=$vitalValueId | newValue=$newValue");
//     final map = Map<int, dynamic>.from(state.editedValues);
//     map[vitalValueId] = newValue;
//     emit(state.copyWith(editedValues: map, success: false));
//     print("[VitalRecordDetailCubit] 📊 Current editedValues: $map");
//   }

//   void editNote({required int vitalValueId, String? note}) {
//     print(
//         "[VitalRecordDetailCubit] ✏️ Editing note: vitalValueId=$vitalValueId | note=$note");
//     final map = Map<int, String?>.from(state.editedNotes);
//     map[vitalValueId] = note;
//     emit(state.copyWith(editedNotes: map, success: false));
//     print("[VitalRecordDetailCubit] 📊 Current editedNotes: $map");
//   }

//   Future<void> saveAll() async {
//     if (state.editedValues.isEmpty && state.editedNotes.isEmpty) {
//       print("[VitalRecordDetailCubit] ⛔ No changes to save");
//       return;
//     }

//     print(
//         "[VitalRecordDetailCubit] 🚀 Starting saveAll for medicalRecordId: $medicalRecordId");
//     print("[VitalRecordDetailCubit] 📋 Edited values: ${state.editedValues}");
//     print("[VitalRecordDetailCubit] 📝 Edited notes: ${state.editedNotes}");

//     emit(state.copyWith(loading: true, error: null, success: false));

//     try {
//       final vitalValues = <Map<String, dynamic>>[];
//       final allVitalIds = {
//         ...state.editedValues.keys,
//         ...state.editedNotes.keys
//       };

//       for (final vitalId in allVitalIds) {
//         print("[VitalRecordDetailCubit] 🔎 Processing vitalId: $vitalId");

//         final item = state.groups.expand((g) => g.items).firstWhere(
//           (item) => item.value.vitalIndicatorId == vitalId,
//           orElse: () {
//             print(
//                 "[VitalRecordDetailCubit] ❌ Item not found for vitalValueId: $vitalId");
//             throw Exception('Không tìm thấy item với vitalValueId: $vitalId');
//           },
//         );

//         final indicator = item.indicator;
//         final rawValue = state.editedValues[vitalId] ?? item.value.value;

//         print(
//             "[VitalRecordDetailCubit] 📌 Raw value for vitalId $vitalId: $rawValue");
//         print(
//             "[VitalRecordDetailCubit] 📌 Indicator type: ${indicator.valueType}");

//         dynamic processedValue;

//         if (indicator.valueType == 'custom' &&
//             rawValue is Map<String, dynamic>) {
//           List<CustomFieldGroup>? customGroups;

//           if (indicator.valueOptions != null) {
//             try {
//               if (indicator.valueOptions is List &&
//                   indicator.valueOptions.isNotEmpty &&
//                   indicator.valueOptions.first is Map<String, dynamic>) {
//                 final customField =
//                     CustomField.fromJson({'fields': indicator.valueOptions});
//                 customGroups = customField.groups;
//               } else if (indicator.valueOptions is Map<String, dynamic>) {
//                 final customField =
//                     CustomField.fromJson(indicator.valueOptions);
//                 customGroups = customField.groups;
//               }
//             } catch (e) {
//               print(
//                   "[VitalRecordDetailCubit] ⚠️ Error parsing custom field: $e");
//             }
//           }

//           processedValue = flattenCustomFieldValue(rawValue, customGroups);
//         } else if (indicator.valueType == 'multi_selection' &&
//             rawValue is List) {
//           processedValue = rawValue
//               .where((v) => v != null && v.toString().trim().isNotEmpty)
//               .toList();
//         } else {
//           processedValue = rawValue;
//         }

//         print(
//             "[VitalRecordDetailCubit] ➡️ Processed value for vitalId $vitalId: $processedValue");

//         if (!_isEmpty(processedValue)) {
//           vitalValues.add({
//             'vitalIndicatorId': item.value.vitalIndicatorId,
//             'value': processedValue,
//             'note': state.editedNotes[vitalId] ?? item.value.note,
//           });
//         }
//       }

//       final payload = {'vitalValues': vitalValues};
//       print("[VitalRecordDetailCubit] 📤 Sending payload to API:");
//       print("╔ Body");
//       print("╟ vitalValues:");
//       print("║ ${vitalValues.map((v) => '$v').join('\n║ ')}");

//       await repo.updateVitalValues(
//         medicalRecordId: medicalRecordId,
//         vitalValues: payload,
//       );

//       print("[VitalRecordDetailCubit] ✅ Save successful");
//       emit(state.copyWith(
//           loading: false, editedValues: {}, editedNotes: {}, success: true));

//       print("[VitalRecordDetailCubit] 🔄 Reloading data after save");
//       await load();
//     } catch (e) {
//       print("[VitalRecordDetailCubit] ❌ Save error: $e");
//       emit(state.copyWith(loading: false, error: e.toString(), success: false));
//     }
//   }
// }

//////////////
// import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
// import 'package:dr_urticaria/di/locator.dart';
// import 'package:dr_urticaria/models/vital_indicator_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../utils/enum/field_type_enum.dart';
// import 'vital_record_detail_state.dart';

// /// ---------------------------------------------------------------------------
// /// Làm phẳng custom value theo chuẩn phía bệnh nhân:
// /// - Ưu tiên key phẳng 'Group.Field'
// /// - Ảnh cho select: 'Group.Field_image'
// /// - MultiSelection có ảnh: giữ Map<option, url|null>
// /// ---------------------------------------------------------------------------
// Map<String, dynamic> flattenCustomFieldValue(
//   Map<String, dynamic> value,
//   List<CustomFieldGroup>? groups, {
//   String prefix = '',
// }) {
//   final result = <String, dynamic>{};

//   // Không có groups => làm phẳng tổng quát (giữ dot-keys)
//   if (groups == null || groups.isEmpty) {
//     value.forEach((key, val) {
//       final newKey = prefix.isEmpty ? key : '$prefix.$key';
//       if (val is Map<String, dynamic>) {
//         result.addAll(flattenCustomFieldValue(val, null, prefix: newKey));
//       } else if (val != null && !_isEmpty(val)) {
//         result[newKey] = val;
//       }
//     });
//     return result;
//   }

//   for (final group in groups) {
//     final groupLabel = group.label?.trim() ?? '';

//     for (int fieldIndex = 0; fieldIndex < group.fields.length; fieldIndex++) {
//       final field = group.fields[fieldIndex];
//       final fieldLabel = field.label?.trim() ??
//           (groupLabel.isNotEmpty ? groupLabel : 'field_$fieldIndex');

//       final dotKey =
//           groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;

//       // Tìm giá trị trong 3 kiểu: fieldLabel | value[groupLabel][fieldLabel] | dotKey
//       dynamic fieldValue = value[fieldLabel];

//       if (fieldValue == null && groupLabel.isNotEmpty) {
//         final g = value[groupLabel];
//         if (g is Map && g.containsKey(fieldLabel)) {
//           fieldValue = g[fieldLabel];
//         }
//       }
//       if (fieldValue == null && value.containsKey(dotKey)) {
//         fieldValue = value[dotKey];
//       }

//       if (fieldValue != null && !_isEmpty(fieldValue)) {
//         if (field.type == FieldType.custom &&
//             fieldValue is Map<String, dynamic>) {
//           final nested = flattenCustomFieldValue(
//             fieldValue,
//             field.groups,
//             prefix: dotKey,
//           );
//           result.addAll(nested);
//         } else if (field.type == FieldType.select && fieldValue is Map) {
//           // Bệnh nhân đôi khi gửi {"FieldLabel": "...", "FieldLabel_image": "..."}
//           final inner = fieldValue[fieldLabel];
//           if (inner != null && !_isEmpty(inner)) {
//             result[dotKey] = inner;
//           }
//           final imgKey = '${fieldLabel}_image';
//           if (fieldValue.containsKey(imgKey) && !_isEmpty(fieldValue[imgKey])) {
//             result['${dotKey}_image'] = fieldValue[imgKey];
//           }
//         } else {
//           result[dotKey] = fieldValue;
//         }
//       }
//     }
//   }

//   // Các key còn lại mà chưa capture trong groups -> vẫn đưa vào (đảm bảo không mất data)
//   value.forEach((key, val) {
//     final fullKey = prefix.isEmpty ? key : '$prefix.$key';
//     if (!result.containsKey(fullKey) && val != null && !_isEmpty(val)) {
//       if (val is Map<String, dynamic>) {
//         result.addAll(flattenCustomFieldValue(val, null, prefix: fullKey));
//       } else {
//         result[fullKey] = val;
//       }
//     }
//   });

//   return result;
// }

// bool _isEmpty(dynamic value) {
//   if (value == null) return true;
//   if (value is String) return value.trim().isEmpty;
//   if (value is List) return value.isEmpty;
//   if (value is Map) return value.isEmpty;
//   return false;
// }

// class VitalRecordDetailCubit extends Cubit<VitalRecordDetailState> {
//   final repo = serviceLocator<VitalRecordRepository>();
//   final int medicalRecordId;

//   VitalRecordDetailCubit({required this.medicalRecordId})
//       : super(const VitalRecordDetailState());

//   Future<void> load() async {
//     emit(state.copyWith(loading: true, error: null, success: false));
//     try {
//       final groups = await repo.fetchVitalGroups(medicalRecordId);
//       emit(state.copyWith(loading: false, groups: groups, success: false));
//     } catch (e) {
//       emit(state.copyWith(loading: false, error: e.toString(), success: false));
//     }
//   }

//   void editValue({required int vitalValueId, required dynamic newValue}) {
//     final map = Map<int, dynamic>.from(state.editedValues);
//     map[vitalValueId] = newValue;
//     emit(state.copyWith(editedValues: map, success: false));
//   }

//   void editNote({required int vitalValueId, String? note}) {
//     final map = Map<int, String?>.from(state.editedNotes);
//     map[vitalValueId] = note;
//     emit(state.copyWith(editedNotes: map, success: false));
//   }

//   Future<void> saveAll() async {
//     if (state.editedValues.isEmpty && state.editedNotes.isEmpty) {
//       return;
//     }

//     emit(state.copyWith(loading: true, error: null, success: false));

//     try {
//       final vitalValues = <Map<String, dynamic>>[];
//       final allVitalIds = {
//         ...state.editedValues.keys,
//         ...state.editedNotes.keys
//       };

//       for (final vitalId in allVitalIds) {
//         final item = state.groups.expand((g) => g.items).firstWhere(
//               (item) => item.value.vitalIndicatorId == vitalId,
//               orElse: () => throw Exception(
//                   'Không tìm thấy item với vitalValueId: $vitalId'),
//             );

//         final indicator = item.indicator;
//         final rawValue = state.editedValues[vitalId] ?? item.value.value;

//         dynamic processedValue;

//         if (indicator.valueType == 'custom' &&
//             rawValue is Map<String, dynamic>) {
//           List<CustomFieldGroup>? customGroups;

//           if (indicator.valueOptions != null) {
//             try {
//               if (indicator.valueOptions is List &&
//                   indicator.valueOptions.isNotEmpty &&
//                   indicator.valueOptions.first is Map<String, dynamic>) {
//                 final customField =
//                     CustomField.fromJson({'fields': indicator.valueOptions});
//                 customGroups = customField.groups;
//               } else if (indicator.valueOptions is Map<String, dynamic>) {
//                 final customField =
//                     CustomField.fromJson(indicator.valueOptions);
//                 customGroups = customField.groups;
//               }
//             } catch (_) {}
//           }

//           processedValue = flattenCustomFieldValue(rawValue, customGroups);
//         } else if (indicator.valueType == 'multi_selection' &&
//             rawValue is List) {
//           processedValue = rawValue
//               .where((v) => v != null && v.toString().trim().isNotEmpty)
//               .toList();
//         } else {
//           processedValue = rawValue;
//         }

//         if (!_isEmpty(processedValue)) {
//           vitalValues.add({
//             'vitalIndicatorId': item.value.vitalIndicatorId,
//             'value': processedValue,
//             'note': state.editedNotes[vitalId] ?? item.value.note,
//           });
//         }
//       }

//       final payload = {'vitalValues': vitalValues};

//       await repo.updateVitalValues(
//         medicalRecordId: medicalRecordId,
//         vitalValues: payload,
//       );

//       emit(state.copyWith(
//         loading: false,
//         editedValues: {},
//         editedNotes: {},
//         success: true,
//       ));

//       await load();
//     } catch (e) {
//       emit(state.copyWith(loading: false, error: e.toString(), success: false));
//     }
//   }
// }
import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/models/vital_indicator_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/enum/field_type_enum.dart';
import 'vital_record_detail_state.dart';

/// Làm phẳng custom theo chuẩn PHẲNG từ app bệnh nhân:
/// - Key phẳng 'Group.Field'
/// - Select có ảnh: thêm 'Group.Field_image'
/// - MultiSelection có ảnh: giữ Map<option, url|null>
/// - Backward-compat: nếu gặp dữ liệu cũ dạng lồng { Field: "...", Field_image: "..." } thì chuyển về phẳng.
Map<String, dynamic> flattenCustomFieldValue(
  Map<String, dynamic> value,
  List<CustomFieldGroup>? groups, {
  String prefix = '',
}) {
  final result = <String, dynamic>{};

  if (groups == null || groups.isEmpty) {
    value.forEach((key, val) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (val is Map<String, dynamic>) {
        result.addAll(flattenCustomFieldValue(val, null, prefix: newKey));
      } else if (val != null && !_isEmpty(val)) {
        result[newKey] = val;
      }
    });
    return result;
  }

  for (final group in groups) {
    final groupLabel = group.label?.trim() ?? '';

    for (int fieldIndex = 0; fieldIndex < group.fields.length; fieldIndex++) {
      final field = group.fields[fieldIndex];
      final fieldLabel = field.label?.trim() ??
          (groupLabel.isNotEmpty ? groupLabel : 'field_$fieldIndex');

      final dotKey =
          groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;

      // Tìm trong: fieldLabel | value[groupLabel][fieldLabel] | dotKey
      dynamic fieldValue = value[fieldLabel];

      if (fieldValue == null && groupLabel.isNotEmpty) {
        final g = value[groupLabel];
        if (g is Map && g.containsKey(fieldLabel)) {
          fieldValue = g[fieldLabel];
        }
      }
      if (fieldValue == null && value.containsKey(dotKey)) {
        fieldValue = value[dotKey];
      }

      if (fieldValue != null && !_isEmpty(fieldValue)) {
        if (field.type == FieldType.custom &&
            fieldValue is Map<String, dynamic>) {
          final nested = flattenCustomFieldValue(
            fieldValue,
            field.groups,
            prefix: dotKey,
          );
          result.addAll(nested);
        } else if (field.type == FieldType.select && fieldValue is Map) {
          // Dạng cũ: {"Field": "...", "Field_image": "..."} -> về phẳng
          final inner = fieldValue[fieldLabel];
          if (inner != null && !_isEmpty(inner)) {
            result[dotKey] = inner;
          }
          final imgKey = '${fieldLabel}_image';
          if (fieldValue.containsKey(imgKey) && !_isEmpty(fieldValue[imgKey])) {
            result['${dotKey}_image'] = fieldValue[imgKey];
          }
        } else {
          // Dạng mới phẳng (chuẩn): String / List / Map<option,url|null> / URL (image-only)
          result[dotKey] = fieldValue;
        }
      }
    }
  }

  // Bảo toàn các key còn lại (đảm bảo không mất dữ liệu như key_image)
  value.forEach((key, val) {
    final fullKey = prefix.isEmpty ? key : '$prefix.$key';
    if (!result.containsKey(fullKey) && val != null && !_isEmpty(val)) {
      if (val is Map<String, dynamic>) {
        result.addAll(flattenCustomFieldValue(val, null, prefix: fullKey));
      } else {
        result[fullKey] = val;
      }
    }
  });

  return result;
}

bool _isEmpty(dynamic value) {
  if (value == null) return true;
  if (value is String) return value.trim().isEmpty;
  if (value is List) return value.isEmpty;
  if (value is Map) return value.isEmpty;
  return false;
}

class VitalRecordDetailCubit extends Cubit<VitalRecordDetailState> {
  final repo = serviceLocator<VitalRecordRepository>();
  final int medicalRecordId;

  VitalRecordDetailCubit({required this.medicalRecordId})
      : super(const VitalRecordDetailState());

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null, success: false));
    try {
      final groups = await repo.fetchVitalGroups(medicalRecordId);
      emit(state.copyWith(loading: false, groups: groups, success: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), success: false));
    }
  }

  void editValue({required int vitalValueId, required dynamic newValue}) {
    final map = Map<int, dynamic>.from(state.editedValues);
    map[vitalValueId] = newValue;
    emit(state.copyWith(editedValues: map, success: false));
  }

  void editNote({required int vitalValueId, String? note}) {
    final map = Map<int, String?>.from(state.editedNotes);
    map[vitalValueId] = note;
    emit(state.copyWith(editedNotes: map, success: false));
  }

  Future<void> saveAll() async {
    if (state.editedValues.isEmpty && state.editedNotes.isEmpty) {
      return;
    }

    emit(state.copyWith(loading: true, error: null, success: false));

    try {
      final vitalValues = <Map<String, dynamic>>[];
      final allVitalIds = {
        ...state.editedValues.keys,
        ...state.editedNotes.keys
      };

      for (final vitalId in allVitalIds) {
        final item = state.groups.expand((g) => g.items).firstWhere(
              (item) => item.value.vitalIndicatorId == vitalId,
              orElse: () => throw Exception(
                  'Không tìm thấy item với vitalValueId: $vitalId'),
            );

        final indicator = item.indicator;
        final rawValue = state.editedValues[vitalId] ?? item.value.value;

        dynamic processedValue;

        if (indicator.valueType == 'custom' &&
            rawValue is Map<String, dynamic>) {
          List<CustomFieldGroup>? customGroups;

          if (indicator.valueOptions != null) {
            try {
              if (indicator.valueOptions is List &&
                  indicator.valueOptions.isNotEmpty &&
                  indicator.valueOptions.first is Map<String, dynamic>) {
                final customField =
                    CustomField.fromJson({'fields': indicator.valueOptions});
                customGroups = customField.groups;
              } else if (indicator.valueOptions is Map<String, dynamic>) {
                final customField =
                    CustomField.fromJson(indicator.valueOptions);
                customGroups = customField.groups;
              }
            } catch (_) {}
          }

          processedValue = flattenCustomFieldValue(rawValue, customGroups);
        } else if (indicator.valueType == 'multi_selection' &&
            rawValue is List) {
          processedValue = rawValue
              .where((v) => v != null && v.toString().trim().isNotEmpty)
              .toList();
        } else {
          // select image-only / select không ảnh / multi-selection có ảnh (Map) / boolean / number / text
          processedValue = rawValue;
        }

        if (!_isEmpty(processedValue)) {
          vitalValues.add({
            'vitalIndicatorId': item.value.vitalIndicatorId,
            'value': processedValue,
            'note': state.editedNotes[vitalId] ?? item.value.note,
          });
        }
      }

      final payload = {'vitalValues': vitalValues};

      await repo.updateVitalValues(
        medicalRecordId: medicalRecordId,
        vitalValues: payload,
      );

      emit(state.copyWith(
        loading: false,
        editedValues: {},
        editedNotes: {},
        success: true,
      ));

      await load();
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), success: false));
    }
  }
}
