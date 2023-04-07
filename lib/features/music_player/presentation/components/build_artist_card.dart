import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_cast/commons/box_name/hive_box_name.dart';
import 'package:music_cast/commons/constants/constants.dart';
import 'package:music_cast/features/music_player/presentation/song_data_cubit/song_data_cubit.dart';
import 'package:music_cast/features/music_player/presentation/music_player_cubit/music_player_cubit.dart';
import 'package:music_cast/features/music_playlist/presentation/providers/playlist_model.dart';

class BuildArtistCard extends StatelessWidget {
  const BuildArtistCard(
      {Key? key, required this.artistName, required this.index})
      : super(key: key);
  final String artistName;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (artistName == "My Playlist") {
      return InkWell(
        onTap: () async {
          await context.read<PlaylistModel>().startFetchPlaylist();
        },
        child: ValueListenableBuilder(
            valueListenable: Hive.box(HiveBoxName.playlist).listenable(),
            builder: (context, Box box, _) {
              return Stack(
                children: [
                  Container(
                    width: 100,
                    height: 50,
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: SharedConstant.blueGray),
                        borderRadius: BorderRadius.circular(12),
                        color: SharedConstant.greyShade),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            artistName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                        const Icon(Icons.playlist_play)
                      ],
                    ),
                  ),
                  box.values.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                          height: 25,
                          width: 25,
                          child: Center(
                              child: Text(
                            box.values.length.toString(),
                            style: GoogleFonts.poppins(color: Colors.white),
                          )),
                          decoration: BoxDecoration(
                              color: SharedConstant.purpleApp,
                              borderRadius: BorderRadius.circular(30)),
                        )
                ],
              );
            }),
      );
    } else {
      return InkWell(
        onTap: () {
          context.read<SongDataCubit>().getSongsByName(artistName);
          context.read<MusicPlayerCubit>().setIsShowMusicPlayer(false);
        },
        child: Container(
          margin: EdgeInsets.only(right: index == 4 ? 10 : 10),
          decoration: BoxDecoration(
              border: Border.all(color: SharedConstant.greyShade),
              borderRadius: BorderRadius.circular(12),
              color: SharedConstant.greyShade),
          width: 100,
          height: 50,
          child: Center(
            child: Text(
              artistName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }
  }
}
