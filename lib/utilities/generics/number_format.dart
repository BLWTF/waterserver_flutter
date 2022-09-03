import 'package:intl/intl.dart';

extension CommaNumber on num {
  String format() {
    return NumberFormat.decimalPattern('en_US').format(this);
  }
}
