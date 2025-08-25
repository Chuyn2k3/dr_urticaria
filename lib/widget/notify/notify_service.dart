import 'package:dr_urticaria/widget/notify/interactive_modal.dart';
import 'package:flutter/material.dart';

class NotifyService {
  InteractiveModal notify;

  NotifyService(this.notify);

  Future<dynamic> showFailure(BuildContext context) {
    return notify.showFailure(context);
  }

  Future<dynamic> showInfo(BuildContext context) {
    return notify.showInfo(context);
  }

  Future<dynamic> showSuccess(BuildContext context) {
    return notify.showSuccess(context);
  }
}
