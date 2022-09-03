class Zone {
  final String zoneCode;
  final String districtCode;
  final String description;

  late final String code;

  Zone(
      {required this.zoneCode,
      required this.districtCode,
      required this.description}) {
    code = '$districtCode-$zoneCode';
  }

  Zone.fromFPMap(Map<String, dynamic> map)
      : this(
          zoneCode: map['zone']!.toString().trim(),
          districtCode: map['district']!.toString().trim(),
          description: map['description']!.toString().trim(),
        );

  @override
  String toString() {
    return '$code ($description)';
  }
}
