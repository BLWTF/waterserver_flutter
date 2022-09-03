import '../enums/category.dart';
import '../enums/consumption_type.dart';

class Tariff {
  final String name;
  final String category;
  final String subcategory;
  final String consumptionType;
  final double volume;
  final double? agreedVolume;
  final double limit;
  final double rate;

  Tariff({
    required this.name,
    required this.category,
    required this.subcategory,
    required this.consumptionType,
    required this.volume,
    required this.agreedVolume,
    required this.limit,
    required this.rate,
  });

  Tariff.fromFPMap(Map<String, dynamic> fpJson)
      : this(
          name: fpJson["tariff"].toString().trim(),
          consumptionType: fpJson["typpe"].toString().trim(),
          volume: fpJson["volume1"].toDouble(),
          agreedVolume: fpJson["agreedvolume"]?.toDouble(),
          rate: fpJson["rate1"].toDouble(),
          limit: fpJson["limit1"].toDouble(),
          category: fpJson["category"],
          subcategory: fpJson["s_category"],
        );

  static ConsumptionType? getFPConsumptionType(String? consumptionType) {
    if (consumptionType == null) return null;
    final trimConsumptionType = consumptionType.trim();
    switch (trimConsumptionType) {
      case 'METERED':
        return ConsumptionType.metered;
      case 'UNMETERED':
        return ConsumptionType.unmetered;
      default:
        return ConsumptionType.flat;
    }
  }

  static String? getFPConsumptionTypeReverse(ConsumptionType? consumptionType) {
    switch (consumptionType) {
      case ConsumptionType.metered:
        return 'METERED';
      case ConsumptionType.unmetered:
        return 'UNMETERED';
      case ConsumptionType.flat:
        return 'FLATRATE';
      case ConsumptionType.bulkmeter:
        return 'BULKMETER';
      default:
        return null;
    }
  }

  static Category? getFPCategory(String? category) {
    if (category == null) {
      return null;
    }
    final trimCategory = category.trim();
    switch (trimCategory) {
      case 'DOMESTIC':
        return Category.domestic;
      case 'COMMERCIAL':
        return Category.commercial;
      case 'INSTITUTION':
        return Category.institution;
      case 'BOREHOLE':
        return Category.borehole;
      case 'INDUSTRIAL ':
        return Category.industrial;
      case 'RAWWATER':
        return Category.rawwater;
      case 'TANKER':
        return Category.tanker;
      default:
        return Category.other;
    }
  }
}

extension GetCategory on String {
  Category getCategory() {
    return Category.values
        .firstWhere((cat) => cat.toString() == 'Category.${toLowerCase()}');
  }
}
