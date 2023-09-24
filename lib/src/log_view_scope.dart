import 'package:flutter/widgets.dart';

@immutable
class LogViewScope extends InheritedWidget {
  final Object data;
  const LogViewScope({super.key, required Widget child, required this.data})
      : super(child: child);

  static LogViewScope of<T>(BuildContext context) {
    final LogViewScope? result =
        context.dependOnInheritedWidgetOfExactType<LogViewScope>();
    assert(result != null, 'No LogViewScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LogViewScope oldWidget) {
    return data != oldWidget.data;
  }
}
