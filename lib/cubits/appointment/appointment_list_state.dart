import 'package:dr_urticaria/models/appointment/appointment_model.dart';
import 'package:equatable/equatable.dart';

abstract class AppointmentListState extends Equatable {
  const AppointmentListState();
  @override
  List<Object?> get props => [];
}

class AppointmentListInitial extends AppointmentListState {}

class AppointmentListLoading extends AppointmentListState {}

class AppointmentListSuccess extends AppointmentListState {
  final List<AppointmentModel> items;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  const AppointmentListSuccess({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  AppointmentListSuccess copyWith({
    List<AppointmentModel>? items,
    int? total,
    int? page,
    int? limit,
    bool? hasMore,
  }) {
    return AppointmentListSuccess(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [items, total, page, limit, hasMore];
}

class AppointmentListFailure extends AppointmentListState {
  final String message;
  const AppointmentListFailure(this.message);

  @override
  List<Object?> get props => [message];
}
