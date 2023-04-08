import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:music_cast/commons/usecase/usecase.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_playlist/domain/usecases/check_is_save_in_playlist_usecase.dart';
import 'package:music_cast/features/music_playlist/domain/usecases/delete_from_play_list_usecase.dart';
import 'package:music_cast/features/music_playlist/domain/usecases/fetch_playlist_usecase.dart';
import 'package:music_cast/features/music_playlist/domain/usecases/save_to_play_list_usecase.dart';

enum PlaylistStatus { Initial, Progress, Success, Failure }

class PlaylistModel extends ChangeNotifier {
  final CheckIsSaveInPlaylistUseCase _checkIsSaveInPlaylistUseCase;
  final FetchPlaylistUseCase _fetchPlaylistUseCase;
  final SaveToPlayListUseCase _saveToPlayListUseCase;
  final DeleteFromPlaylistUseCase _deleteFromPlaylistUseCase;

  // A list of entities representing the current playlist.
  List<ItuneEntity> _playlists = [];

  // A boolean value to track whether an item in the playlist is selected.
  bool _toggleSave = false;

  // The current status of the playlist model.
  PlaylistStatus _status = PlaylistStatus.Initial;

  // Getters for the properties of the playlist model.
  bool get toggleSave => _toggleSave;
  PlaylistStatus get status => _status;
  List<ItuneEntity> get playlists => _playlists;

  // Constructor for the playlist model.
  PlaylistModel(
    this._checkIsSaveInPlaylistUseCase,
    this._fetchPlaylistUseCase,
    this._saveToPlayListUseCase,
    this._deleteFromPlaylistUseCase,
  );

  // Fetches the playlist.
  Future<void> startFetchPlaylist() async {
    _setState(seStatus: PlaylistStatus.Progress);
    await _fetchPlaylistUseCase.call(NoParams()).then((either) {
      either.fold((l) {
        _setState(seStatus: PlaylistStatus.Failure);
      }, (r) {
        _setState(seStatus: PlaylistStatus.Success, playlist: r);
      });
    });
  }

  // Checks whether an item is saved in the playlist.
  Future<void> startCheckIsSaveInPlaylist(ItuneEntity entity) async {
    await _checkIsSaveInPlaylistUseCase
        .call(entity.trackId.toString())
        .then((either) {
      either.fold((l) {
        _toggleSave = false;
        notifyListeners();
      }, (r) {
        _toggleSave = r;
        debugPrint("---startCheckIsSaveInPlaylist--- ${r}");
        notifyListeners();
      });
    });
  }

  // Sets the value of the toggle.
  void setToggle(bool isSave, ItuneEntity entity) async {
    _toggleSave = isSave;
    if (_toggleSave) {
      debugPrint("---_saveToPlayListUseCase---");
      await _saveToPlayListUseCase.call(entity);
    } else {
      debugPrint("---_deleteFromPlaylistUseCase---");
      await _deleteFromPlaylistUseCase.call(entity.trackId.toString());
    }
    notifyListeners();
  }

   // delete the value of selected song.
  void deleteSingleSong(int id) async {
      debugPrint("---_deleteFromPlaylistUseCase---");
      await _deleteFromPlaylistUseCase.call(id.toString()).then((either){
        either.fold((_){
            debugPrint("---Failure in delete playlist song---");
        }, (r){
          this._playlists.removeWhere((element) => element.trackId == id);
        });
      });
    notifyListeners();
  }

  // Sets the state of the playlist model.
  void _setState(
      {PlaylistStatus seStatus = PlaylistStatus.Initial,
      List<ItuneEntity>? playlist}) {
    _status = seStatus;
    _playlists = playlist ?? _playlists;
    notifyListeners();
  }
}
