import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/domain/usecases/get_songs_by_name_use_case.dart';
import 'package:music_cast/features/music_player/domain/usecases/get_songs_use_case.dart';
import 'package:music_cast/features/music_player/presentation/song_data_cubit/song_data_cubit.dart';


class MockGetSongUseCase extends Mock implements GetSongUseCase {}

class MockGetSongByNameUseCase extends Mock implements GetSongByNameUseCase {}

void main() {
  late GetSongUseCase mockGetSongUseCase;
  late GetSongByNameUseCase mockGetSongByNameUseCase;

  setUp(() {
    mockGetSongUseCase = MockGetSongUseCase();
    mockGetSongByNameUseCase = MockGetSongByNameUseCase();
  });

  group('SongDataCubit', () {
    test('initial state is SongDataState.initial', () {
      expect(SongDataCubit(getSongUseCase: mockGetSongUseCase, getSongByNameUseCase: mockGetSongByNameUseCase).state, const SongDataState.initial());
    });

    blocTest<SongDataCubit, SongDataState>(
      'emits [loading, success] when getSongs is called',
      build: () {
        when(() => mockGetSongUseCase.call(ParamLimit(limit: 20))).thenAnswer((_) async => Right(ItuneEntities(results: [ItuneEntity(trackName: 'Song 1'), ItuneEntity(trackName: 'Song 2')])));
        return SongDataCubit(getSongUseCase: mockGetSongUseCase, getSongByNameUseCase: mockGetSongByNameUseCase);
      },
      act: (cubit) async => await cubit.getSongs(),
      expect: () => [
        const SongDataState.loading(),
        SongDataState.success(ItuneEntities(results: [ItuneEntity(trackName: 'Song 1'), ItuneEntity(trackName: 'Song 2')])),
      ],
    );

    blocTest<SongDataCubit, SongDataState>(
      'emits [loading, empty] when getSongsByName is called with empty result',
      build: () {
        when(() => mockGetSongByNameUseCase.call('non-existent-song')).thenAnswer((_) async => Right(ItuneEntities(results: [])));
        return SongDataCubit(getSongUseCase: mockGetSongUseCase, getSongByNameUseCase: mockGetSongByNameUseCase);
      },
      act: (cubit) => cubit.getSongsByName('non-existent-song'),
      expect: () => [
        const SongDataState.loading(),
        const SongDataState.empty(),
      ],
    );

    blocTest<SongDataCubit, SongDataState>(
      'emits [loading, failure] when getSongsByName is called with error',
      build: () {
        when(() => mockGetSongByNameUseCase.call('invalid-song-name')).thenAnswer((_) async => Left(RemoteServerFailure()));
        return SongDataCubit(getSongUseCase: mockGetSongUseCase, getSongByNameUseCase: mockGetSongByNameUseCase);
      },
      act: (cubit) => cubit.getSongsByName('invalid-song-name'),
      expect: () => [
        const SongDataState.loading(),
        const SongDataState.failure('The song is not found'),
      ],
    );
  });
}
