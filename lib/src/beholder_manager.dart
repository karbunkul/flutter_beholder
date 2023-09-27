import 'package:beholder/src/beholder_scope.dart';
import 'package:beholder/src/implements/log_default_controller.dart';
import 'package:beholder/src/implements/logging_repository.dart';
import 'package:beholder/src/log_entry_repository.dart';
import 'package:flutter/widgets.dart';

import 'implements/log_default_view.dart';
import 'log_view_widget.dart';

class BeholderManager extends StatefulWidget {
  final List<LogViewWidget> items;
  final LogEntryRepository? repository;
  final Widget child;

  const BeholderManager({
    super.key,
    required this.items,
    this.repository,
    required this.child,
  });

  @override
  State<BeholderManager> createState() => _BeholderManagerState();
}

class _BeholderManagerState extends State<BeholderManager> {
  late final _controller = LogDefaultController(
    repository: widget.repository ?? LogEntryLoggingRepository(),
    matchLogWidget: _onMatchLogWidget,
  );

  final Map<Type, LogViewWidget<Object>> _logWidgets = {};

  @override
  Widget build(BuildContext context) {
    return BeholderScope(
      controller: _controller,
      matchLogWidget: _onMatchLogWidget,
      child: widget.child,
    );
  }

  LogViewWidget _onMatchLogWidget(data) {
    if (data == null) {
      return const LogDefaultView();
    }

    final type = data.runtimeType;
    if (_logWidgets.containsKey(type)) {
      return _logWidgets[type]!;
    }

    final matchedWidget = widget.items.firstWhere(
      (element) => element.hasApply(data),
      orElse: () => const LogDefaultView(),
    );

    _logWidgets.putIfAbsent(type, () => matchedWidget);

    return matchedWidget;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
