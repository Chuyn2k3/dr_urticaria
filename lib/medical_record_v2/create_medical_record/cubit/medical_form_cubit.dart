import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
import 'package:dr_urticaria/di/locator.dart';

import '../model/medical_record_request.dart';
import '../model/vital_group.dart';
import 'medical_form_state.dart';

class MedicalFormCubit extends Cubit<MedicalFormState> {
  final VitalRecordRepository repository =
      serviceLocator<VitalRecordRepository>();

  MedicalFormCubit() : super(MedicalFormInitial());

  Future<void> loadMedicalForm(int templateId) async {
    emit(MedicalFormLoading());
    try {
      final templateRes = await repository.getTemplate(templateId);
      final template = templateRes.data;
      if (template == null) {
        emit(MedicalFormError(
            message: "Không tìm thấy template", groups: [], answers: {}));
        return;
      }

      final futures =
          template.vitalGroupIds.map((id) => repository.getVitalGroup(id));
      final results = await Future.wait(futures);

      final groups = results.map((res) => res.data!).toList();
      final answers = <int, dynamic>{};

      final visibleGroupIds = groups.map((g) => g.id).toSet();

      emit(MedicalFormLoaded(
        groups: groups,
        answers: answers,
        visibleGroupIds: visibleGroupIds,
        visibleIndicatorsInGroup12:
            _computeVisibleIndicatorsInGroup12(answers, groups),
        visibleIndicatorsInGroup27:
            _computeVisibleIndicatorsInGroup27(answers, groups),
      ));
    } catch (e) {
      emit(MedicalFormError(message: e.toString(), groups: [], answers: {}));
    }
  }

  void updateAnswer(int indicatorId, dynamic value) {
    if (state is! MedicalFormLoaded) return;
    final current = state as MedicalFormLoaded;
    final updated = Map<int, dynamic>.from(current.answers);

    updated[indicatorId] = value;

    final visibleGroupIds = _computeVisibleGroupIds(updated, current.groups);
    final visible12 =
        _computeVisibleIndicatorsInGroup12(updated, current.groups);
    final visible27 =
        _computeVisibleIndicatorsInGroup27(updated, current.groups);

    emit(current.copyWith(
      answers: updated,
      visibleGroupIds: visibleGroupIds,
      visibleIndicatorsInGroup12: visible12,
      visibleIndicatorsInGroup27: visible27,
    ));
  }

  Future<void> submitMedicalRecord({
    required int templateId,
    required int patientId,
  }) async {
    if (state is! MedicalFormLoaded) return;
    final current = state as MedicalFormLoaded;

    emit(MedicalFormSubmitting(
      groups: current.groups,
      answers: current.answers,
      visibleGroupIds: current.visibleGroupIds,
      visibleIndicatorsInGroup12: current.visibleIndicatorsInGroup12,
      visibleIndicatorsInGroup27: current.visibleIndicatorsInGroup27,
    ));

    try {
      final vitalValues = current.groups.expand((group) {
        return group.indicators.where((indicator) {
          final value = current.answers[indicator.id];
          return value != null;
        }).map((indicator) {
          final value = current.answers[indicator.id];
          return VitalValueRequest(
            vitalIndicatorId: indicator.id,
            groupId: group.id,
            value: value, // giữ shape như hiện có (string/number/map)
            note: null,
          );
        });
      }).toList();

      final request = MedicalRecordRequest(
        templateId: templateId,
        patientId: patientId,
        vitalValues: vitalValues,
      );

      final res = await repository.createMedicalRecord(request);

      emit(MedicalFormSubmittedSuccess(
        groups: current.groups,
        answers: current.answers,
        visibleGroupIds: current.visibleGroupIds,
        visibleIndicatorsInGroup12: current.visibleIndicatorsInGroup12,
        visibleIndicatorsInGroup27: current.visibleIndicatorsInGroup27,
        response: res,
      ));
    } catch (e) {
      emit(MedicalFormError(
          message: e.toString(),
          groups: current.groups,
          answers: current.answers));
    }
  }

  // ===== Visibility rules (giống logic bạn đang dùng) =====
  Set<int> _computeVisibleGroupIds(
      Map<int, dynamic> answers, List<VitalGroup> groups) {
    final indicator192 = answers[192] as String?;
    final indicator62 = answers[62] as String?;

    final visibleGroupIds = groups.map((g) => g.id).toSet();

    if (indicator192 == "Sẩn phù") {
      visibleGroupIds.remove(18);
    }
    if (indicator62 == "Sẩn phù") {
      visibleGroupIds.remove(28);
    }
    return visibleGroupIds;
  }

  Set<int> _computeVisibleIndicatorsInGroup12(
      Map<int, dynamic> answers, List<VitalGroup> groups) {
    final indicator192 = answers[192] as String?;
    if (indicator192 == "Phù mạch") {
      return {192};
    }
    try {
      final group12 = groups.firstWhere((g) => g.id == 12);
      return group12.indicators.map((i) => i.id).toSet();
    } catch (_) {
      return {};
    }
  }

  Set<int> _computeVisibleIndicatorsInGroup27(
      Map<int, dynamic> answers, List<VitalGroup> groups) {
    final indicator62 = answers[62] as String?;
    if (indicator62 == "Phù mạch") {
      return {62};
    }
    try {
      final group27 = groups.firstWhere((g) => g.id == 27);
      return group27.indicators.map((i) => i.id).toSet();
    } catch (_) {
      return {};
    }
  }
}
