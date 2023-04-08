import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_cast/commons/errors/exceptions.dart';
import 'package:music_cast/features/music_player/data/data_source/locale_data_source.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';

abstract class LocalePlaylistDataSource {
  ItunesModel? loadList();
  Future<bool> save(dynamic response, String key);
  Future<bool> delete(String key);
}

class HivePlaylistDataSourceImpl implements LocalePlaylistDataSource {
  final Box _hive;

  HivePlaylistDataSourceImpl(this._hive);

  @override
  Future<bool> delete(String key) async {
    try {
     await _hive.delete(key).then((_) => true);
    } catch (e) {
       debugPrint(e.toString() + ' delete function hive');
      throw CacheException();
    }
    return false;
  }

  @override
  ItunesModel? loadList() {
    try {
      if (_hive.values.isEmpty) return null;
      List<Map<String, dynamic>> playlist = _hive.values
          .map((element) => Map<String, dynamic>.from(element))
          .toList();
      List<ItuneModel> savedOnes = playlist.map((data)
       => ItuneModel.fromJson(data)).toList();    
      return ItunesModel(
          results:savedOnes);
    } catch (e) {
      debugPrint(e.toString() + ' load function hive');
      throw CacheException();
    }
  }

  @override
  Future<bool> save(response, String key) async {
    try {
      await _hive.put(key, response).then((_) => true);
    } catch (e) {
      debugPrint(e.toString() + ' save function hive');
      throw CacheException();
    }
    return false;
  }
}
