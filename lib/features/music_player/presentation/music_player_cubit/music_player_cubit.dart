import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:audioplayers/audioplayers.dart';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  late AudioPlayer _audioPlayer;

  late StreamSubscription<Duration> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<void> _onCompletionSubscription;
  // The following three subscriptions are used to listen for changes to the player's duration, position, and completion

// Initialize the audio player.
  MusicPlayerCubit() : super(const MusicPlayerState()) {
    _audioPlayer = AudioPlayer();
  }
  // Close the audio player.
  @override
  Future<void> close() {
    _disposeAudioPlayer();
    return super.close();
  }

  bool get indexIsChanging => _indexIsChangingCount != 0;
  int _indexIsChangingCount = 0;

  // Changes the position of the song.
  void onChangePosition(double seconds) {
    // emit(state.copyWith(duration: Duration(seconds: seconds.toInt())));
  }
  // Shows or hides the music player.
  void setIsShowMusicPlayer(bool isShow) {
    if (!isShow) {
      _stopMusic();
      emit(state.copyWith(isShowPlayer: isShow, selectedPlayIndex: -1));
    } else {
      emit(state.copyWith(isShowPlayer: isShow));
    }
  }

  // Sets the list of songs to the music player.
  void setSongsToMusicPlayer(List<ItuneEntity> songs) {
    emit(state.copyWith(songs: songs));
  }

  // Sets the list of songs to the music player.
  void setRepeatMode(bool isRepeated) {
    emit(state.copyWith(isRepeated: isRepeated));
  }

  //play next selected song to the music player.
  void playNext() async {
    if (state.songs.isNotEmpty) {
      int prevIndex = 0;
      if (state.selectedIndexMusic < state.songs.length - 1) {
        prevIndex = state.selectedIndexMusic;
        state.copyWith(selectedPlayIndex: prevIndex++);
      }
      playMusic(playIndex: prevIndex, currentSong: state.songs[prevIndex]);
    }
  }

  //play previous selected song to the music player.
  void playPrevius() {
    if (state.songs.isNotEmpty) {
      int prevIndex = 0;
      if (state.selectedIndexMusic <= 0) {
        prevIndex = state.songs.length - 1;
      } else {
        prevIndex = state.selectedIndexMusic - 1;
      }
      playMusic(playIndex: prevIndex, currentSong: state.songs[prevIndex]);
    }
  }

  Future<void> _setPathURLsong(String? url) async {
    await _audioPlayer.play(UrlSource(url ?? ""));
  }

  // Plays the selected song.
  Future<void> playMusic({int? playIndex, ItuneEntity? currentSong}) async {
    try {
      if (currentSong != null) {
        _startListenDurationAndPosition();

        await _setPathURLsong(currentSong.previewUrl);

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

  // Toggles play/pause of the song.
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

  // Resumes the song.
  Future<void> _resumeMusic() async {
    await _audioPlayer.resume();
    emit(state.copyWith(
      status: PlayerStatus.playing,
    ));
  }

// Stops the song.
  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
    emit(state.copyWith(
      status: PlayerStatus.stop,
    ));
  }

  // Pauses the song.
  Future<void> _pauseMusic() async {
    await _audioPlayer.pause();
    emit(state.copyWith(status: PlayerStatus.paused));
  }

  // Starts listening to duration and position of the song.
  void _startListenDurationAndPosition() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      emit(state.copyWith(
          max: _toSecondsDouble(duration),
          durationText: _toSecondsString(duration)));
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      // print("--seconds--${position.inSeconds}");
      emit(state.copyWith(
          value: _toSecondsDouble(position),
          positionText: _toSecondsString(position)));
    });

    _onCompletionSubscription =
        _audioPlayer.onPlayerComplete.listen((event) async {
      if (state.isRepeated) {
        playMusic(
            playIndex: state.selectedIndexMusic,
            currentSong: state.selectedSong);
        return;
      }

      // When the player has finished playing a song, determine the index of the current song
      int currentPlayIndex = state.selectedIndexMusic;
      if (currentPlayIndex < state.songs.length - 1) {
        _indexIsChangingCount += 1;

        // If there are more songs in the playlist, play the next song
        currentPlayIndex++;
        playMusic(
            playIndex: currentPlayIndex,
            currentSong: state.songs[currentPlayIndex]);
        await Future.delayed(const Duration(milliseconds: 1000));
        _indexIsChangingCount -= 1;
      } else {
        _indexIsChangingCount += 1;
        // If the last song in the playlist has been played, start playing from the beginning
        currentPlayIndex = 0;
        playMusic(
            playIndex: currentPlayIndex,
            currentSong: state.songs[currentPlayIndex]);
        await Future.delayed(const Duration(milliseconds: 1000));
        _indexIsChangingCount -= 1;
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
