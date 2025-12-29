// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
// import 'package:dr_urticaria/di/locator.dart';
//
// import '../model/medical_record_request.dart';
// import '../model/vital_group.dart';
// import 'medical_form_state.dart';
//
// class MedicalFormCubit extends Cubit<MedicalFormState> {
//   final VitalRecordRepository repository =
//       serviceLocator<VitalRecordRepository>();
//
//   MedicalFormCubit() : super(MedicalFormInitial());
//
//   Future<void> loadMedicalForm(int templateId) async {
//     emit(MedicalFormLoading());
//     try {
//       final templateRes = await repository.getTemplate(templateId);
//       final template = templateRes.data;
//       if (template == null) {
//         emit(MedicalFormError(
//             message: "Không tìm thấy template", groups: [], answers: {}));
//         return;
//       }
//
//       final futures =
//           template.vitalGroupIds.map((id) => repository.getVitalGroup(id));
//       final results = await Future.wait(futures);
//
//       final groups = results.map((res) => res.data!).toList();
//       final answers = <int, dynamic>{};
//
//       final visibleGroupIds = groups.map((g) => g.id).toSet();
//
//       emit(MedicalFormLoaded(
//         groups: groups,
//         answers: answers,
//         visibleGroupIds: visibleGroupIds,
//         visibleIndicatorsInGroup12:
//             _computeVisibleIndicatorsInGroup12(answers, groups),
//         visibleIndicatorsInGroup27:
//             _computeVisibleIndicatorsInGroup27(answers, groups),
//       ));
//     } catch (e) {
//       emit(MedicalFormError(message: e.toString(), groups: [], answers: {}));
//     }
//   }
//
//   void updateAnswer(int indicatorId, dynamic value) {
//     if (state is! MedicalFormLoaded) return;
//     final current = state as MedicalFormLoaded;
//     final updated = Map<int, dynamic>.from(current.answers);
//
//     updated[indicatorId] = value;
//
//     final visibleGroupIds = _computeVisibleGroupIds(updated, current.groups);
//     final visible12 =
//         _computeVisibleIndicatorsInGroup12(updated, current.groups);
//     final visible27 =
//         _computeVisibleIndicatorsInGroup27(updated, current.groups);
//
//     emit(current.copyWith(
//       answers: updated,
//       visibleGroupIds: visibleGroupIds,
//       visibleIndicatorsInGroup12: visible12,
//       visibleIndicatorsInGroup27: visible27,
//     ));
//   }
//
//   Future<void> submitMedicalRecord({
//     required int templateId,
//     required int patientId,
//   }) async {
//     if (state is! MedicalFormLoaded) return;
//     final current = state as MedicalFormLoaded;
//
//     emit(MedicalFormSubmitting(
//       groups: current.groups,
//       answers: current.answers,
//       visibleGroupIds: current.visibleGroupIds,
//       visibleIndicatorsInGroup12: current.visibleIndicatorsInGroup12,
//       visibleIndicatorsInGroup27: current.visibleIndicatorsInGroup27,
//     ));
//
//     try {
//       final vitalValues = current.groups.expand((group) {
//         return group.indicators.where((indicator) {
//           final value = current.answers[indicator.id];
//           return value != null;
//         }).map((indicator) {
//           final value = current.answers[indicator.id];
//           return VitalValueRequest(
//             vitalIndicatorId: indicator.id,
//             groupId: group.id,
//             value: value, // giữ shape như hiện có (string/number/map)
//             note: null,
//           );
//         });
//       }).toList();
//
//       final request = MedicalRecordRequest(
//         templateId: templateId,
//         patientId: patientId,
//         vitalValues: vitalValues,
//       );
//
//       final res = await repository.createMedicalRecord(request);
//
//       emit(MedicalFormSubmittedSuccess(
//         groups: current.groups,
//         answers: current.answers,
//         visibleGroupIds: current.visibleGroupIds,
//         visibleIndicatorsInGroup12: current.visibleIndicatorsInGroup12,
//         visibleIndicatorsInGroup27: current.visibleIndicatorsInGroup27,
//         response: res,
//       ));
//     } catch (e) {
//       emit(MedicalFormError(
//           message: e.toString(),
//           groups: current.groups,
//           answers: current.answers));
//     }
//   }
//
//   // ===== Visibility rules (giống logic bạn đang dùng) =====
//   Set<int> _computeVisibleGroupIds(
//       Map<int, dynamic> answers, List<VitalGroup> groups) {
//     final indicator192 = answers[192] as String?;
//     final indicator62 = answers[62] as String?;
//
//     final visibleGroupIds = groups.map((g) => g.id).toSet();
//
//     if (indicator192 == "Sẩn phù") {
//       visibleGroupIds.remove(18);
//     }
//     if (indicator62 == "Sẩn phù") {
//       visibleGroupIds.remove(28);
//     }
//     return visibleGroupIds;
//   }
//
//   Set<int> _computeVisibleIndicatorsInGroup12(
//       Map<int, dynamic> answers, List<VitalGroup> groups) {
//     final indicator192 = answers[192] as String?;
//     if (indicator192 == "Phù mạch") {
//       return {192};
//     }
//     try {
//       final group12 = groups.firstWhere((g) => g.id == 12);
//       return group12.indicators.map((i) => i.id).toSet();
//     } catch (_) {
//       return {};
//     }
//   }
//
//   Set<int> _computeVisibleIndicatorsInGroup27(
//       Map<int, dynamic> answers, List<VitalGroup> groups) {
//     final indicator62 = answers[62] as String?;
//     if (indicator62 == "Phù mạch") {
//       return {62};
//     }
//     try {
//       final group27 = groups.firstWhere((g) => g.id == 27);
//       return group27.indicators.map((i) => i.id).toSet();
//     } catch (_) {
//       return {};
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/models/vital_indicator_model.dart';
import '../../../models/patient/patient_model.dart';
import '../model/medical_record_request.dart';
import '../model/vital_group.dart';
import 'medical_form_state.dart';

class MedicalFormCubit extends Cubit<MedicalFormState> {
  final VitalRecordRepository repository =
      serviceLocator<VitalRecordRepository>();

  MedicalFormCubit() : super(MedicalFormInitial());

  // ✅ Nhận patient model từ ngoài vào, không gọi repo lấy patient
  Future<void> loadMedicalForm(int templateId, {PatientModel? patient}) async {
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

      // answers ban đầu
      Map<int, dynamic> answers = <int, dynamic>{};

      // ✅ Prefill vào answers trước khi emit Loaded
      if (patient != null) {
        answers = _applyPatientPrefillToGroups(
          patient: patient,
          groups: groups,
          currentAnswers: answers,
        );
      }

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
            value: value,
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
        answers: current.answers,
      ));
    }
  }

  // ===================== PREFILL (PATIENT -> BASIC GROUP) =====================

  Map<int, dynamic> _applyPatientPrefillToGroups({
    required PatientModel patient,
    required List<VitalGroup> groups,
    required Map<int, dynamic> currentAnswers,
  }) {
    final prefill = <int, dynamic>{};

    // ✅ Nhóm basic info mà bé đưa: 16, 44, 45
    // (Nếu template khác có thể bổ sung id vào đây)
    final basicGroups =
        groups.where((g) => g.id == 16 || g.id == 44 || g.id == 45);

    for (final g in basicGroups) {
      prefill.addAll(_buildPatientPrefill(
        patient: patient,
        indicators: g.indicators,
      ));
    }

    return _mergePrefillIfEmpty(current: currentAnswers, prefill: prefill);
  }

  Map<int, dynamic> _buildPatientPrefill({
    required PatientModel patient,
    required List<VitalIndicator> indicators,
  }) {
    final out = <int, dynamic>{};

    for (final ind in indicators) {
      final code = ind.code;
      final id = ind.id;

      switch (code) {
        // Họ tên
        case 'NAMEPATIENTV1':
        case 'NAMEMT1':
        case 'HTTK':
          out[id] = patient.fullname;
          break;

        // CCCD
        case 'IDENTITYCARD':
        case 'CCCDMT1':
        case 'CCCDTK':
          out[id] = patient.identityNumber;
          break;

        // Điện thoại
        case 'PHONEV1':
        case 'PHONEMT1':
        case 'PHONETK':
          out[id] = patient.phone;
          break;

        // Ngày sinh (bé đang có code SEXV1 nhưng name là Ngày sinh)
        case 'SEXV1':
        case 'AGEMT1':
        case 'AGETK':
          out[id] = patient.birthday?.toIso8601String();
          break;

        // Giới tính
        case 'SEXV11':
        case 'SEXMT1':
        case 'SEXTK':
          out[id] = _normalizeGender(patient.gender, ind.valueOptions);
          break;

        default:
          break;
      }
    }

    return out;
  }

  Map<int, dynamic> _mergePrefillIfEmpty({
    required Map<int, dynamic> current,
    required Map<int, dynamic> prefill,
  }) {
    bool isEmpty(dynamic v) {
      if (v == null) return true;
      if (v is String) return v.trim().isEmpty;
      if (v is List) return v.isEmpty;
      if (v is Map) return v.isEmpty;
      return false;
    }

    final merged = Map<int, dynamic>.from(current);

    prefill.forEach((id, v) {
      // ✅ chỉ fill khi current rỗng
      if (isEmpty(merged[id]) && !isEmpty(v)) {
        merged[id] = v;
      }
    });

    return merged;
  }

  String? _normalizeGender(String? gender, dynamic options) {
    if (gender == null) return null;
    final s = gender.trim().toLowerCase();

    final normalized = (s == 'nam' || s == 'male' || s == 'm')
        ? 'Nam'
        : (s == 'nữ' || s == 'nu' || s == 'female' || s == 'f')
            ? 'Nữ'
            : null;

    if (normalized == null) return null;

    // nếu options dạng "0.Nam"/"1.Nữ" thì trả đúng option
    if (options is List) {
      for (final o in options) {
        final os = o.toString();
        if (os.contains(normalized)) return os;
      }
    }
    return normalized;
  }

  // ===================== Visibility rules (giống logic cũ) =====================

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
