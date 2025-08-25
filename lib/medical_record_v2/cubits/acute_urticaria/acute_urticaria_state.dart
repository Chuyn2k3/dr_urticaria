import 'package:dr_urticaria/medical_record_v2/models/acute_urticaria_record.dart';
import 'package:equatable/equatable.dart';

abstract class AcuteUrticariaState extends Equatable {
  const AcuteUrticariaState();

  @override
  List<Object?> get props => [];
}

class AcuteUrticariaInitial extends AcuteUrticariaState {}

class AcuteUrticariaLoading extends AcuteUrticariaState {}

class AcuteUrticariaSubmitting extends AcuteUrticariaState {}

class AcuteUrticariaUploading extends AcuteUrticariaState {}

class AcuteUrticariaLoaded extends AcuteUrticariaState {
  final AcuteUrticariaRecord record;

  const AcuteUrticariaLoaded({required this.record});

  @override
  List<Object?> get props => [record];
}

class AcuteUrticariaSubmitted extends AcuteUrticariaState {
  final String formId;
  final String message;

  const AcuteUrticariaSubmitted({
    required this.formId,
    required this.message,
  });

  @override
  List<Object?> get props => [formId, message];
}

class AcuteUrticariaImagesUploaded extends AcuteUrticariaState {
  final List<String> imageUrls;

  const AcuteUrticariaImagesUploaded({required this.imageUrls});

  @override
  List<Object?> get props => [imageUrls];
}

class AcuteUrticariaError extends AcuteUrticariaState {
  final String message;

  const AcuteUrticariaError(this.message);

  @override
  List<Object?> get props => [message];
}
