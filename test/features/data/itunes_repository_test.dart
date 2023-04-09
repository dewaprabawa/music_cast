// ignore_for_file: avoid_print

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_cast/commons/box_name/hive_box_name.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:music_cast/commons/errors/exceptions.dart';
import 'package:music_cast/commons/internet_checker/network_checker.dart';
import 'package:music_cast/features/music_player/data/data_source/locale_data_source.dart';
import 'package:music_cast/features/music_player/data/data_source/remote_data_source.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';
import 'package:music_cast/features/music_player/data/repositories/itunes_repository_impl.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/domain/repository/itunes_repository.dart';

class MockLocaleSongDataSource extends Mock implements LocaleSongDataSource {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ItunesRepositoryImpl repository;
  late MockLocaleSongDataSource mockLocaleDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocaleDataSource = MockLocaleSongDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ItunesRepositoryImpl(
      localeDataSource: mockLocaleDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getSongs', () {
    final tItuneEntities = ItuneEntities(results: [
      ItuneEntity(
        trackId: 1,
        trackName: 'Track 1',
        artistName: 'Artist 1',
        artworkUrl100: 'https://example.com/image1.jpg',
      ),
      ItuneEntity(
        trackId: 2,
        trackName: 'Track 2',
        artistName: 'Artist 2',
        artworkUrl100: 'https://example.com/image2.jpg',
      ),
    ]);
    final tLimit = 20;

    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getSongs(limit: tLimit))
          .thenAnswer((_) async => ItunesModel(results: []));
      // act
      repository.getSongs(limit: tLimit);
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getSongs(limit: tLimit))
          .thenAnswer((_) async => ItunesModel(results: [
            ItuneModel(
        trackId: 1,
        trackName: 'Track 1',
        artistName: 'Artist 1',
        artworkUrl100: 'https://example.com/image1.jpg',
      ),
      ItuneModel(
        trackId: 2,
        trackName: 'Track 2',
        artistName: 'Artist 2',
        artworkUrl100: 'https://example.com/image2.jpg',
      ),
          ]));
      // act
      final result = await repository.getSongs(limit: tLimit);
      // assert
      expect(result, equals(Right(tItuneEntities)));
    }); });

      group('getSongsByName', () {
    final tName = 'test_name';
    final tItunesModel = ItunesModel(results: [
      ItuneModel(
        trackId: 1,
        artistName: 'test_artist',
        trackName: 'test_track',
        previewUrl: 'test_url',
      )
    ]);

     final tItunesEntity = ItuneEntities(results: [
      ItuneEntity(
        trackId: 1,
        artistName: 'test_artist',
        trackName: 'test_track',
        previewUrl: 'test_url',
      )
    ]);

    test('should return cached data when device is offline', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocaleDataSource.loadList(HiveBoxName.songs))
          .thenAnswer((_) => tItunesModel);
      // act
      final result = await repository.getSongsByName(tName);
      // assert
      verify(() => mockLocaleDataSource.loadList(HiveBoxName.songs)).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, equals(Right(tItunesModel)));
    });

    test('should return remote data when device is online', () async {
      // arrange
      print("arrange");
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
       print("isConnected");
      when(() => mockRemoteDataSource.getSongsByName(tName))
          .thenAnswer((_) async => tItunesModel);
           print("when getSongsByName");
      // act
      final result = await repository.getSongsByName(tName);
      print(result.toString());
      // assert
      verify(() async => await mockRemoteDataSource.getSongsByName(tName)).called(1);
      verify(() async => await  mockLocaleDataSource.save(
          Mapper.resultListToString(tItunesModel.results), HiveBoxName.songs)).called(1);
      expect(result, equals(Right(tItunesEntity)));
    });

    test('should return RemoteServerFailure when remote data source throws a ServerException', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getSongsByName(tName)).thenThrow(ServerException());
      // act
      final result = await repository.getSongsByName(tName);
      // assert
      verify(() => mockRemoteDataSource.getSongsByName(tName)).called(1);
      verifyZeroInteractions(mockLocaleDataSource);
      expect(result, equals(Left(RemoteServerFailure())));
    });

    test('should return LocalServiceFailure when local data source throws a CacheException', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocaleDataSource.loadList(HiveBoxName.songs)).thenThrow(CacheException());
      // act
      final result = await repository.getSongsByName(tName);
      // assert
      verify(() => mockLocaleDataSource.loadList(HiveBoxName.songs)).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, equals(Left(LocalServiceFailure())));
    });
  });


  }