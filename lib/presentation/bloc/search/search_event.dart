part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class DoSearch extends SearchEvent {
  final String query;
  final bool forceRefresh;
  const DoSearch(this.query, {this.forceRefresh = false});
}
