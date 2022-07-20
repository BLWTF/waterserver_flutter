class Tariff {
  final String uid;
  final String name;
  final Category category;
  final double volume;
  final double limit;
  final double rate;

  Tariff({
    required this.uid,
    required this.name,
    required this.category,
    required this.volume,
    required this.limit,
    required this.rate,
  });
}

enum Category {
  domestic,
  commercial,
  borehole,
  institution,
  rawwater,
  tanker,
  industrial,
  organisation,
  other,
}
