import 'package:equatable/equatable.dart';

class Area extends Equatable {
  final String district;
  final String? zone;
  final String? subzone;
  final String? round;
  final String? description;

  const Area({
    required this.district,
    this.zone,
    this.subzone,
    this.round,
    this.description,
  });

  String get code {
    var newCode = district;
    if (zone != null) newCode += '-$zone';
    if (subzone != null) newCode += '-$subzone';
    if (round != null) newCode += '-$round';
    return newCode;
  }

  @override
  String toString() {
    return description == null ? code : "$code ($description)";
  }

  @override
  List<Object?> get props => [district, zone, subzone, round];
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
