class Meter {
  final String meterNo;
  final String? meterType;
  final String? meterSize;

  Meter({required this.meterNo, this.meterType, this.meterSize});

  @override
  String toString() {
    return meterNo;
  }
}
