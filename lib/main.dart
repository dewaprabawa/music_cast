import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_cast/app_bloc_observer.dart';
import 'package:music_cast/features/music_player/presentation/music_player_cubit/music_player_cubit.dart';
import 'package:music_cast/features/music_player/presentation/pages/music_player_page.dart';
import 'package:music_cast/features/music_playlist/presentation/providers/playlist_model.dart';
import 'package:provider/provider.dart';
import 'features/music_player/presentation/song_data_cubit/song_data_cubit.dart';
import 'inject_container.dart';
import 'register_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await registerHives();
  await inject();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<MusicPlayerCubit>(),
        ),
        BlocProvider(
          create: (context) => locator<SongDataCubit>(),
        ),

        ChangeNotifierProvider<PlaylistModel>(create: (context) => locator<PlaylistModel>()),
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ScaffoldMessenger(child: MusicPlayerPage()),
      ),
    );
  }
}
