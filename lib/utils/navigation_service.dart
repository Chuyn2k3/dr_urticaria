
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();
  BuildContext get navigatorContext => navigatorKey.currentState!.context;
}

BuildContext get getContext {
  return GetIt.instance<NavigationService>().navigatorContext;
}
