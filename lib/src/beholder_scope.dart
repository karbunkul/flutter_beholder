import 'package:beholder/src/log_entry_controller.dart';
import 'package:beholder/src/log_view_widget.dart';
import 'package:flutter/widgets.dart';

typedef MatchLogWidgetCallback = LogViewWidget Function(dynamic data);

@immutable
class BeholderScope extends InheritedWidget {
  final LogEntryController controller;

  final MatchLogWidgetCallback matchLogWidget;
  const BeholderScope({
    super.key,
    required this.controller,
    required this.matchLogWidget,
    required Widget child,
  }) : super(child: child);

  static BeholderScope of(BuildContext context) {
    final BeholderScope? result =
        context.dependOnInheritedWidgetOfExactType<BeholderScope>();
    assert(result != null, 'No BeholderScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(BeholderScope oldWidget) {
    return false;
  }
}
