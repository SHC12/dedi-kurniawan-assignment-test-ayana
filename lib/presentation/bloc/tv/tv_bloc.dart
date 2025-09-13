import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv_show.dart';
import '../../../domain/usecases/get_popular_tv.dart';

part 'tv_event.dart';
part 'tv_state.dart';

class TvBloc extends Bloc<TvEvent, TvState> {
  final GetPopularTv getPopularTv;

  TvBloc(this.getPopularTv) : super(TvLoading()) {
    on<LoadPopularTv>((event, emit) async {
      emit(TvLoading());
      final res = await getPopularTv();

      res.fold((failure) => emit(TvError(failure.message)), (list) => emit(TvLoaded(list)));
    });
  }
}
