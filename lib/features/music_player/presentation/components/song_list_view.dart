
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_cast/commons/constants/constants.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/presentation/components/header_title.dart';
import 'package:music_cast/features/music_player/presentation/music_player_cubit/music_player_cubit.dart';
import 'package:music_cast/features/music_player/presentation/song_data_cubit/song_data_cubit.dart';

class SongListView extends StatelessWidget {
  const SongListView({
    Key? key,
    required this.songs,
    required this.onSelectedSongs,
  }) : super(key: key);

  final List<ItuneEntity> songs;
  final void Function(ItuneEntity, int) onSelectedSongs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const HeaderTitle(
            icon: Icons.timer_outlined,
            leadingText: "Recently Played",
            trailingText: "See all",
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<SongDataCubit>().getSongs();
              },
              child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      child: InkWell(
                        onTap: () {
                          onSelectedSongs(songs[index], index);
                        },
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: songs[index].artworkUrl100 ?? "",
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  imageBuilder: (contex, imageProvider) {
                                    return Container(
                                      width: 110,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
                                    builder: (context, state) {
                                  final bool isPlaying =
                                      state.status == PlayerStatus.playing;
                                  final IconData iconData = isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle;
                                  final bool isSelected =
                                      state.selectedIndexMusic == index;
                                  final bool showIcon = isSelected && isPlaying;
            
                                  return Positioned(
                                    left: 20,
                                    bottom: 35,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 250),
                                      child: showIcon
                                          ? IconButton(
                                              key: ValueKey(iconData),
                                              icon: Icon(
                                                iconData,
                                                size: 50,
                                                color: SharedConstant.nativeWhite,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<MusicPlayerCubit>()
                                                    .setTogglePlay();
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songs[index].trackName ?? "",
                                    style: GoogleFonts.poppins().copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    songs[index].artistName ?? "",
                                    style: GoogleFonts.poppins().copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: SharedConstant.nativeGrey),
                                  ),
                                  Text(
                                    "${songs[index].collectionName}",
                                    style: GoogleFonts.poppins(
                                        color: SharedConstant.purpleApp,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}