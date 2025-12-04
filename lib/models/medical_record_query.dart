class MedicalRecordQuery {
  final int page;
  final int limit;
  final String? diagnosis;
  final String? symptoms;
  final String? phone;
  final String? fullName;
  final int? appointmentId;
  final DateTime? createdAtFrom;
  final DateTime? createdAtTo;
  final DateTime? updatedAtFrom;
  final DateTime? updatedAtTo;

  MedicalRecordQuery({
    required this.page,
    required this.limit,
    this.diagnosis,
    this.symptoms,
    this.phone,
    this.fullName,
    this.appointmentId,
    this.createdAtFrom,
    this.createdAtTo,
    this.updatedAtFrom,
    this.updatedAtTo,
  });
}
