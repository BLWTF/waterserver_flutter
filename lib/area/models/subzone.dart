class Subzone {
  final String subzoneCode;
  final String zoneCode;
  final String districtCode;
  final String description;

  late final String code;

  Subzone({
    required this.subzoneCode,
    required this.zoneCode,
    required this.districtCode,
    required this.description,
  }) {
    code = '$districtCode-$zoneCode-$subzoneCode';
  }

  Subzone.fromFPMap(Map<String, dynamic> map)
      : this(
          subzoneCode: map['subzone']!.toString().trim(),
          zoneCode: map['zone']!.toString().trim(),
          districtCode: map['district']!.toString().trim(),
          description: map['description']!.toString().trim(),
        );

  @override
  String toString() {
    return '$code ($description)';
  }
}
