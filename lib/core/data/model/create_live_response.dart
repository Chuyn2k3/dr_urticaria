class CreateLiveResponse {
  final int? id;
  final String? title;
  final String? description;
  final String? channelName;
  final int? doctorId;
  final DateTime? createdAt;

  CreateLiveResponse({
    this.id,
    this.title,
    this.description,
    this.doctorId,
    this.createdAt,
    this.channelName,
  });

  factory CreateLiveResponse.fromJson(Map<String, dynamic> json) {
    return CreateLiveResponse(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      channelName: json['channelName'] as String?,
      doctorId: json['doctorId'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'doctorId': doctorId,
      'createdAt': createdAt?.toIso8601String(),
      'channelName': channelName,
    };
  }
}
