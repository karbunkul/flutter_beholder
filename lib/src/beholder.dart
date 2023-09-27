import 'package:beholder/src/beholder_scope.dart';
import 'package:beholder/src/log_entry_controller.dart';
import 'package:flutter/widgets.dart';

abstract class Beholder extends StatelessWidget {
  const Beholder({super.key});

  Widget builder(BuildContext context, LogEntryController controller);

  @override
  Widget build(BuildContext context) {
    final scope = BeholderScope.of(context);

    return builder(context, scope.controller);
  }
}
