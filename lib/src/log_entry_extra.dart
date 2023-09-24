import 'package:meta/meta.dart';

@immutable
final class LogEntryExtra {
  final Object? data;
  final List<String>? tags;

  const LogEntryExtra({this.data, this.tags});
}
