import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_cast/commons/constants/constants.dart';
import 'package:music_cast/features/music_player/presentation/music_player_cubit/music_player_cubit.dart';
import 'package:music_cast/features/music_playlist/presentation/providers/playlist_model.dart';
import 'package:provider/provider.dart';

class BottomAudioPlayer extends StatelessWidget {
  const BottomAudioPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
        builder: (context, state) {
      if (!state.isShowMusicPlayer) {
        return const SizedBox.shrink();
      }
      return Container(
        key: Key(SharedConstant.bottomMusicPlayerWidget),
        padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
        height: MediaQuery.of(context).size.height * 0.25,
        decoration:
            BoxDecoration(color: SharedConstant.nativeWhite, boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, -1),
              blurRadius: 0.01,
              spreadRadius: 0.2)
        ]),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _songImageDetail(context, state),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _songInformationDetail(context, state),
                      _musicControllerDetail(context, state),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        context.read<MusicPlayerCubit>().playPrevious();
                      },
                      icon: Icon(
                        Icons.skip_previous,
                        size: 50,
                      )),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      state.status == PlayerStatus.playing
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      size: 50,
                    ),
                    onPressed: () {
                      context.read<MusicPlayerCubit>().setTogglePlay();
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        context.read<MusicPlayerCubit>().playNext();
                      },
                      icon: Icon(
                        Icons.skip_next,
                        size: 50,
                      )),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _musicControllerDetail(BuildContext context, MusicPlayerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          state.positionText,
          style: GoogleFonts.poppins(color: SharedConstant.nativeGrey),
        ),
        Slider(
            min: const Duration(seconds: 0).inSeconds.toDouble(),
            max: state.max,
            thumbColor: SharedConstant.blueGray,
            activeColor: SharedConstant.purpleApp,
            inactiveColor: SharedConstant.softPurplerApp,
            value: state.value,
            onChanged: (value) {
              context.read<MusicPlayerCubit>().onChangePosition(value);
            }),
        Text(state.durationText,
            style: GoogleFonts.poppins(color: SharedConstant.nativeGrey)),
      ],
    );
  }

  Widget _songInformationDetail(BuildContext context, MusicPlayerState state) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${state.selectedSong!.trackName}",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${state.selectedSong!.artistName}",
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade400, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "${state.selectedSong!.collectionName}",
              style: GoogleFonts.poppins(
                  color: SharedConstant.purpleApp, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
            builder: (context, state) {
          return IconButton(
              onPressed: () {
                context
                    .read<MusicPlayerCubit>()
                    .setRepeatMode(!state.isRepeated);
              },
              icon: Icon(
                state.isRepeated ? Icons.repeat_one : Icons.repeat,
                color: state.isRepeated
                    ? SharedConstant.purpleApp
                    : SharedConstant.nativeGrey,
              ));
        }),
        Consumer<PlaylistModel>(builder: (context, model, _) {
          return IconButton(
              // tooltip: SharedConstant.musicLikeButtonKey,
              key: Key(SharedConstant.musicLikeButtonKey),
              onPressed: () {
                context
                    .read<PlaylistModel>()
                    .setToggle(!model.toggleSave, state.selectedSong!);
              },
              icon: Icon(
                model.toggleSave ? Icons.favorite : Icons.favorite_outline,
                color: model.toggleSave
                    ? SharedConstant.purpleApp
                    : SharedConstant.nativeGrey,
              ));
        })
      ],
    );
  }

  Widget _songImageDetail(BuildContext context, MusicPlayerState state) {
    return  ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              state.selectedSong!.artworkUrl100!,
              width: 90,
              height: 110,
              fit: BoxFit.fill,
              errorBuilder: (context, object, err) {
                return const Icon(
                  Icons.image,
                  size: 100,
                );
              },
            ));
  }
}
