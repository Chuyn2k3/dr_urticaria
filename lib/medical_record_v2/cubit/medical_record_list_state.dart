import 'package:dr_urticaria/models/medical_record_list_item.dart';
import 'package:equatable/equatable.dart';

abstract class MedicalRecordListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MedicalRecordListInitial extends MedicalRecordListState {}

class MedicalRecordListLoading extends MedicalRecordListState {}

class MedicalRecordListSuccess extends MedicalRecordListState {
  final List<MedicalRecordListItem> items;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  MedicalRecordListSuccess({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  MedicalRecordListSuccess copyWith({
    List<MedicalRecordListItem>? items,
    int? total,
    int? page,
    int? limit,
    bool? hasMore,
  }) {
    return MedicalRecordListSuccess(
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

class MedicalRecordListFailure extends MedicalRecordListState {
  final String message;

  MedicalRecordListFailure(this.message);

  @override
  List<Object?> get props => [message];
}
