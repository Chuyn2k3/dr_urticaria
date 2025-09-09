import 'package:dr_urticaria/core/repositories/appointments_repository.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/models/appointment_request.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointment_list_state.dart';

class AppointmentListCubit extends Cubit<AppointmentListState> {
  final _repo = serviceLocator<AppointmentsRepository>();
  bool _isLoadingMore = false; // ✅ chặn double load

  AppointmentListCubit() : super(AppointmentListInitial());

  Future<void> fetch(
      {required int page,
      required int limit,
      String? reason,
      AppointmentStatus? status,
      DateTime? from,
      DateTime? to,
      bool isRefresh = false,
      bool isLoadMore = false,
      String orderDirection = "DESC"}) async {
    if (!isLoadMore) {
      emit(AppointmentListLoading());
    }

    try {
      final res = await _repo.fetchAppointments(
        AppointmentsQuery(
            page: page,
            limit: limit,
            reason: reason,
            status: status,
            appointmentDateFrom: from,
            appointmentDateTo: to,
            orderDirection: orderDirection),
      );

      final hasMore = res.data.length == limit;

      if (state is AppointmentListSuccess && isLoadMore) {
        final current = state as AppointmentListSuccess;
        emit(current.copyWith(
          items: [...current.items, ...res.data],
          total: res.total,
          page: res.page,
          limit: res.limit,
          hasMore: hasMore,
        ));
      } else {
        emit(AppointmentListSuccess(
          items: res.data,
          total: res.total ?? 0,
          page: res.page ?? 1,
          limit: res.limit ?? limit,
          hasMore: hasMore,
        ));
      }
    } catch (e) {
      emit(AppointmentListFailure(e.toString()));
    }
  }

  Future<void> refresh({
    required int limit,
    AppointmentStatus? status,
  }) async {
    await fetch(
      page: 1,
      limit: limit,
      status: status,
      isRefresh: true,
    );
  }

  Future<void> loadMore({AppointmentStatus? status}) async {
    if (_isLoadingMore) return;
    final current = state;
    if (current is AppointmentListSuccess && current.hasMore) {
      _isLoadingMore = true;
      await fetch(
        page: current.page + 1,
        limit: current.limit,
        status: status,
        isLoadMore: true,
      );
      _isLoadingMore = false;
    }
  }
}
