import 'package:fluent_ui/fluent_ui.dart';
import 'package:waterserver/utilities/generics/last_day_month.dart';

class MonthPicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onSelected;

  const MonthPicker({
    Key? key,
    required this.selectedDate,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      showDay: false,
      selected: selectedDate,
      onChanged: (dateTime) {
        dateTime =
            DateTime(dateTime.year, dateTime.month, dateTime.lastDayOfMonth());
        onSelected(dateTime);
      },
    );
  }
}
