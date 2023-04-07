import 'package:music_cast/commons/errors/exceptions.dart';
import 'package:music_cast/features/music_player/data/data_source/locale_data_source.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:dartz/dartz.dart';
import 'package:music_cast/features/music_playlist/data/local_data_source/local_data_source.dart';
import 'package:music_cast/features/music_playlist/domain/repository/playlist_repository.dart';

const key = "playlist";

class PlaylistRepositoryImpl extends PlaylistRepository {
  final LocalePlaylistDataSource localeDataSource;

  PlaylistRepositoryImpl(this.localeDataSource);

  @override
  Future<Either<Failure, bool>> put(ItuneEntity entity) async {
    try {
      final isSaved = await localeDataSource.save(
          entity.toJson(), entity.trackId.toString());
      return right(isSaved);
    } on CacheException catch (_) {
      return left(LocalServiceFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> hasContained(String id) async {
    print(id);
    try {
      final data = localeDataSource.loadList();
      if (data != null) {
        bool isSame = data.results
            .any((element) => element.trackId.toString() == id);
        return Right(isSame);
      }
      return right(false);
    } on CacheException catch (_) {
      return left(LocalServiceFailure());
    }
  }

  @override
  Future<Either<Failure, List<ItuneEntity>>> get() async {
    try {
      final data = localeDataSource.loadList();
      if (data != null) {
        return right(Mapper.toDomain(data).results);
      }
      return const Right([]);
    } on CacheException catch (_) {
      return left(LocalServiceFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final isSaved = await localeDataSource.delete(id);
      return right(isSaved);
    } catch (e) {
      return left(LocalServiceFailure());
    }
  }
}
