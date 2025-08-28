import 'package:dr_urticaria/models/appointment_model.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';

class AppointmentsQuery {
  final int page;
  final int limit;
  final String? reason;
  final AppointmentStatus? status; // 🔥 đổi sang enum
  final DateTime? appointmentDateFrom;
  final DateTime? appointmentDateTo;

  const AppointmentsQuery({
    required this.page,
    required this.limit,
    this.reason,
    this.status,
    this.appointmentDateFrom,
    this.appointmentDateTo,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'reason': reason,
      'status': status?.name, // 🔥 gửi lên API dạng string
      'appointmentDateFrom': appointmentDateFrom?.toIso8601String(),
      'appointmentDateTo': appointmentDateTo?.toIso8601String(),
    };
  }
}
