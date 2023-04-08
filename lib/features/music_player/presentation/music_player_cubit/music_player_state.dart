part of 'music_player_cubit.dart';

enum PlayerStatus { playing, paused, stop }

class MusicPlayerState extends Equatable {
  const MusicPlayerState({
    this.isShowMusicPlayer = false,
    this.status = PlayerStatus.stop,
    this.selectedIndexMusic = -1,
    this.selectedSong,
    this.durationText = "0:00:00",
    this.positionText = "0:00:00",
    this.max = 0.0,
    this.value = 0.0,
    this.isRepeated = false,
    this.songs = const [],
  });

  final List<ItuneEntity> songs;
  final bool isShowMusicPlayer;
  final PlayerStatus status;
  final int selectedIndexMusic;
  final ItuneEntity? selectedSong;
  final String durationText;
  final String positionText;
  final double max;
  final double value;
  final bool isRepeated;

  MusicPlayerState copyWith({
    bool? isShowPlayer,
    bool? isRepeated,
    PlayerStatus? status,
    int? selectedPlayIndex,
    ItuneEntity? selectedSong,
    List<ItuneEntity>? songs,
    String? durationText,
    String? positionText,
    double? value,
    double? max,
  }) {
    return MusicPlayerState(
       isRepeated: isRepeated ?? this.isRepeated,
        isShowMusicPlayer: isShowPlayer ?? this.isShowMusicPlayer,
        status: status ?? this.status,
        selectedIndexMusic: selectedPlayIndex ?? this.selectedIndexMusic,
        songs: songs ?? this.songs,
        selectedSong: selectedSong ?? this.selectedSong,
        positionText: positionText ?? this.positionText,
        durationText: durationText ?? this.durationText,
        max: max ?? this.max,
        value: value ?? this.max);
  }

  @override
  List<Object?> get props => [
        isShowMusicPlayer,
        durationText,
        positionText,
        status,
        songs,
        selectedIndexMusic,
        selectedSong,
        isRepeated,
        max,
        value
      ];
}
