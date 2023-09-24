import 'dart:async';

import 'package:beholder/src/log_entry_repository.dart';
import 'package:meta/meta.dart';

import 'log_entry.dart';

@immutable
final class LogEntryController {
  final LogEntryRepository _repository;
  final _logStream = StreamController<List<LogEntry>>.broadcast();
  final _tagsStream = StreamController<List<String>>.broadcast();
  final _selectedTags = <String>[];
  final _availableTags = <String>[];

  LogEntryController(this._repository) {
    _repository.addListener(_update);
  }

  Future<void> _update() async {
    final logs = await _repository.search(tags: _selectedTags);
    _logStream.add(logs);
    final availableTags = await _repository.tags();
    if (availableTags != _availableTags) {
      _availableTags.clear();
      _availableTags.addAll(availableTags);
      _tagsStream.add(_availableTags);
    }
  }

  Stream<List<LogEntry>> get logs => _logStream.stream;
  Stream<List<String>> get availableTags => _tagsStream.stream;
  List<String> get tags => List<String>.unmodifiable(_selectedTags);

  List<String> selectedTags() => List.unmodifiable(_selectedTags);

  void toggleTag(String tag) {
    final tags = List<String>.from(_selectedTags);
    tags.contains(tag) ? tags.remove(tag) : tags.add(tag);
    _selectedTags.clear();
    _selectedTags.addAll(tags);
    _availableTags.clear();
    _update();
  }

  void clearAll() {
    _repository.clearAll();
    _selectedTags.clear();
    _availableTags.clear();
    _update();
  }
}
