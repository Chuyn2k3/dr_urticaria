// import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
// import 'package:equatable/equatable.dart';

// class VitalRecordDetailState extends Equatable {
//   final bool loading;
//   final List<VitalRecordGroup> groups;
//   final Map<int, dynamic> editedValues; // key = vitalValueId, value = new value
//   final Map<int, String?> editedNotes; // key = vitalValueId
//   final String? error;
//   final bool success; // Thêm thuộc tính để đánh dấu cập nhật thành công

//   const VitalRecordDetailState({
//     this.loading = false,
//     this.groups = const [],
//     this.editedValues = const {},
//     this.editedNotes = const {},
//     this.error,
//     this.success = false,
//   });

//   VitalRecordDetailState copyWith({
//     bool? loading,
//     List<VitalRecordGroup>? groups,
//     Map<int, dynamic>? editedValues,
//     Map<int, String?>? editedNotes,
//     String? error,
//     bool? success,
//   }) =>
//       VitalRecordDetailState(
//         loading: loading ?? this.loading,
//         groups: groups ?? this.groups,
//         editedValues: editedValues ?? this.editedValues,
//         editedNotes: editedNotes ?? this.editedNotes,
//         error: error,
//         success: success ?? this.success,
//       );

//   @override
//   List<Object?> get props =>
//       [loading, groups, editedValues, editedNotes, error, success];
// }

import 'package:equatable/equatable.dart';
import 'package:dr_urticaria/medical_record_v2/create_medical_record/model/vital_group.dart';

class VitalRecordDetailState extends Equatable {
  final bool loadingForm; // load template + groups
  final bool loadingDetail; // load values existing của medicalRecordId
  final bool saving;

  final List<VitalGroup> groups;

  /// dữ liệu đã có sẵn (từ detail)
  final Map<int, dynamic> initialValues; // key = indicatorId
  final Map<int, String?> initialNotes; // key = indicatorId

  /// dữ liệu user edit
  final Map<int, dynamic> editedValues; // key = indicatorId
  final Map<int, String?> editedNotes; // key = indicatorId

  final String? error;
  final bool success;

  const VitalRecordDetailState({
    this.loadingForm = false,
    this.loadingDetail = false,
    this.saving = false,
    this.groups = const [],
    this.initialValues = const {},
    this.initialNotes = const {},
    this.editedValues = const {},
    this.editedNotes = const {},
    this.error,
    this.success = false,
  });

  bool get loading => loadingForm || loadingDetail || saving;

  VitalRecordDetailState copyWith({
    bool? loadingForm,
    bool? loadingDetail,
    bool? saving,
    List<VitalGroup>? groups,
    Map<int, dynamic>? initialValues,
    Map<int, String?>? initialNotes,
    Map<int, dynamic>? editedValues,
    Map<int, String?>? editedNotes,
    String? error,
    bool? success,
  }) {
    return VitalRecordDetailState(
      loadingForm: loadingForm ?? this.loadingForm,
      loadingDetail: loadingDetail ?? this.loadingDetail,
      saving: saving ?? this.saving,
      groups: groups ?? this.groups,
      initialValues: initialValues ?? this.initialValues,
      initialNotes: initialNotes ?? this.initialNotes,
      editedValues: editedValues ?? this.editedValues,
      editedNotes: editedNotes ?? this.editedNotes,
      error: error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [
        loadingForm,
        loadingDetail,
        saving,
        groups,
        initialValues,
        initialNotes,
        editedValues,
        editedNotes,
        error,
        success,
      ];
}
