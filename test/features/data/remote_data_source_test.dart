import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:music_cast/features/music_player/data/data_source/remote_data_source.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('RemoteDataServiceImpl', () {
    late RemoteDataServiceImpl remoteDataSource;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      remoteDataSource = RemoteDataServiceImpl(mockHttpClient);
      registerFallbackValue(Uri());
    });

    final tItunesModel = ItunesModel(results: [
      ItuneModel(
          artistId: 1234,
          collectionId: 5678,
          trackId: 9012,
          artistName: "John Doe",
          collectionName: "Best Hits",
          trackName: "Test Song",
          artistViewUrl: "https://example.com/artist",
          collectionViewUrl: "https://example.com/collection",
          trackViewUrl: "https://example.com/track",
          previewUrl: "https://example.com/preview",
          artworkUrl30: "https://example.com/artwork30",
          artworkUrl60: "https://example.com/artwork60",
          artworkUrl100: "https://example.com/artwork100",
          primaryGenreName: "Pop",
          shortDescription: "Short description",
          longDescription: "Long description"),
    ]);

    test('should return a valid ItunesModel when calling getSongs()', () async {
      // arrange
       registerFallbackValue(Uri());
      when(() => mockHttpClient.get(any(),
          headers:
              any(named: 'headers'))).thenAnswer((_) async => http.Response(
          '{"results":[{"artistId": 1234, "collectionId": 5678, "trackId": 9012, "artistName": "John Doe", "collectionName": "Best Hits","trackName": "Test Song", "artistViewUrl": "https://example.com/artist",  "collectionViewUrl": "https://example.com/collection", "trackViewUrl": "https://example.com/track","previewUrl": "https://example.com/preview","artworkUrl30": "https://example.com/artwork30","artworkUrl60": "https://example.com/artwork60","artworkUrl100": "https://example.com/artwork100", "primaryGenreName": "Pop", "shortDescription": "Short description","longDescription": "Long description"}]}',
          200));

      // act
      final result = await remoteDataSource.getSongs();
    
  
      // assert
      expect(result, tItunesModel);
    });

    test(
        'should return a valid ItunesModel when calling getSongsByName() with a valid name',
        () async {
      // arrange
      when(() => mockHttpClient.get(any(),
          headers:
              any(named: 'headers'))).thenAnswer((_) async => http.Response(
          '{"results":[{"artistId": 1234, "collectionId": 5678, "trackId": 9012, "artistName": "John Doe", "collectionName": "Best Hits","trackName": "Test Song", "artistViewUrl": "https://example.com/artist",  "collectionViewUrl": "https://example.com/collection", "trackViewUrl": "https://example.com/track","previewUrl": "https://example.com/preview","artworkUrl30": "https://example.com/artwork30","artworkUrl60": "https://example.com/artwork60","artworkUrl100": "https://example.com/artwork100", "primaryGenreName": "Pop", "shortDescription": "Short description","longDescription": "Long description"}]}',
          200));

      // act
      final result = await remoteDataSource.getSongsByName('Test Song');

      // assert
      expect(result, tItunesModel);
    });

    test(
        'should throw a RemoteServerFailure when calling getSongsByName() with an invalid name',
        () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenThrow(Exception());

      // act
      final call = remoteDataSource.getSongsByName;

      // assert
      expect(() => call('invalid'), throwsA(isA<RemoteServerFailure>()));
    });

    test(
        'should throw a RemoteServerFailure when calling getSongs() and the server returns an error',
        () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 500));

      // act
      final call = remoteDataSource.getSongs;

      // assert
      expect(() => call(), throwsA(isA<RemoteServerFailure>()));
    });
  });
}
