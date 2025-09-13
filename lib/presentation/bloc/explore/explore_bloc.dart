import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/media.dart';
import '../../../domain/usecases/get_trending_media.dart';
import '../../../domain/usecases/search_multi.dart';
import '../../../core/result.dart';
import '../../screens/explore/widgets/filter_utils.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetTrendingMedia getTrending;
  final SearchMulti searchMulti;

  String category = 'All';
  Set<String> genres = {};
  int? year;
  String country = 'All';
  String sortBy = 'Recommended';

  ExploreBloc(this.getTrending, this.searchMulti) : super(ExploreLoading()) {
    on<ExploreStarted>((e, emit) async {
      emit(ExploreLoading());
      final res = await getTrending();
      switch (res) {
        case Ok(value: final list):
          final filtered = applyExploreFilters(
            list,
            category: category,
            genres: genres,
            year: year,
            country: country,
            sortBy: sortBy,
          );
          emit(
            ExploreLoaded(
              base: list,
              results: filtered,
              query: '',
              category: category,
              genres: genres,
              year: year,
              country: country,
              sortBy: sortBy,
            ),
          );
        case Err():
          emit(const ExploreError('Failed to load recommendations'));
      }
    });

    on<ExploreQueryChanged>((e, emit) async {
      final current = state;
      if (e.query.trim().isEmpty) {
        if (current is ExploreLoaded) {
          final filtered = applyExploreFilters(
            current.base,
            category: category,
            genres: genres,
            year: year,
            country: country,
            sortBy: sortBy,
          );
          emit(current.copyWith(query: '', results: filtered));
        }
        return;
      }

      emit(
        ExploreSearching(
          query: e.query,
          category: category,
          genres: genres,
          year: year,
          country: country,
          sortBy: sortBy,
        ),
      );

      final res = await searchMulti(e.query);
      switch (res) {
        case Ok(value: final list):
          final filtered = applyExploreFilters(
            list,
            category: category,
            genres: genres,
            year: year,
            country: country,
            sortBy: sortBy,
          );
          if (filtered.isEmpty) {
            emit(
              ExploreEmpty(
                query: e.query,
                category: category,
                genres: genres,
                year: year,
                country: country,
                sortBy: sortBy,
              ),
            );
          } else {
            emit(
              ExploreLoaded(
                base: list,
                results: filtered,
                query: e.query,
                category: category,
                genres: genres,
                year: year,
                country: country,
                sortBy: sortBy,
              ),
            );
          }
        case Err():
          emit(const ExploreError('Search failed'));
      }
    });

    on<ExploreApplyFilter>((e, emit) {
      category = e.category;
      genres = e.genres;
      year = e.year;
      country = e.country;
      sortBy = e.sortBy;

      final current = state;
      if (current is ExploreLoaded) {
        final src = current.query.isEmpty ? current.base : current.base;
        final filtered = applyExploreFilters(
          src,
          category: category,
          genres: genres,
          year: year,
          country: country,
          sortBy: sortBy,
        );
        if (filtered.isEmpty) {
          emit(
            ExploreEmpty(
              query: current.query,
              category: category,
              genres: genres,
              year: year,
              country: country,
              sortBy: sortBy,
            ),
          );
        } else {
          emit(
            current.copyWith(
              results: filtered,
              category: category,
              genres: genres,
              year: year,
              country: country,
              sortBy: sortBy,
            ),
          );
        }
      }
      if (current is ExploreSearching) {}
      if (current is ExploreError) {
        add(const ExploreStarted());
      }
    });

    on<ExploreRetry>((e, emit) => add(const ExploreStarted()));
  }
}
