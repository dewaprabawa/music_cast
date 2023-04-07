import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:music_cast/commons/usecase/usecase.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/domain/usecases/get_songs_by_name_use_case.dart';
import 'package:music_cast/features/music_player/domain/usecases/get_songs_use_case.dart';
import 'package:audioplayers/audioplayers.dart';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  late AudioPlayer _audioPlayer;

  late StreamSubscription<Duration> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<void> _onCompletionSubscription;

  MusicPlayerCubit() : super(const MusicPlayerState()) {
    _audioPlayer = AudioPlayer();
  }

  @override
  Future<void> close() {
    _disposeAudioPlayer();
    return super.close();
  }

  void onChangePosition(double seconds) {
    // emit(state.copyWith(duration: Duration(seconds: seconds.toInt())));
  }

  void setIsShowMusicPlayer(bool isShow) {
    if (!isShow) {
      _stopMusic();
      emit(state.copyWith(isShowPlayer: isShow, selectedPlayIndex: -1));
    } else {
      emit(state.copyWith(isShowPlayer: isShow));
    }
  }

  void setSongsToMusicPlayer(List<ItuneEntity> songs) {
    emit(state.copyWith(songs: songs));
  }

  Future<void> playMusic({int? playIndex, ItuneEntity? currentSong}) async {
    try {
      if (currentSong != null) {
        _startListenDurationAndPosition();

        await _audioPlayer.play(UrlSource(currentSong.previewUrl!));

        emit(state.copyWith(
            isShowPlayer: true,
            status: PlayerStatus.playing,
            selectedPlayIndex: playIndex,
            selectedSong: currentSong));
      }
    } on Exception catch (e) {
      _stopMusic();
      debugPrint(e.toString());
    }
  }

  void setTogglePlay() async {
    switch (state.status) {
      case PlayerStatus.playing:
        await _pauseMusic();
        break;
      case PlayerStatus.paused:
        await _resumeMusic();
        break;
      case PlayerStatus.stop:
        await playMusic();
        break;
    }
  }

  Future<void> _resumeMusic() async {
    await _audioPlayer.resume();
    emit(state.copyWith(
      status: PlayerStatus.playing,
    ));
  }

  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
    emit(state.copyWith(
      status: PlayerStatus.stop,
    ));
  }

  Future<void> _pauseMusic() async {
    await _audioPlayer.pause();
    emit(state.copyWith(status: PlayerStatus.paused));
  }

  void _startListenDurationAndPosition() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      emit(state.copyWith(
          max: _toSecondsDouble(duration),
          durationText: _toSecondsString(duration)));
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      emit(state.copyWith(
          value: _toSecondsDouble(position),
          positionText: _toSecondsString(position)));
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      int currentPlayIndex = state.selectedIndexMusic;
      if (currentPlayIndex < state.songs.length - 1) {
        currentPlayIndex++;
        playMusic(
            playIndex: currentPlayIndex,
            currentSong: state.songs[currentPlayIndex]);
      } else {
        currentPlayIndex = 0;
        playMusic(
            playIndex: currentPlayIndex,
            currentSong: state.songs[currentPlayIndex]);
      }
      // emit(state.copyWith(positionText: "0", status: PlayerStatus.stop));
    });
  }

  String _toSecondsString(Duration? duration) {
    return duration.toString().split(".")[0];
  }

  double _toSecondsDouble(Duration? duration) {
    return duration == null ? 0.0 : duration.inSeconds.toDouble();
  }

  void _disposeAudioPlayer() {
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _onCompletionSubscription.cancel();
    _audioPlayer.dispose();
  }
}
