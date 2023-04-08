import 'package:dartz/dartz.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:music_cast/commons/usecase/usecase.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/domain/repository/itunes_repository.dart';

class GetSongByNameUseCase implements UseCase<ItuneEntities, String> {
  final ItunesRepository _itunesRepository;
  GetSongByNameUseCase(this._itunesRepository);
  @override
  Future<Either<Failure, ItuneEntities>> call(String params) async {
    return await _itunesRepository.getSongsByName(params);
  }
}