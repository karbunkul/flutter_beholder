import 'dart:async';

import 'package:beholder/beholder.dart';

final class LogEntryRepositoryImpl extends LogEntryRepository {
  LogEntryRepositoryImpl() {
    Logger.root.level = Level.ALL;

    Logger.root.onRecord.listen((record) {
      final entry = LogEntry.fromRecord(record);
      _entries.add(entry);
      notifyListeners();
    });
  }

  final List<LogEntry> _entries = [];
  final List<String> _tags = [];

  @override
  Future<void> clearAll() async {
    _tags.clear();
    _entries.clear();
    notifyListeners();
  }

  @override
  Future<List<LogEntry>> search({String? query, List<String>? tags}) async {
    final allEntries = List<LogEntry>.from(_entries).reversed.toList();
    final selectedTags = tags ?? [];

    return allEntries.where((element) {
      if (!element.hasTags && selectedTags.isNotEmpty) {
        return false;
      }

      if (element.hasTags && selectedTags.isNotEmpty) {
        final matchedTags = element.tags!.where((element) {
          return selectedTags.contains(element) == true;
        });

        return matchedTags.length == selectedTags.length;
      }

      return true;
    }).toList(growable: false);
  }

  @override
  Future<List<String>> tags() async {
    return _entries.fold(<String>{}, (acc, element) {
      if (element.tags != null) {
        acc.addAll(element.tags!);
      }

      return acc;
    }).toList(growable: false);
  }
}
