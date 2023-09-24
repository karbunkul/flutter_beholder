import 'package:beholder/src/beholder_scope.dart';
import 'package:beholder/src/implements/logging_repository.dart';
import 'package:beholder/src/log_entry_controller.dart';
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
  late final _controller = LogEntryController(
    widget.repository ?? LogEntryLoggingRepository(),
  );

  @override
  Widget build(BuildContext context) {
    return BeholderScope(
      controller: _controller,
      matchLogWidget: _onMatchLogWidget,
      child: widget.child,
    );
  }

  LogViewWidget _onMatchLogWidget(data) {
    return widget.items.firstWhere(
      (element) => element.hasApply(data),
      orElse: () => const LogDefaultView(),
    );
  }
}
