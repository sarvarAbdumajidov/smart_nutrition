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
  bool get hasActiveFilters =>
      isVegetarian || isProtein || isKids || isCalorie || isDiabetes;

  List<String> get activeFilters {
    final filters = <String>[];
    if (isVegetarian) filters.add('Vegetarian');
    if (isProtein) filters.add('Protein');
    if (isKids) filters.add('Kids');
    if (isCalorie) filters.add('Calorie');
    if (isDiabetes) filters.add('Diabetes');
    return filters;
  }
}