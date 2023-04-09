import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';

class Mapper {
  static String resultListToString(List<ItuneModel> results) {
    return results.map((result) => result.toString()).join(',\n');
  }

  static List<ItuneModel> fromJsonListString(String jsonString) {
    final jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList.map((jsonMap) => ItuneModel.fromJson(jsonMap)).toList();
  }

  static ItuneEntities toDomain(ItunesModel model) {
    return ItuneEntities(results: model.results);
  }
}

class ItunesModel extends Equatable {
  final List<ItuneModel> results;

  const ItunesModel({
    this.results = const [],
  });

  factory ItunesModel.fromJson(Map<String, dynamic> json) => ItunesModel(
        results: List<ItuneModel>.from(
            json["results"].map((x) => ItuneModel.fromJson(x))),
      );

  static const empty = ItunesModel(results: []);

  int get count => results.length;

  @override
  // TODO: implement props
  List<Object?> get props => [results];
}

class ItuneModel extends ItuneEntity {
  ItuneModel({
     int? artistId,
     int? collectionId,
     int? trackId,
     String? artistName,
     String? collectionName,
     String? trackName,
     String? artistViewUrl,
     String? collectionViewUrl,
     String? trackViewUrl,
     String? previewUrl,
     String? artworkUrl30,
     String? artworkUrl60,
     String? artworkUrl100,
     String? primaryGenreName,
     String? shortDescription,
     String? longDescription,
  }) : super(
          artistId: artistId,
          collectionId: collectionId,
          trackId: trackId,
          artistName: artistName,
          collectionName: collectionName,
          trackName: trackName,
          artistViewUrl: artistViewUrl,
          collectionViewUrl: collectionViewUrl,
          trackViewUrl: trackViewUrl,
          previewUrl: previewUrl,
          artworkUrl30: artworkUrl30,
          artworkUrl60: artworkUrl60,
          artworkUrl100: artworkUrl100,
          primaryGenreName: primaryGenreName,
          shortDescription: shortDescription,
          longDescription: longDescription,
        );

  factory ItuneModel.fromJson(Map<String, dynamic> json) => ItuneModel(
        artistId: json["artistId"],
        collectionId: json["collectionId"],
        trackId: json["trackId"],
        artistName: json["artistName"] ?? "unknown",
        collectionName: json["collectionName"] ?? "unknown",
        trackName: json["trackName"] ?? "unknown",
        artistViewUrl: json["artistViewUrl"],
        collectionViewUrl: json["collectionViewUrl"],
        trackViewUrl: json["trackViewUrl"],
        previewUrl: json["previewUrl"],
        artworkUrl30: json["artworkUrl30"],
        artworkUrl60: json["artworkUrl60"],
        artworkUrl100: json["artworkUrl100"],
        primaryGenreName: json["primaryGenreName"],
        shortDescription: json["shortDescription"],
        longDescription: json["longDescription"],
      );

  Map<String, dynamic> toJson() {
    return {
      "artistId": artistId,
      "collectionId": collectionId,
      "trackId": trackId,
      "artistName": artistName,
      "collectionName": collectionName,
      "trackName": trackName,
      "artistViewUrl": artistViewUrl,
      "collectionViewUrl": collectionViewUrl,
      "trackViewUrl": trackViewUrl,
      "previewUrl": previewUrl,
      "artworkUrl30": artworkUrl30,
      "artworkUrl60": artworkUrl60,
      "artworkUrl100": artworkUrl100,
      "primaryGenreName": primaryGenreName,
      "shortDescription": shortDescription,
      "longDescription": longDescription,
    };
  }

  @override
  String toString() {
    return '{ artistId: ${artistId.toString()}, '
        'collectionId: ${collectionId.toString()}, '
        'trackId: ${trackId.toString()}, '
        'artistName: ${artistName ?? 'unknown'}, '
        'collectionName: ${collectionName ?? 'unknown'}, '
        'trackName: ${trackName ?? 'unknown'}, '
        'artistViewUrl: ${artistViewUrl.toString()}, '
        'collectionViewUrl: ${collectionViewUrl.toString()}, '
        'trackViewUrl: ${trackViewUrl.toString()}, '
        'previewUrl: ${previewUrl.toString()}, '
        'artworkUrl30: ${artworkUrl30.toString()}, '
        'artworkUrl60: ${artworkUrl60.toString()}, '
        'artworkUrl100: ${artworkUrl100.toString()}, '
        'primaryGenreName: ${primaryGenreName.toString()}, '
        'shortDescription: ${shortDescription.toString()}, '
        'longDescription: ${longDescription.toString()} }';
  }
}
