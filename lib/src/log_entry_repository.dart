import 'package:beholder/beholder.dart';
import 'package:flutter/widgets.dart';

abstract base class LogEntryRepository extends ChangeNotifier {
  Future<List<LogEntry>> search({String? query, List<String>? tags});
  Future<List<String>> tags();
  Future<void> clearAll();
}
