import 'package:beholder/src/log_entry_extra.dart';
import 'package:logging/logging.dart';

final class LogEntry {
  final String logger;
  final String message;
  final Object? data;
  final List<String>? tags;

  const LogEntry({
    required this.message,
    required this.logger,
    this.data,
    this.tags,
  });

  bool get hasTags => tags?.isNotEmpty == true;

  factory LogEntry.fromRecord(LogRecord record) {
    if (record.object is LogEntryExtra) {
      final extra = record.object as LogEntryExtra;
      return LogEntry(
        message: record.message,
        logger: record.loggerName,
        data: extra.data,
        tags: extra.tags,
      );
    }

    return LogEntry(
      message: record.message,
      logger: record.loggerName,
      data: record.object,
    );
  }
}
