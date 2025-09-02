import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vital_record_detail_state.dart';

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
    if (state.editedValues.isEmpty && state.editedNotes.isEmpty) return;

    emit(state.copyWith(loading: true, error: null, success: false));
    try {
      // Chuẩn bị danh sách vitalValues cho API
      final vitalValues = <Map<String, dynamic>>[];
      final allVitalIds = {...state.editedValues.keys, ...state.editedNotes.keys};

      for (final vitalId in allVitalIds) {
        final item = state.groups
            .expand((g) => g.items)
            .firstWhere((item) => item.value.id == vitalId, orElse: () => throw Exception('Không tìm thấy item với vitalId: $vitalId'));

        vitalValues.add({
          'vitalIndicatorId': item.value.vitalIndicatorId,
          'value': {'value': state.editedValues[vitalId] ?? item.value.value?.value},
          'note': state.editedNotes[vitalId] ?? item.value.note,
        });
      }

      // Gửi batch update tới API
      await repo.updateVitalValues(
        medicalRecordId: medicalRecordId,
        vitalValues: {'vitalValues': vitalValues},
      );

      // Xóa các giá trị và ghi chú đã chỉnh sửa sau khi lưu thành công
      emit(state.copyWith(loading: false, editedValues: {}, editedNotes: {}, success: true));

      // Tải lại dữ liệu để phản ánh thay đổi
      await load();
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), success: false));
    }
  }
}