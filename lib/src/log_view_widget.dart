import 'package:beholder/src/log_view_scope.dart';
import 'package:flutter/material.dart';

import 'log_entry_action.dart';

@immutable
abstract base class LogViewWidget<T extends Object> extends StatelessWidget {
  const LogViewWidget({super.key});

  bool hasApply(Object error) => error.runtimeType == T;

  Widget builder(BuildContext context, T value);

  @override
  Widget build(BuildContext context) {
    final scope = LogViewScope.of(context);
    return builder(context, scope.data as T);
  }

  List<LogEntryAction> actions() => [];

  String serialize(T value) {
    return value.toString();
  }
}
