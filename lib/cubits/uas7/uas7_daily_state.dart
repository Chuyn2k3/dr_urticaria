import 'package:equatable/equatable.dart';
import 'package:dr_urticaria/models/uas7/uas7_daily_model.dart';

enum Uas7DailyStatus {
  initial,
  loading,
  loaded,
  updating,
  updated,
  error,
}

class Uas7DailyState extends Equatable {
  final Uas7DailyStatus status;
  final List<Uas7DailyModel> records;
  final DateTime? selectedDate;
  final Uas7DailyModel? selectedRecord;
  final String? errorMessage;

  const Uas7DailyState({
    this.status = Uas7DailyStatus.initial,
    this.records = const [],
    this.selectedDate,
    this.selectedRecord,
    this.errorMessage,
  });

  Uas7DailyState copyWith({
    Uas7DailyStatus? status,
    List<Uas7DailyModel>? records,
    DateTime? selectedDate,
    Uas7DailyModel? selectedRecord,
    String? errorMessage,
    bool clearError = false,
  }) {
    return Uas7DailyState(
      status: status ?? this.status,
      records: records ?? this.records,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedRecord: selectedRecord ?? this.selectedRecord,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [status, records, selectedDate, selectedRecord, errorMessage];
}
