import 'package:dr_urticaria/medical_record_v2/models/chronic_urticaria_initial_record.dart';
import 'package:equatable/equatable.dart';

abstract class ChronicInitialState extends Equatable {
  const ChronicInitialState();

  @override
  List<Object?> get props => [];
}

class ChronicInitialInitial extends ChronicInitialState {}

class ChronicInitialLoading extends ChronicInitialState {}

class ChronicInitialSubmitting extends ChronicInitialState {}

class ChronicInitialUploading extends ChronicInitialState {}

class ChronicInitialLoaded extends ChronicInitialState {
  final ChronicUrticariaInitialRecord record;

  const ChronicInitialLoaded({required this.record});

  @override
  List<Object?> get props => [record];
}

class ChronicInitialSubmitted extends ChronicInitialState {
  final String formId;
  final String message;

  const ChronicInitialSubmitted({
    required this.formId,
    required this.message,
  });

  @override
  List<Object?> get props => [formId, message];
}

class ChronicInitialImagesUploaded extends ChronicInitialState {
  final List<String> imageUrls;

  const ChronicInitialImagesUploaded({required this.imageUrls});

  @override
  List<Object?> get props => [imageUrls];
}

class ChronicInitialError extends ChronicInitialState {
  final String message;

  const ChronicInitialError(this.message);

  @override
  List<Object?> get props => [message];
}
