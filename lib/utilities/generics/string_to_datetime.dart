extension StringToDateTime on String {
  DateTime? toDatetime() {
    final splitList = split('-');
    if (splitList.length < 2) {
      return null;
    }
    final year = int.parse(splitList[0]);
    final month = int.parse(splitList[1]);
    final day = int.parse(splitList[2]);
    return DateTime(year, month, day);
  }
}
