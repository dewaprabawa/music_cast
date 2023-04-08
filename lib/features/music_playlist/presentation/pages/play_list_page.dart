import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_cast/commons/constants/constants.dart';
import 'package:music_cast/features/music_player/domain/entities/itunes_entity.dart';
import 'package:music_cast/features/music_player/presentation/components/header_title.dart';
import 'package:music_cast/features/music_playlist/presentation/providers/playlist_model.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistModel>(builder: (context, model, _) {
      var songs = model.playlists;
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const HeaderTitle(
              icon: Icons.star,
              leadingText: "Playlist",
              trailingText: "see all"),
          songs.isEmpty
              ? Column(
                  children: [
                    Text(
                      "Please add your track as playlist.",
                      style: GoogleFonts.dmMono(),
                    ),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Kembali", style: GoogleFonts.dmMono()))
                  ],
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, bottom: 10),
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          songs[index].artworkUrl100 ?? "",
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageBuilder: (contex, imageProvider) {
                                        return Container(
                                          width: 110,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                 InkWell(
                                    onTap: () {
                                      _showConfirmDelete(songs[index]);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: SharedConstant.softPurplerApp,
                                      ),
                                      child: Icon(
                                        Icons.favorite,
                                        color: SharedConstant.purpleApp,
                                      ),
                                    ),
                                  ),
                                
                              ],
                            ),
                          ),
                        );
                      }),
                ),
        ],
      );
    });
  }

  Future<void> _showConfirmDelete(ItuneEntity entity) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Hey!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure want to delete this song from playlist ?', style: GoogleFonts.poppins(fontWeight: FontWeight.w300),),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve', style: GoogleFonts.poppins(color: SharedConstant.softRed),),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PlaylistModel>().deleteSingleSong(entity.trackId!);
            },
          ),
          TextButton(
            child: Text('Cancel', style: GoogleFonts.poppins(color: SharedConstant.purpleApp, fontWeight: FontWeight.w600),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
