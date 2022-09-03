extension LastDayOfMonth on DateTime {
  int lastDayOfMonth() {
    return DateTime(year, month + 1, 0).day;
  }
}
