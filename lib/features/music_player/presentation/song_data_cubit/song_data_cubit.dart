import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/domain/usecases/get_songs_by_name_use_case.dart';
import 'package:music_cast/features/music_player/domain/usecases/get_songs_use_case.dart';

part 'song_data_state.dart';

class SongDataCubit extends Cubit<SongDataState> {
  SongDataCubit(
      {required this.getSongByNameUseCase, required this.getSongUseCase})
      : super(const SongDataState.initial());
  final GetSongUseCase getSongUseCase;
  final GetSongByNameUseCase getSongByNameUseCase;

  Future<void> getSongs() async {
    emit(const SongDataState.loading());
    await getSongUseCase.call(ParamLimit(limit: 20)).then((value) {
      value.fold((_) {
        emit(const SongDataState.failure("The song is not found"));
      }, (r) {
        _sortMusicOrder(r);
        emit(SongDataState.success(r));
      });
    });
  }

  void getSongsByName(String name) async {
    emit(const SongDataState.loading());
    await getSongByNameUseCase.call(name).then((value) {
      value.fold((_) {
        emit(const SongDataState.failure("The song is not found"));
      }, (success) {
        if (success.results.isEmpty) {
          emit(const SongDataState.empty());
        } else {
          emit(SongDataState.success(success));
        }
      });
    });
  }

  void _sortMusicOrder(ItuneEntities song) {
    song.results.sort((a, b) {
      return a.trackName![0].compareTo(b.trackName![0]);
    });
  }
}

/**
 * This file defines a SongDataCubit class that extends the Cubit class from the `bloc` package. 
 * The `SongDataCubit` is responsible for managing the state of a list of songs retrieved from the iTunes API. 
 * It makes use of the `GetSongUseCase` and `GetSongByNameUseCase` classes from the `domain/usecases` folder to fetch songs from the API. 
 * The class emits states of type `SongDataState` that represent the current state of the list of songs.
 * 
 * The class also defines two public methods:
 *   - `getSongs()`: retrieves the top 20 songs from the API and sorts them alphabetically by track name. 
 *     It emits a `SongDataState.loading()` state before fetching the songs, and a `SongDataState.failure()` state if the songs cannot be retrieved.
 *   - `getSongsByName(String name)`: retrieves songs from the API based on a search query, sorted alphabetically by track name. 
 *     It emits a `SongDataState.loading()` state before fetching the songs, a `SongDataState.empty()` state if no songs are found, 
 *     and a `SongDataState.failure()` state if the songs cannot be retrieved.
 */