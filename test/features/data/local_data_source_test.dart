import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_cast/commons/errors/exceptions.dart';
import 'package:music_cast/features/music_player/data/data_source/locale_data_source.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';

class MockBox extends Mock implements Box {}

void main() {
  late HiveSongDataSourceImpl dataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    dataSource = HiveSongDataSourceImpl(mockBox);
  });

  group('loadList', () {
    test('should return ItunesModel when there is data in Hive', () {
      final key = 'test_key';
      final data = [
        {
          
          "artistId": null,
          "collectionId": null,
          "trackId": null,
          "artistName": "unknown",
          "collectionName": "unknown",
          "trackName": "unknown",
          "artistViewUrl": null,
          "collectionViewUrl": null,
          "trackViewUrl": null,
          "previewUrl": null,
          "artworkUrl30": null,
          "artworkUrl60": null,
          "artworkUrl100": null,
          "primaryGenreName": null,
          "shortDescription": null,
          "longDescription": null
        },
        {
          "artistId": null,
          "collectionId": null,
          "trackId": null,
          "artistName": "unknown",
          "collectionName": "unknown",
          "trackName": "unknown",
          "artistViewUrl": null,
          "collectionViewUrl": null,
          "trackViewUrl": null,
          "previewUrl": null,
          "artworkUrl30": null,
          "artworkUrl60": null,
          "artworkUrl100": null,
          "primaryGenreName": null,
          "shortDescription": null,
          "longDescription": null
        }
      ];

      final expectedModel = ItunesModel(
          results: data.map(((e) => ItuneModel.fromJson(e))).toList());

      when(() => mockBox.get(key)).thenReturn(data);

      final result = dataSource.loadList(key);

      if(result == expectedModel){
        print("THI IS SAME");
      }

      expect(result, equals(expectedModel));
      verify(() => mockBox.get(key)).called(1);
    });

    test('should return null when there is no data in Hive', () {
      final key = 'test_key';

      when(() => mockBox.get(key)).thenReturn(null);

      final result = dataSource.loadList(key);

      expect(result, isNull);
      verify(() => mockBox.get(key)).called(1);
    });

    test('should throw CacheException when Hive throws error', () {
      final key = 'test_key';

      when(() => mockBox.get(key)).thenThrow(Exception());

      expect(() => dataSource.loadList(key), throwsA(isA<CacheException>()));
      verify(() => mockBox.get(key)).called(1);
    });
  });

  group('save', () {
    test('should save data to Hive and return true', () async {
      final key = 'test_key';
      final data = [
        {'id': 1, 'title': 'Song 1'},
        {'id': 2, 'title': 'Song 2'},
      ];

      when(() => mockBox.put(key, data)).thenAnswer((_) async => null);

      final result = await dataSource.save(data, key);

      expect(result, isTrue);
      verify(() => mockBox.put(key, data)).called(1);
    });

    test('should throw CacheException when Hive throws error', () async {
      final key = 'test_key';
      final data = [
        {'id': 1, 'title': 'Song 1'},
        {'id': 2, 'title': 'Song 2'},
      ];

      when(() => mockBox.put(key, data)).thenThrow(Exception());

      expect(() => dataSource.save(data, key), throwsA(isA<CacheException>()));
      verify(() => mockBox.put(key, data)).called(1);
    });
  });
}
