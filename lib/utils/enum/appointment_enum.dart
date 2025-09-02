import 'package:json_annotation/json_annotation.dart';

enum AppointmentStatus {
  @JsonValue('PENDING')
  pending('PENDING'),
  @JsonValue('CONFIRMED')
  confirmed('CONFIRMED'),
  @JsonValue('CANCELLED')
  cancelled('CANCELLED'),
  @JsonValue('COMPLETED')
  completed('COMPLETED');

  final String serverKey;
  const AppointmentStatus(this.serverKey);

  /// Parse từ server string sang enum
  static AppointmentStatus fromServerKey(String key) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.serverKey == key,
      orElse: () => AppointmentStatus.pending,
    );
  }
}
