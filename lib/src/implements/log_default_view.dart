import 'package:flutter/widgets.dart';

import '../log_view_widget.dart';

final class LogDefaultView extends LogViewWidget {
  const LogDefaultView({super.key});

  @override
  Widget builder(context, value) {
    return Text(value.toString());
  }
}
