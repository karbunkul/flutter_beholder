import 'package:beholder/beholder.dart';
import 'package:beholder/src/log_entry_extra.dart';
import 'package:flutter/cupertino.dart';

@immutable
final class LogEntry {
  final String logger;
  final String message;
  final DateTime time;
  final Object? data;
  final Object? error;
  final String? stackTrace;
  final List<String>? tags;
  final List<LogEntryAction>? actions;

  const LogEntry({
    required this.message,
    required this.logger,
    required this.time,
    this.data,
    this.error,
    this.stackTrace,
    this.tags,
    this.actions,
  });

  factory LogEntry.fromRecord(LogRecord record) {
    if (record.object is LogEntryExtra) {
      final extra = record.object as LogEntryExtra;
      return LogEntry(
        message: record.message,
        logger: record.loggerName,
        time: record.time,
        data: extra.data,
        error: record.error,
        stackTrace: record.stackTrace?.toString(),
        tags: extra.tags,
      );
    }

    return LogEntry(
      message: record.message,
      logger: record.loggerName,
      time: record.time,
      data: record.object,
      error: record.error,
      stackTrace: record.stackTrace?.toString(),
    );
  }

  bool get hasTags => tags?.isNotEmpty == true;
  bool get hasData => data != null;
  bool get hasActions => actions?.isNotEmpty == true;

  LogEntry copyWith({List<LogEntryAction>? actions}) {
    return LogEntry(
      message: message,
      logger: logger,
      time: time,
      tags: tags,
      data: data,
      error: error,
      stackTrace: stackTrace,
      actions: actions ?? this.actions,
    );
  }
}
