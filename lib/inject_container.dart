import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:music_cast/commons/internet_checker/network_checker.dart';
import 'package:music_cast/features/music_player/data/data_source/locale_data_source.dart';
import 'package:music_cast/features/music_player/data/data_source/remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:music_cast/features/music_player/data/repositories/itunes_repository_impl.dart';
import 'package:music_cast/features/music_player/domain/repository/itunes_repository.dart';
import 'package:music_cast/features/music_player/domain/usecases/get_songs_by_name_use_case.dart';
import 'package:music_cast/features/music_player/domain/usecases/get_songs_use_case.dart';
import 'package:music_cast/features/music_player/presentation/song_data_cubit/song_data_cubit.dart';
import 'package:music_cast/features/music_player/presentation/music_player_cubit/music_player_cubit.dart';
import 'package:music_cast/features/music_playlist/data/local_data_source/local_data_source.dart';
import 'package:music_cast/features/music_playlist/data/repositpry/playlist_repository_impl.dart';
import 'package:music_cast/features/music_playlist/domain/repository/playlist_repository.dart';
import 'package:music_cast/features/music_playlist/domain/usecases/check_is_save_in_playlist_usecase.dart';
import 'package:music_cast/features/music_playlist/domain/usecases/delete_from_play_list_usecase.dart';
import 'package:music_cast/features/music_playlist/domain/usecases/fetch_playlist_usecase.dart';
import 'package:music_cast/features/music_playlist/presentation/providers/playlist_model.dart';

import 'commons/box_name/hive_box_name.dart';
import 'features/music_playlist/domain/usecases/save_to_play_list_usecase.dart';

final locator = GetIt.instance;

Future<void> inject() async {
  ///Network checkker
  locator.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  ///hive
  final boxItunes = Hive.box(HiveBoxName.songs);
  final boxPlaylist = Hive.box(HiveBoxName.playlist);

  ///Local Data Source
  locator.registerLazySingleton<LocaleSongDataSource>(() => HiveSongDataSourceImpl(boxItunes));
  locator.registerLazySingleton<LocalePlaylistDataSource>(() => HivePlaylistDataSourceImpl(boxPlaylist));

  ///Remote Data Source
  locator.registerLazySingleton<http.Client>(() => http.Client());
  locator.registerLazySingleton<RemoteDataSource>(() => RemoteDataServiceImpl(locator()));

  ///Repository
  locator.registerLazySingleton<ItunesRepository>(() => ItunesRepositoryImpl(
      localeDataSource: locator(), remoteDataSource: locator(), networkInfo: locator()));
  locator.registerLazySingleton<PlaylistRepository>(() => PlaylistRepositoryImpl(locator()));    

  /// Use cases
  locator.registerLazySingleton<GetSongUseCase>(() => GetSongUseCase(locator()));
  locator.registerLazySingleton<GetSongByNameUseCase>(
      () => GetSongByNameUseCase(locator()));
  locator.registerLazySingleton<CheckIsSaveInPlaylistUseCase>(() => CheckIsSaveInPlaylistUseCase(locator())); 
  locator.registerLazySingleton<FetchPlaylistUseCase>(() => FetchPlaylistUseCase(locator()));   
  locator.registerLazySingleton<SaveToPlayListUseCase>(() => SaveToPlayListUseCase(locator()));
  locator.registerLazySingleton<DeleteFromPlaylistUseCase>(() => DeleteFromPlaylistUseCase(locator()));

  ///bloc
  locator.registerFactory<MusicPlayerCubit>(() => MusicPlayerCubit());

  //Provider
  locator.registerFactory<PlaylistModel>(() => PlaylistModel(locator(), locator(), locator(), locator()));

  locator.registerFactory<SongDataCubit>(
      () => SongDataCubit(getSongByNameUseCase: locator(), getSongUseCase: locator()));
}
