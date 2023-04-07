
import 'package:dartz/dartz.dart';
import 'package:music_cast/commons/errors/errors.dart';
import 'package:music_cast/commons/usecase/usecase.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_playlist/domain/repository/playlist_repository.dart';

class FetchPlaylistUseCase implements UseCase<List<ItuneEntity>,NoParams>{
  final PlaylistRepository _playlistRepository;
  FetchPlaylistUseCase(this._playlistRepository);
  @override
  Future<Either<Failure, List<ItuneEntity>>> call(NoParams params) async {
    return await _playlistRepository.get();
  }
}