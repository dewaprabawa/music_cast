class ItuneEntities {
  const ItuneEntities({
    this.results = const [],
  });

  final List<ItuneEntity> results;
}

class ItuneEntity {
  ItuneEntity({
    this.artistId,
    this.collectionId,
    this.trackId,
    this.artistName,
    this.collectionName,
    this.trackName,
    this.artistViewUrl,
    this.collectionViewUrl,
    this.trackViewUrl,
    this.previewUrl,
    this.artworkUrl30,
    this.artworkUrl60,
    this.artworkUrl100,
    this.primaryGenreName,
    this.shortDescription,
    this.longDescription,
  });

  int? artistId;
  int? collectionId;
  int? trackId;
  String? artistName;
  String? collectionName;
  String? trackName;
  String? artistViewUrl;
  String? collectionViewUrl;
  String? trackViewUrl;
  String? previewUrl;
  String? artworkUrl30;
  String? artworkUrl60;
  String? artworkUrl100;
  String? primaryGenreName;
  String? shortDescription;
  String? longDescription;

  factory ItuneEntity.fromJson(Map<String, dynamic> json) => ItuneEntity(
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
}
