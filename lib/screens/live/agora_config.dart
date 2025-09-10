class AgoraConfig {
  final String? rtcToken;
  final String? rtmToken;
  final String? channelName;
  final String? appId;
  final int? doctorId;
  final int? liveId;
  final bool? isHost;

  AgoraConfig({
    this.rtcToken,
    this.rtmToken,
    this.liveId,
    this.appId,
    this.channelName,
    this.isHost,
    this.doctorId,
  });

  factory AgoraConfig.fromJson(Map<String, dynamic> json) {
    return AgoraConfig(
      rtcToken: json['rtcToken'] as String?,
      rtmToken: json['rtmToken'] as String?,
      appId: json['appId'] as String?,
      isHost: json['isHost'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rtcToken': rtcToken,
      'rtmToken': rtmToken,
      'appId': appId,
      'isHost': isHost,
    };
  }

  AgoraConfig copyWith({
    String? rtcToken,
    String? rtmToken,
    String? appId,
    bool? isHost,
    String? channelName,
    int? doctorId,
    int? liveId,
  }) {
    return AgoraConfig(
      rtcToken: rtcToken ?? this.rtcToken,
      rtmToken: rtmToken ?? this.rtmToken,
      appId: appId ?? this.appId,
      isHost: isHost ?? this.isHost,
      channelName: channelName ?? this.channelName,
      doctorId: doctorId ?? this.doctorId,
      liveId: liveId ?? this.liveId,
    );
  }
}
