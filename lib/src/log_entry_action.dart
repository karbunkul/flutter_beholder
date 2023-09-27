import 'package:flutter/cupertino.dart';

base class LogEntryAction<T> implements Comparable<LogEntryAction<T>> {
  final ValueChanged<T> action;
  final String label;
  final int weight;

  LogEntryAction({
    required this.action,
    required this.label,
    this.weight = 0,
  });

  @override
  int compareTo(LogEntryAction<T> other) {
    return other.weight.compareTo(weight);
  }
}
