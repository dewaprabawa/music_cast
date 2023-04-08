import 'package:flutter/material.dart';

class SharedConstant {
   static String baseURL = "https://itunes.apple.com/search?term=linkin+park";
   
   static int statusPositive = 200;

   static List<String> popularArtist = [
    "My Playlist",
    "Linkin Park",
    "Green Day",
    "Queen",
    "My Chemical Romance",
    "Red Hot Chili Peppers"
   ];

   static Color purpleApp = Color(0xff8773FD);
   static Color greyShade = Colors.grey.shade200;
   static Color blueGray = Colors.blueGrey;
   static Color nativeGrey = Colors.grey;
   static Color nativeWhite = Colors.white;
   static Color softPurplerApp = Color.fromARGB(255, 211, 203, 255);

   static String musicItemKey = "MUSIC_ITEM_KEY";
   static String musicLikeButtonKey = "MUSIC_LIKE_BUTTON_KEY";

   static String musicShowPlaylistButtonKey = "MUSIC_ON_SHOW_PLAYLIST_BUTTON_KEY";
   static String bottomMusicPlayerWidget = "BOTTOM_MUSIC_PLAYER_WIDGET";
}