import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_urticaria/core/repositories/patient_repository.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/models/patient/patient_model.dart';

import 'patient_search_state.dart';

class PatientSearchCubit extends Cubit<PatientSearchState> {
  final PatientRepository repository = serviceLocator<PatientRepository>();

  static const int _limit = 10;

  int _page = 1;
  String? _search;
  String? _phone;
  String? _identityNumber;

  PatientSearchCubit() : super(PatientSearchInitial());

  Future<void> searchPatients({
    String? search,
    String? phone,
    String? identityNumber,
  }) async {
    emit(PatientSearchLoading());
    _page = 1;
    _search = search;
    _phone = phone;
    _identityNumber = identityNumber;

    try {
      final res = await repository.getPatients(
        page: _page,
        limit: _limit,
        search: _search,
        phone: _phone,
        identityNumber: _identityNumber,
      );

      final patients = res.data;
      print(patients.length);
      final total = res.total ?? patients.length;
      final canLoadMore = patients.length < total;

      emit(PatientSearchLoaded(
        patients: patients,
        total: total,
        page: _page,
        canLoadMore: canLoadMore,
      ));
    } catch (e) {
      emit(PatientSearchError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! PatientSearchLoaded) return;
    if (!current.canLoadMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = _page + 1;
      final res = await repository.getPatients(
        page: nextPage,
        limit: _limit,
        search: _search,
        phone: _phone,
        identityNumber: _identityNumber,
      );

      final newPatients = [...current.patients, ...res.data];
      final total = res.total ?? newPatients.length;
      final canLoadMore = newPatients.length < total;

      _page = nextPage;

      emit(current.copyWith(
        patients: newPatients,
        total: total,
        page: nextPage,
        isLoadingMore: false,
        canLoadMore: canLoadMore,
      ));
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}
