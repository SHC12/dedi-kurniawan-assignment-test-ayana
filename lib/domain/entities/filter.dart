class FilterModel {
  final String category;
  final Set<String> genres;
  final int? year;
  final String country;
  final String sortBy;

  const FilterModel({
    required this.category,
    required this.genres,
    required this.year,
    required this.country,
    required this.sortBy,
  });

  factory FilterModel.initial() =>
      const FilterModel(category: 'All', genres: {}, year: null, country: 'All', sortBy: 'Recommended');

  FilterModel copyWith({String? category, Set<String>? genres, int? year = -1, String? country, String? sortBy}) {
    return FilterModel(
      category: category ?? this.category,
      genres: genres ?? this.genres,
      year: year == -1 ? this.year : year,
      country: country ?? this.country,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
