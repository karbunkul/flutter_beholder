import 'package:beholder/beholder.dart';
import 'package:flutter/widgets.dart';

@immutable
class LogEntryView extends StatelessWidget {
  final LogEntry entry;

  const LogEntryView({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final scope = BeholderScope.of(context);

    if (entry.data != null) {
      return LogViewScope(
        data: entry.data!,
        child: scope.matchLogWidget(entry.data),
      );
    }

    return const SizedBox.shrink();
  }
}
