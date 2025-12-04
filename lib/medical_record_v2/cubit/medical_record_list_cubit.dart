import 'package:dr_urticaria/core/repositories/medical_records_repository.dart';
import 'package:dr_urticaria/models/medical_record_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_urticaria/di/locator.dart';

import 'medical_record_list_state.dart';

class MedicalRecordListCubit extends Cubit<MedicalRecordListState> {
  final MedicalRecordsRepository _repo =
      serviceLocator<MedicalRecordsRepository>();

  bool _isLoadingMore = false;

  MedicalRecordListCubit() : super(MedicalRecordListInitial());

  Future<void> fetch({
    required int page,
    required int limit,
    String? diagnosis,
    String? symptoms,
    String? fullName,
    String? phone,
    int? appointmentId,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
    DateTime? updatedAtFrom,
    DateTime? updatedAtTo,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      emit(MedicalRecordListLoading());
    }

    try {
      final res = await _repo.fetchMedicalRecords(
        MedicalRecordQuery(
          page: page,
          limit: limit,
          diagnosis: diagnosis,
          symptoms: symptoms,
          phone: phone,
          fullName: fullName,
          appointmentId: appointmentId,
          createdAtFrom: createdAtFrom,
          createdAtTo: createdAtTo,
          updatedAtFrom: updatedAtFrom,
          updatedAtTo: updatedAtTo,
        ),
      );

      final hasMore = res.data.length == limit;

      if (state is MedicalRecordListSuccess && isLoadMore) {
        final current = state as MedicalRecordListSuccess;
        emit(current.copyWith(
          items: [...current.items, ...res.data],
          total: res.total,
          page: res.page,
          limit: res.limit,
          hasMore: hasMore,
        ));
      } else {
        emit(MedicalRecordListSuccess(
          items: res.data,
          total: res.total ?? 0,
          page: res.page ?? 1,
          limit: res.limit ?? limit,
          hasMore: hasMore,
        ));
      }
    } catch (e) {
      emit(MedicalRecordListFailure(e.toString()));
    }
  }

  Future<void> refresh({
    required int limit,
    String? diagnosis,
    String? symptoms,
    String? fullName,
    String? phone,
    int? appointmentId,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
    DateTime? updatedAtFrom,
    DateTime? updatedAtTo,
  }) async {
    await fetch(
      page: 1,
      limit: limit,
      diagnosis: diagnosis,
      symptoms: symptoms,
      fullName: fullName,
      phone: phone,
      appointmentId: appointmentId,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
      updatedAtFrom: updatedAtFrom,
      updatedAtTo: updatedAtTo,
    );
  }

  Future<void> loadMore({
    String? diagnosis,
    String? symptoms,
    String? fullName,
    String? phone,
    int? appointmentId,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
    DateTime? updatedAtFrom,
    DateTime? updatedAtTo,
  }) async {
    if (_isLoadingMore) return;
    final current = state;
    if (current is MedicalRecordListSuccess && current.hasMore) {
      _isLoadingMore = true;
      await fetch(
        page: current.page + 1,
        limit: current.limit,
        diagnosis: diagnosis,
        symptoms: symptoms,
        fullName: fullName,
        phone: phone,
        appointmentId: appointmentId,
        createdAtFrom: createdAtFrom,
        createdAtTo: createdAtTo,
        updatedAtFrom: updatedAtFrom,
        updatedAtTo: updatedAtTo,
        isLoadMore: true,
      );
      _isLoadingMore = false;
    }
  }
}
