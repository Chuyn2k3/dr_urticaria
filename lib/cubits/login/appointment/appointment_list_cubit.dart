import 'package:dr_urticaria/core/repositories/appointments_repository.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/models/appointment_request.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointment_list_state.dart';

class AppointmentListCubit extends Cubit<AppointmentListState> {
  final _repo = serviceLocator<AppointmentsRepository>();

  AppointmentListCubit() : super(AppointmentListInitial());

  Future<void> fetch({
    required int page,
    required int limit,
    String? reason,
    AppointmentStatus? status,
    DateTime? from,
    DateTime? to,
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    // Nếu refresh thì reset về loading
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
        ),
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
          total: res.total,
          page: res.page,
          limit: res.limit,
          hasMore: hasMore,
        ));
      }
    } catch (e) {
      emit(AppointmentListFailure(e.toString()));
    }
  }

  Future<void> refresh({
    required int limit,
    String? reason,
    AppointmentStatus? status,
    DateTime? from,
    DateTime? to,
  }) async {
    await fetch(
      page: 1,
      limit: limit,
      reason: reason,
      status: status,
      from: from,
      to: to,
      isRefresh: true,
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is AppointmentListSuccess && current.hasMore) {
      await fetch(
        page: current.page + 1,
        limit: current.limit,
        isLoadMore: true,
      );
    }
  }
}
