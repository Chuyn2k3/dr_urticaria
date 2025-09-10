// import 'package:dr_urticaria/models/appointment_model.dart';
// import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
//
// class AppointmentsQuery {
//   final int page;
//   final int limit;
//   final String? reason;
//   final AppointmentStatus? status; // 🔥 đổi sang enum
//   final DateTime? appointmentDateFrom;
//   final DateTime? appointmentDateTo;
//   final String? orderDirection;
//   const AppointmentsQuery({
//     required this.page,
//     required this.limit,
//     this.reason,
//     this.status,
//     this.appointmentDateFrom,
//     this.appointmentDateTo,
//     this.orderDirection,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'page': page,
//       'limit': limit,
//       'reason': reason,
//       'status': status?.name, // 🔥 gửi lên API dạng string
//       'appointmentDateFrom': appointmentDateFrom?.toIso8601String(),
//       'appointmentDateTo': appointmentDateTo?.toIso8601String(),
//       'orderDirection': orderDirection,
//     };
//   }
// }
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';

class AppointmentsQuery {
  final int page;
  final int limit;
  final String? reason;
  final AppointmentStatus? status;
  final DateTime? appointmentDateFrom;
  final DateTime? appointmentDateTo;
  final String? fullName;
  final String? phone;
  final String? orderBy;
  final String? orderDirection;

  const AppointmentsQuery({
    required this.page,
    required this.limit,
    this.reason,
    this.status,
    this.appointmentDateFrom,
    this.appointmentDateTo,
    this.fullName,
    this.phone,
    this.orderBy,
    this.orderDirection,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'reason': reason,
      'status': status?.name,
      'appointmentDateFrom': appointmentDateFrom?.toIso8601String(),
      'appointmentDateTo': appointmentDateTo?.toIso8601String(),
      'fullName': fullName,
      'phone': phone,
      'orderBy': orderBy,
      'orderDirection': orderDirection,
    };
  }
}
