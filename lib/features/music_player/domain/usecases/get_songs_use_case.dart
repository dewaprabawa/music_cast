import 'package:music_cast/commons/errors/errors.dart';
import 'package:dartz/dartz.dart';
import 'package:music_cast/commons/usecase/usecase.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/domain/repository/itunes_repository.dart';

class GetSongUseCase implements UseCase<ItuneEntities, ParamLimit> {
  final ItunesRepository itunesRepository;
  GetSongUseCase(this.itunesRepository);

  @override
  Future<Either<Failure, ItuneEntities>> call(ParamLimit params) async {
    return await itunesRepository.getSongs();
  }
}

class ParamLimit {
  final int limit;
  ParamLimit({this.limit = 10});
}
