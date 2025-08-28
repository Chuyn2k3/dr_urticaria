enum AppointmentStatus {
  pending('PENDING'),
  confirmed('CONFIRMED'),
  cancelled('CANCELLED'),
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
