import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_cast/commons/constants/constants.dart';

import 'package:music_cast/main.dart' as app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("add favourite song to playlist test", (tester) async {
    app.main();
    await tester.pumpAndSettle();
    final selectedSongToPlay = find.byKey(Key(SharedConstant.musicItemKey)).first;
    final likeButton = find.byKey(Key(SharedConstant.musicLikeButtonKey));
    final playlistButton = find.byKey(Key(SharedConstant.musicShowPlaylistButtonKey));
    await tester.tap(selectedSongToPlay);
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.tap(likeButton);
    await tester.pumpAndSettle();
    await tester.tap(playlistButton);
    await tester.pumpAndSettle(); 
  });
}