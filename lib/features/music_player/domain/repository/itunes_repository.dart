import 'package:dartz/dartz.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';


abstract class ItunesRepository {
  Future<Either<Failure, ItuneEntities>> getSongs();
  Future<Either<Failure, ItuneEntities>> getSongsByName(String query);
}