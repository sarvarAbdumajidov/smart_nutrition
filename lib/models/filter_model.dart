class FilterState {
  final bool isVegetarian;
  final bool isDiabetes;
  final bool isCalorie;
  final bool isKids;
  final bool isProtein;

  FilterState({
    this.isVegetarian = false,
    this.isDiabetes = false,
    this.isCalorie = false,
    this.isKids = false,
    this.isProtein = false,
  });

  FilterState copyWith({
    bool? isVegetarian,
    bool? isDiabetes,
    bool? isCalorie,
    bool? isKids,
    bool? isProtein,
  }) {
    return FilterState(
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isDiabetes: isDiabetes ?? this.isDiabetes,
      isCalorie: isCalorie ?? this.isCalorie,
      isKids: isKids ?? this.isKids,
      isProtein: isProtein ?? this.isProtein,
    );
  }
}