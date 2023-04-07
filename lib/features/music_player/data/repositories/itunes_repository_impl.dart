import 'package:dartz/dartz.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:music_cast/commons/errors/exceptions.dart';
import 'package:music_cast/commons/internet_checker/network_checker.dart';
import 'package:music_cast/features/music_player/data/data_source/locale_data_source.dart';
import 'package:music_cast/features/music_player/data/data_source/remote_data_source.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/domain/repository/itunes_repository.dart';


const key = "result";
const favKey = "favourite";

class ItunesRepositoryImpl implements ItunesRepository {
  final LocaleSongDataSource localeDataSource;
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ItunesRepositoryImpl(
      {required this.localeDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, ItuneEntities>> getSongs({int limit = 20}) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.getSongs(limit: limit);
        await localeDataSource.save(
              data.results.map((e) => e.toJson()).toList(), key);
        return Right(Mapper.toDomain(data));
      } on ServerException {
        return Left(RemoteServerFailure());
      }
    } else {
      try {
        final data = localeDataSource.loadList(key);
        if(data != null){
          return Right(Mapper.toDomain(data));
        }
        return const Right(ItuneEntities(results: []));
      } on CacheException {
        return Left(LocalServiceFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ItuneEntities>> getSongsByName(String name) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.getSongsByName(name);
         await localeDataSource.save(
              Mapper.resultListToString(data.results), key);
         return Right(Mapper.toDomain(data));
      } on ServerException {
        return Left(RemoteServerFailure());
      }
    } else {
      try {
          final data = localeDataSource.loadList(key);
        if(data != null){
          return Right(Mapper.toDomain(data));
        }
         return const Right(ItuneEntities(results: []));
      } on CacheException {
        return Left(LocalServiceFailure());
      }
    }
  }
}
