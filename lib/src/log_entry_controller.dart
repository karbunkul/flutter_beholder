import 'dart:async';

import 'package:meta/meta.dart';

import 'log_entry.dart';

@immutable
abstract class LogEntryController {
  Stream<List<LogEntry>> get logs;
  Stream<List<String>> get availableTags;
  List<String> get tags;
  bool get isFiltered => tags.isNotEmpty;

  void filterClear();
  void toggleTag(String tag);
  void clearAll();
}
