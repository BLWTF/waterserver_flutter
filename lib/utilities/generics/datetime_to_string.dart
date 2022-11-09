extension DateTimeToString on DateTime {
  String toDateString() {
    return toString().split(' ').first;
  }
}
