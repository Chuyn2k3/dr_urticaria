import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/notification_model.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState());

  int getUnreadCount(String userId) {
    return state.notifications
        .where((n) => n.userId == userId && !n.isRead)
        .length;
  }

  List<NotificationModel> getNotificationsByUserId(String userId) {
    return state.notifications
        .where((n) => n.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void addNotification(NotificationModel notification) {
    final updatedNotifications = [...state.notifications, notification];
    emit(state.copyWith(notifications: updatedNotifications));
  }

  void markAsRead(String notificationId) {
    final updatedNotifications = state.notifications.map((n) {
      return n.id == notificationId ? n.copyWith(isRead: true) : n;
    }).toList();
    emit(state.copyWith(notifications: updatedNotifications));
  }

  void sendRoomAssignmentNotification(String patientId, String roomNumber) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: patientId,
      title: 'Điều hướng phòng khám',
      message: 'Bạn được điều hướng đến phòng chờ khám mề đay $roomNumber',
      type: NotificationType.roomAssignment,
      createdAt: DateTime.now(),
      data: {'roomNumber': roomNumber},
    );
    addNotification(notification);
  }

  void sendTestOrderNotification(String patientId, List<String> tests) {
    final testList = tests.join(', ');
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: patientId,
      title: 'Chỉ định xét nghiệm',
      message: 'Bạn cần thực hiện các xét nghiệm: $testList',
      type: NotificationType.testOrder,
      createdAt: DateTime.now(),
      data: {'tests': tests},
    );
    addNotification(notification);
  }
}
