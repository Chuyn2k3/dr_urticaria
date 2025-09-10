class CreateLivePayload {
  final String? title;
  final String? description;
  final int? doctorId;

  CreateLivePayload({
    this.title,
    this.description,
    this.doctorId,
  });

  factory CreateLivePayload.fromJson(Map<String, dynamic> json) {
    return CreateLivePayload(
      title: json['title'] as String?,
      description: json['description'] as String?,
      doctorId: json['doctorId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'doctorId': doctorId,
    };
  }
}
