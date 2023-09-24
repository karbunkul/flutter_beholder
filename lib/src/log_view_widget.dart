import 'package:beholder/src/log_view_scope.dart';
import 'package:flutter/material.dart';

@immutable
abstract base class LogViewWidget<T> extends StatelessWidget {
  const LogViewWidget({super.key});

  bool hasApply(Object error) {
    return error.runtimeType == T;
  }

  Widget builder(BuildContext context, T value);

  @override
  Widget build(BuildContext context) {
    final scope = LogViewScope.of(context);
    return builder(context, scope.data as T);
  }
}
