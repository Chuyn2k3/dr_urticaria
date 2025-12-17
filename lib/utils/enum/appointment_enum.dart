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

  String get display {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Chờ xử lý';
      case AppointmentStatus.confirmed:
        return 'Đã xác nhận';
      case AppointmentStatus.completed:
        return 'Hoàn thành';
      case AppointmentStatus.cancelled:
        return 'Đã hủy';
    }
  }

  bool get canPrimaryAction =>
      this == AppointmentStatus.pending || this == AppointmentStatus.confirmed;

  String get primaryActionLabel {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Xác nhận lịch hẹn';
      case AppointmentStatus.confirmed:
        return 'Hoàn thành lịch hẹn';
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
        return '';
    }
  }

  AppointmentStatus? get nextStatus {
    switch (this) {
      case AppointmentStatus.pending:
        return AppointmentStatus.confirmed;
      case AppointmentStatus.confirmed:
        return AppointmentStatus.completed;
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
        return null;
    }
  }
}
