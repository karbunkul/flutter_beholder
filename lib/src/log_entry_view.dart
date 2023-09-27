import 'package:flutter/widgets.dart';

import 'beholder_scope.dart';
import 'log_entry.dart';
import 'log_view_scope.dart';

enum LogRenderType {
  serializable,
  presentation,
}

@immutable
class LogEntryView extends StatelessWidget {
  final LogRenderType renderType;
  final LogEntry entry;

  const LogEntryView({
    super.key,
    required this.entry,
    this.renderType = LogRenderType.serializable,
  });

  @override
  Widget build(BuildContext context) {
    final scope = BeholderScope.of(context);

    if (entry.data != null) {
      final logWidget = scope.matchLogWidget(entry.data);

      return switch (renderType) {
        LogRenderType.serializable => Text(logWidget.serialize(entry.data!)),
        _ => LogViewScope(data: entry.data!, child: logWidget),
      };
    }

    return const SizedBox.shrink();
  }
}
