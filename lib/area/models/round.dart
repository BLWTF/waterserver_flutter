import '../area.dart';

class Round {
  final String roundCode;
  final String subzoneCode;
  final String zoneCode;
  final String districtCode;
  final String description;

  late final String code;

  Round({
    required this.roundCode,
    required this.subzoneCode,
    required this.zoneCode,
    required this.districtCode,
    required this.description,
  }) {
    code = '$districtCode-$zoneCode-$subzoneCode-$roundCode';
  }

  Round.fromFPMap(Map<String, dynamic> map)
      : this(
          roundCode: map['rounds']!.toString().trim(),
          subzoneCode: map['subzone']!.toString().trim(),
          zoneCode: map['zone']!.toString().trim(),
          districtCode: map['district']!.toString().trim(),
          description: map['description']!.toString().trim(),
        );

  Area toArea() => Area(
        district: districtCode,
        zone: zoneCode,
        subzone: subzoneCode,
        round: roundCode,
        description: description,
      );

  @override
  String toString() {
    return '$code ($description)';
  }
}
