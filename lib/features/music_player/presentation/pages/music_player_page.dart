import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_cast/commons/constants/constants.dart';
import 'package:music_cast/commons/internet_checker/internet_connection_helper.dart';
import 'package:music_cast/features/music_player/presentation/components/bottom_audio_player.dart';
import 'package:music_cast/features/music_player/presentation/components/build_artist_card.dart';
import 'package:music_cast/features/music_player/presentation/components/header_title.dart';
import 'package:music_cast/features/music_player/presentation/components/search_text_field.dart';
import 'package:music_cast/features/music_player/presentation/components/song_list_view.dart';
import 'package:music_cast/features/music_player/presentation/music_player_cubit/music_player_cubit.dart';
import 'package:music_cast/features/music_player/presentation/song_data_cubit/song_data_cubit.dart';
import 'package:music_cast/features/music_playlist/presentation/pages/play_list_page.dart';
import 'package:music_cast/features/music_playlist/presentation/providers/playlist_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with TickerProviderStateMixin {
  ///Controllers
  late TextEditingController searchSongController;
  late ScrollController scrollController;

  ///Animations
  late AnimationController audioBottomAnimationController;
  late Animation<Offset> offsetAudioBottomField;

  @override
  void initState() {
    searchSongController = TextEditingController();
    scrollController = ScrollController();

    audioBottomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    offsetAudioBottomField =
        Tween(begin: const Offset(0.0, -0.01), end: Offset.zero).animate(
      CurvedAnimation(
        parent: audioBottomAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    context.read<SongDataCubit>().getSongs();
    super.initState();
  }

  @override
  void dispose() {
    audioBottomAnimationController.dispose();
    searchSongController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SongDataCubit, SongDataState>(
          listener: (context, state) async {
            // conditional statement that checks if the stateStatus property of the state object is set to success
            if (state.stateStatus == StateStatus.success) {
              // uses the context object to read the MusicPlayerCubit instance
              context
                  .read<MusicPlayerCubit>()
                  .setSongsToMusicPlayer(state.data.results);
              // calls the setSongsToMusicPlayer method of the MusicPlayerCubit instance
              //and passes in the results property of the data object of the state
              context.read<MusicPlayerCubit>().setIsShowMusicPlayer(false);
              // calls the setIsShowMusicPlayer method of the MusicPlayerCubit instance and passes in the value false
              if (!await InternetConnectionHelper.hasInternet()) {
                _showAlertTopScreen(BuildContext, "Your internet is off...");
              }
               // check device connection that notify the user
            } 
          },
        ),
        BlocListener<MusicPlayerCubit, MusicPlayerState>(
          listener: (context, state) {
            if (state.selectedSong != null) {
              if (context.read<MusicPlayerCubit>().indexIsChanging) {
                context
                    .read<PlaylistModel>()
                    .startCheckIsSaveInPlaylist(state.selectedSong!);
              }
            }
          },
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: const BottomAudioPlayer(),
        backgroundColor: SharedConstant.nativeWhite,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SearchTextField(
                hintText: "Artist, Songs, Trailer ....",
                searchSongController: searchSongController,
                onChanged: (value) {
                  context.read<SongDataCubit>().getSongsByName(value);
                  context.read<MusicPlayerCubit>().setIsShowMusicPlayer(false);
                },
              ),
              const HeaderTitle(
                icon: Icons.star,
                leadingText: 'Popular artist',
                trailingText: 'see all',
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: List.generate(
                        SharedConstant.popularArtist.length,
                        (index) => BuildArtistCard(
                            onTapPopularArtist: () async {
                              context.read<SongDataCubit>().getSongsByName(
                                  SharedConstant.popularArtist[index]);
                              context
                                  .read<MusicPlayerCubit>()
                                  .setIsShowMusicPlayer(false);
                            },
                            onTapMyPlaylist: () async {
                              await context
                                  .read<PlaylistModel>()
                                  .startFetchPlaylist()
                                  .whenComplete(() {
                                _showBottomSheet(context);
                              });
                            },
                            artistName: SharedConstant.popularArtist[index],
                            index: index)),
                  ),
                ),
              ),
              BlocBuilder<SongDataCubit, SongDataState>(
                  builder: (context, state) {
                switch (state.stateStatus) {
                  case StateStatus.initial:
                  case StateStatus.loading:
                    return const _LoadingCircularProgressIndicator();
                  case StateStatus.success:
                    return SongListView(
                      songs: state.data.results,
                      onSelectedSongs: (selectedSong, playIndex) async {
                        if (!await InternetConnectionHelper.hasInternet()) {
                          return _showAlertTopScreen(
                              BuildContext, "Your internet is off...");
                        }

                        if (context.read<MusicPlayerCubit>().state.status ==
                                PlayerStatus.playing &&
                            context
                                    .read<MusicPlayerCubit>()
                                    .state
                                    .selectedIndexMusic ==
                                playIndex) {
                          context.read<MusicPlayerCubit>().setTogglePlay();
                          // If the music player is currently playing the selected song,
                          // toggle the play/pause state
                        } else {
                          // If the music player is not playing the selected song,
                          // start playing the selected song using the `playMusic` function
                          context.read<MusicPlayerCubit>().playMusic(
                              currentSong: selectedSong, playIndex: playIndex);
                        }
                        // After playing the song, check if it is already saved in the playlist
                        context
                            .read<PlaylistModel>()
                            .startCheckIsSaveInPlaylist(selectedSong);
                      },
                    );
                  case StateStatus.failure:
                  case StateStatus.empty:
                    return _ErrorMessage(
                      message: state.errorMessage,
                      onChangedToRefresh: () async {
                        await context.read<SongDataCubit>().getSongs();
                      },
                    );
                  default:
                    return const SizedBox();
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PlaylistPage();
      },
    );
  }

  void _showAlertTopScreen(BuildContext, String message) {
    final snackBar = SnackBar(
      content: Text(message, style: GoogleFonts.dmMono()),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(top: 70.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;
  final Function()? onChangedToRefresh;
  const _ErrorMessage({Key? key, this.message = "", this.onChangedToRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            message,
            style: GoogleFonts.dmMono(),
          ),
          OutlinedButton(
              onPressed: onChangedToRefresh,
              child: Text("Refresh", style: GoogleFonts.dmMono()))
        ],
      ),
    );
  }
}

class _LoadingCircularProgressIndicator extends StatelessWidget {
  const _LoadingCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 110,
                  height: 100,
                  color: SharedConstant.nativeWhite,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: SharedConstant.nativeWhite,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: SharedConstant.nativeWhite,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: SharedConstant.nativeWhite,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          itemCount: 6,
        ),
      ),
    );
  }
}
