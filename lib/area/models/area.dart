class Area {
  final String district;
  final String? zone;
  final String? subzone;
  final String? round;

  late final String code;

  Area({
    required this.district,
    this.zone,
    this.subzone,
    this.round,
  }) {
    var newCode = district;
    if (zone != null) newCode += '-$zone';
    if (subzone != null) newCode += '-$subzone';
    if (round != null) newCode += '-$round';
    code = newCode;
  }

  @override
  String toString() {
    return code;
  }
}

enum AreaType { district, zone, subzone, round }

extension GetAreaCode on String {
  String? getAreaCode(AreaType areaType) {
    final codes = split('-');
    switch (areaType) {
      case AreaType.district:
        return codes[0];
      case AreaType.zone:
        return codes[1];
      case AreaType.subzone:
        return codes[2];
      case AreaType.round:
        return codes[3];
    }
  }
}
