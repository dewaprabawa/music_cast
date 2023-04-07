

import 'package:music_cast/commons/errors/errors.dart';
import 'package:dartz/dartz.dart';
import 'package:music_cast/commons/usecase/usecase.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_playlist/domain/repository/playlist_repository.dart';

class SaveToPlayListUseCase implements UseCase<bool, ItuneEntity>{
  final PlaylistRepository _playlistRepository;
  SaveToPlayListUseCase(this._playlistRepository);
  @override
  Future<Either<Failure, bool>> call(ItuneEntity params) async {
    return await _playlistRepository.put(params);
  }

}