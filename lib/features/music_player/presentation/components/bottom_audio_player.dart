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
        padding: const EdgeInsets.fromLTRB(15, 5, 10, 10),
        height: MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(color: SharedConstant.nativeWhite, boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, -1),
              blurRadius: 0.01,
              spreadRadius: 0.2)
        ]),
        child: Row(
          children: [
            _songImageDetail(context, state),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _songInformationDetail(context, state),
                  _musicControllerDetail(context, state),
                ],
              ),
            ),
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
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.repeat,
              color: SharedConstant.nativeGrey,
            )),
        Consumer<PlaylistModel>(builder: (context, model, _) {
          return IconButton(
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
    return Stack(
      children: [
        ClipRRect(
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
            )),
        Positioned(
          left: 10,
          bottom: 35,
          child: IconButton(
            icon: Icon(
              state.status == PlayerStatus.playing
                  ? Icons.pause_circle
                  : Icons.play_circle,
              size: 50,
              color: SharedConstant.nativeWhite,
            ),
            onPressed: () {
              context.read<MusicPlayerCubit>().setTogglePlay();
            },
          ),
        ),
      ],
    );
  }
}
