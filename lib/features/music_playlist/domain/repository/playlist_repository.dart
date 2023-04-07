

import 'package:dartz/dartz.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';

abstract class PlaylistRepository {
  Future<Either<Failure,List<ItuneEntity>>> get();
  Future<Either<Failure, bool>> hasContained(String artistId);
  Future<Either<Failure, bool>> delete(String id);
  Future<Either<Failure, bool>> put(ItuneEntity entity);
}