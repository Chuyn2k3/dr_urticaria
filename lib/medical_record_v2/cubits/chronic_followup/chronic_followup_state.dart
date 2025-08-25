import 'package:dr_urticaria/medical_record_v2/models/chronic_urticaria_followup_record.dart';
import 'package:equatable/equatable.dart';

abstract class ChronicFollowupState extends Equatable {
  const ChronicFollowupState();

  @override
  List<Object?> get props => [];
}

class ChronicFollowupInitial extends ChronicFollowupState {}

class ChronicFollowupLoading extends ChronicFollowupState {}

class ChronicFollowupSubmitting extends ChronicFollowupState {}

class ChronicFollowupUploading extends ChronicFollowupState {}

class ChronicFollowupLoaded extends ChronicFollowupState {
  final ChronicUrticariaFollowupRecord record;

  const ChronicFollowupLoaded({required this.record});

  @override
  List<Object?> get props => [record];
}

class ChronicFollowupSubmitted extends ChronicFollowupState {
  final String formId;
  final String message;

  const ChronicFollowupSubmitted({
    required this.formId,
    required this.message,
  });

  @override
  List<Object?> get props => [formId, message];
}

class ChronicFollowupImagesUploaded extends ChronicFollowupState {
  final List<String> imageUrls;

  const ChronicFollowupImagesUploaded({required this.imageUrls});

  @override
  List<Object?> get props => [imageUrls];
}

class ChronicFollowupError extends ChronicFollowupState {
  final String message;

  const ChronicFollowupError(this.message);

  @override
  List<Object?> get props => [message];
}
