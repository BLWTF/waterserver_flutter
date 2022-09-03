class District {
  final String code;
  final String description;

  District({required this.code, required this.description});

  District.fromFPMap(Map<String, dynamic> map)
      : this(
          code: map['district']!.toString().trim(),
          description: map['description']!.toString().trim(),
        );

  @override
  String toString() {
    return '$code ($description)';
  }
}
