extension StringExtension on String {
  String capFirst() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
