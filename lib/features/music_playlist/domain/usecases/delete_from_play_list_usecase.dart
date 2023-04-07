
import 'package:music_cast/commons/errors/errors.dart';
import 'package:dartz/dartz.dart';
import 'package:music_cast/commons/usecase/usecase.dart';
import 'package:music_cast/features/music_playlist/domain/repository/playlist_repository.dart';

class DeleteFromPlaylistUseCase implements UseCase<bool, String> {
  final PlaylistRepository _playlistRepository;
  DeleteFromPlaylistUseCase(this._playlistRepository);
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _playlistRepository.delete(params);
  }

}