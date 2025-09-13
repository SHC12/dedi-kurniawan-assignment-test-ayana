import 'package:ayana_movies/domain/entities/movie.dart';
import 'package:ayana_movies/domain/entities/tv_show.dart';
import 'package:ayana_movies/domain/entities/media.dart';
import 'package:ayana_movies/domain/entities/detail_vm.dart';
import 'package:ayana_movies/domain/entities/media_kind.dart';
import 'package:ayana_movies/domain/entities/tv_detail.dart';

const tMovie = Movie(
  id: 1,
  title: 'Test Movie',
  overview: 'Overview',
  posterPath: '/path.jpg',
  backdropPath: '/bg.jpg',
  voteAverage: 8.3,
  releaseDate: '2024-01-01',
  genres: ['Action', 'Drama'],
);

const tTv = TvShow(
  id: 101,
  name: 'Test Show',
  posterPath: '/tv.jpg',
  backdropPath: '/tvbg.jpg',
  voteAverage: 7.9,
  firstAirDate: '2023-03-03',
);

const tTvDetail = TvDetail(
  id: 101,
  name: 'Test Show',
  overview: 'TV Overview',
  posterPath: '/tv.jpg',
  backdropPath: '/tvbg.jpg',
  voteAverage: 7.9,
  firstAirDate: '2023-03-03',
  genreIds: const [],
  genres: ['Drama'],
);

const tMediaMovie = Media(
  id: 1,
  mediaType: 'movie',
  title: 'Test Movie',
  posterPath: '/path.jpg',
  backdropPath: '/bg.jpg',
  voteAverage: 8.3,
  releaseDate: '2024-01-01',
  firstAirDate: null,
  genreIds: const [28],
  originCountry: const ['US'],
  originalLanguage: 'en',
);

const tMediaTv = Media(
  id: 101,
  mediaType: 'tv',
  title: 'Test Show',
  posterPath: '/tv.jpg',
  backdropPath: '/tvbg.jpg',
  voteAverage: 7.9,
  releaseDate: null,
  firstAirDate: '2023-03-03',
  genreIds: const [18],
  originCountry: const ['US'],
  originalLanguage: 'en',
);

const tDetailVM = DetailVM(
  id: 1,
  kind: MediaKind.movie,
  title: 'Test Movie',
  overview: 'Overview',
  posterPath: '/path.jpg',
  backdropPath: '/bg.jpg',
  vote: 8.3,
  year: '2024',
  genres: ['Action', 'Drama'],
);
