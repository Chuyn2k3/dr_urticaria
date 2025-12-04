import 'package:dr_urticaria/models/patient/patient_model.dart';

abstract class PatientSearchState {}

class PatientSearchInitial extends PatientSearchState {}

class PatientSearchLoading extends PatientSearchState {}

class PatientSearchLoaded extends PatientSearchState {
  final List<PatientModel> patients;
  final int total;
  final int page;
  final bool isLoadingMore;
  final bool canLoadMore;

  PatientSearchLoaded({
    required this.patients,
    required this.total,
    required this.page,
    this.isLoadingMore = false,
    this.canLoadMore = false,
  });

  PatientSearchLoaded copyWith({
    List<PatientModel>? patients,
    int? total,
    int? page,
    bool? isLoadingMore,
    bool? canLoadMore,
  }) {
    return PatientSearchLoaded(
      patients: patients ?? this.patients,
      total: total ?? this.total,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      canLoadMore: canLoadMore ?? this.canLoadMore,
    );
  }
}

class PatientSearchError extends PatientSearchState {
  final String message;

  PatientSearchError(this.message);
}
