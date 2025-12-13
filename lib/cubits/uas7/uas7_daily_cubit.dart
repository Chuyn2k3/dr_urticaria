import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_urticaria/core/repositories/uas7_repository.dart';
import 'package:dr_urticaria/models/uas7/uas7_daily_model.dart';

import 'uas7_daily_state.dart';

class Uas7DailyCubit extends Cubit<Uas7DailyState> {
  final Uas7Repository repository;

  Uas7DailyCubit({required this.repository}) : super(const Uas7DailyState());

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> loadPatientRecords(int patientId) async {
    emit(state.copyWith(status: Uas7DailyStatus.loading, clearError: true));
    try {
      final now = DateTime.now();
      final from = DateTime(now.year - 1, 1, 1);
      final to = DateTime(now.year + 1, 12, 31);

      final records = await repository.getDailyByPatient(
        patientId: patientId,
        from: from,
        to: to,
      );

      records.sort((a, b) => a.recordDate.compareTo(b.recordDate));

      emit(state.copyWith(
        status: Uas7DailyStatus.loaded,
        records: records,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Uas7DailyStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void selectDate(DateTime date) {
    final normalized = _normalize(date);
    final rec = state.records.firstWhere(
      (r) => _normalize(r.recordDate) == normalized,
      orElse: () => null as Uas7DailyModel,
    );

    emit(state.copyWith(
      selectedDate: normalized,
      selectedRecord: rec is Uas7DailyModel ? rec : null,
      status: Uas7DailyStatus.loaded,
      clearError: true,
    ));
  }

  Future<void> updateSelectedRecord({
    required int itchLevel,
    required int whealLevel,
    String? note,
  }) async {
    final current = state.selectedRecord;
    if (current == null) return;

    emit(state.copyWith(status: Uas7DailyStatus.updating, clearError: true));
    try {
      final updated = await repository.updateDaily(
        id: current.id,
        itchLevel: itchLevel,
        whealLevel: whealLevel,
        note: note,
      );

      final newList =
          state.records.map((r) => r.id == updated.id ? updated : r).toList();

      emit(state.copyWith(
        status: Uas7DailyStatus.updated,
        records: newList,
        selectedRecord: updated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Uas7DailyStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// ISS7 + HSS7 trong 7 ngày tính tới selectedDate (nếu có)
  Map<String, int> weekSum() {
    final selected = state.selectedDate;
    if (selected == null) return {'iss7': 0, 'hss7': 0};

    final to = _normalize(selected);
    final from = to.subtract(const Duration(days: 6));

    final window = state.records.where((r) {
      final d = _normalize(r.recordDate);
      return !d.isBefore(from) && !d.isAfter(to);
    }).toList();

    final iss7 = window.fold<int>(0, (s, r) => s + r.itchLevel);
    final hss7 = window.fold<int>(0, (s, r) => s + r.whealLevel);
    return {'iss7': iss7, 'hss7': hss7};
  }

  Set<DateTime> get markedDays =>
      state.records.map((e) => _normalize(e.recordDate)).toSet();
}
