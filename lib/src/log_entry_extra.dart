import 'package:meta/meta.dart';

@immutable
final class LogEntryExtra {
  final Object? data;
  final List<String>? tags;

  const LogEntryExtra({this.data, this.tags});

  @override
  String toString() {
    return data?.toString() ?? super.toString();
  }
}
