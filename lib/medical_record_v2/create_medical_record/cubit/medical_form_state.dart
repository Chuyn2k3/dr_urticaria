import '../model/vital_group.dart';

abstract class MedicalFormState {}

class MedicalFormInitial extends MedicalFormState {}

class MedicalFormLoading extends MedicalFormState {}

class MedicalFormLoaded extends MedicalFormState {
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;
  final Set<int> visibleGroupIds;
  final Set<int> visibleIndicatorsInGroup12;
  final Set<int> visibleIndicatorsInGroup27;

  MedicalFormLoaded({
    required this.groups,
    required this.answers,
    required this.visibleGroupIds,
    required this.visibleIndicatorsInGroup12,
    required this.visibleIndicatorsInGroup27,
  });

  MedicalFormLoaded copyWith({
    List<VitalGroup>? groups,
    Map<int, dynamic>? answers,
    Set<int>? visibleGroupIds,
    Set<int>? visibleIndicatorsInGroup12,
    Set<int>? visibleIndicatorsInGroup27,
  }) {
    return MedicalFormLoaded(
      groups: groups ?? this.groups,
      answers: answers ?? this.answers,
      visibleGroupIds: visibleGroupIds ?? this.visibleGroupIds,
      visibleIndicatorsInGroup12:
          visibleIndicatorsInGroup12 ?? this.visibleIndicatorsInGroup12,
      visibleIndicatorsInGroup27:
          visibleIndicatorsInGroup27 ?? this.visibleIndicatorsInGroup27,
    );
  }
}

class MedicalFormSubmitting extends MedicalFormState {
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;
  final Set<int> visibleGroupIds;
  final Set<int> visibleIndicatorsInGroup12;
  final Set<int> visibleIndicatorsInGroup27;

  MedicalFormSubmitting({
    required this.groups,
    required this.answers,
    required this.visibleGroupIds,
    required this.visibleIndicatorsInGroup12,
    required this.visibleIndicatorsInGroup27,
  });
}

class MedicalFormSubmittedSuccess extends MedicalFormState {
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;
  final Set<int> visibleGroupIds;
  final Set<int> visibleIndicatorsInGroup12;
  final Set<int> visibleIndicatorsInGroup27;
  final dynamic response;

  MedicalFormSubmittedSuccess({
    required this.groups,
    required this.answers,
    required this.visibleGroupIds,
    required this.visibleIndicatorsInGroup12,
    required this.visibleIndicatorsInGroup27,
    required this.response,
  });
}

class MedicalFormError extends MedicalFormState {
  final String message;
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;

  MedicalFormError({
    required this.message,
    required this.groups,
    required this.answers,
  });
}
