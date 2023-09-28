import 'dart:async';

import '../log_entry.dart';
import '../log_entry_controller.dart';
import '../log_entry_repository.dart';
import '../log_view_widget.dart';

typedef MatchLogWidgetCallback = LogViewWidget Function(Object? data);

final class LogDefaultController extends LogEntryController {
  final LogEntryRepository repository;

  final MatchLogWidgetCallback matchLogWidget;
  final _logStream = StreamController<List<LogEntry>>.broadcast(sync: true);
  final _tagsStream = StreamController<List<String>>.broadcast();
  final _selectedTags = <String>[];
  final _availableTags = <String>[];

  LogDefaultController({
    required this.repository,
    required this.matchLogWidget,
  }) {
    repository.addListener(update);
  }

  Future<void> update() async {
    final logs = await repository.search(tags: _selectedTags);
    _logStream.add(logs);
    final availableTags = await repository.tags();
    if (availableTags != _availableTags) {
      _availableTags.clear();
      _availableTags.addAll(availableTags);
      _tagsStream.add(_availableTags);
    }
  }

  @override
  Stream<List<LogEntry>> get logs {
    return _logStream.stream.map((event) {
      return event.map((e) {
        final widget = matchLogWidget(e.data);
        final actions = widget.actions();

        if (actions.isNotEmpty) {
          actions.sort();
          return e.copyWith(actions: actions);
        }

        return e;
      }).toList(growable: false);
    });
  }

  @override
  Stream<List<String>> get availableTags => _tagsStream.stream;
  @override
  List<String> get tags => List<String>.unmodifiable(_selectedTags);

  @override
  void toggleTag(String tag) {
    final tags = List<String>.from(_selectedTags);
    tags.contains(tag) ? tags.remove(tag) : tags.add(tag);
    _selectedTags.clear();
    _selectedTags.addAll(tags);
    _availableTags.clear();
    update();
  }

  @override
  void clearAll() {
    repository.clearAll();
    _selectedTags.clear();
    _availableTags.clear();
    update();
  }

  void dispose() {
    repository.removeListener(update);
  }

  @override
  void filterClear() {
    _selectedTags.clear();
    update();
  }
}
