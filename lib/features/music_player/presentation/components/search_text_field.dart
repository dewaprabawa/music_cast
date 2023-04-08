import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_cast/commons/constants/constants.dart';
import 'package:music_cast/features/music_player/presentation/song_data_cubit/song_data_cubit.dart';
import 'package:music_cast/features/music_player/presentation/music_player_cubit/music_player_cubit.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({Key? key, required this.searchSongController, required this.onChanged, required this.hintText})
      : super(key: key);
  final TextEditingController searchSongController;
  final void Function(String)? onChanged;
  final String hintText; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20, right: 10, bottom: 0.8, top: 0.8),
      child: TextFormField(
        controller: searchSongController,
        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {},
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:  BorderSide(color: SharedConstant.nativeGrey)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:  BorderSide(color: SharedConstant.nativeGrey))),
      ),
    );
  }
}
