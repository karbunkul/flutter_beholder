import 'dart:async';

import 'package:beholder/beholder.dart';
import 'package:beholder/src/log_entry_extra.dart';
import 'package:logging/logging.dart';

extension BeholderExtension on Logger {
  logWithExtra(
    Level logLevel,
    Object? message, {
    Object? error,
    StackTrace? stackTrace,
    Zone? zone,
    List<String>? tags,
  }) {
    log(
      logLevel,
      LogEntryExtra(data: message, tags: tags),
      error,
      stackTrace,
      zone,
    );
  }

  void infoWithTag({
    required String tag,
    Object? message,
    Object? error,
    StackTrace? stackTrace,
    Zone? zone,
  }) {
    logWithExtra(
      Level.INFO,
      message,
      error: error,
      stackTrace: stackTrace,
      zone: zone,
      tags: [tag],
    );
  }
}
