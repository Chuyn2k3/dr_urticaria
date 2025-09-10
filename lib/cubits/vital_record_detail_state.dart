import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
import 'package:equatable/equatable.dart';

class VitalRecordDetailState extends Equatable {
  final bool loading;
  final List<VitalRecordGroup> groups;
  final Map<int, dynamic> editedValues; // key = vitalValueId, value = new value
  final Map<int, String?> editedNotes; // key = vitalValueId
  final String? error;
  final bool success; // Thêm thuộc tính để đánh dấu cập nhật thành công

  const VitalRecordDetailState({
    this.loading = false,
    this.groups = const [],
    this.editedValues = const {},
    this.editedNotes = const {},
    this.error,
    this.success = false,
  });

  VitalRecordDetailState copyWith({
    bool? loading,
    List<VitalRecordGroup>? groups,
    Map<int, dynamic>? editedValues,
    Map<int, String?>? editedNotes,
    String? error,
    bool? success,
  }) =>
      VitalRecordDetailState(
        loading: loading ?? this.loading,
        groups: groups ?? this.groups,
        editedValues: editedValues ?? this.editedValues,
        editedNotes: editedNotes ?? this.editedNotes,
        error: error,
        success: success ?? this.success,
      );

  @override
  List<Object?> get props =>
      [loading, groups, editedValues, editedNotes, error, success];
}