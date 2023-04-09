import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_cast/commons/errors/exceptions.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';

abstract class LocaleSongDataSource {
  ItunesModel? loadList(String key);
  Future<bool> save(dynamic response, String key);
}

class HiveSongDataSourceImpl implements LocaleSongDataSource {
  final Box _hive;

  HiveSongDataSourceImpl(this._hive);

  @override
  ItunesModel? loadList(String key) {
    try {
      dynamic response = _hive.get(key);
      if (response is List<dynamic>) {
        List<Map<String, dynamic>> data =
            response.map((e) => Map<String, dynamic>.from(e)).toList();
        if (data.isNotEmpty) {
          return ItunesModel(
              results: data.map(((e) => ItuneModel.fromJson(e))).toList());
        }
      }

      return null;
    } catch (e) {
      debugPrint(e.toString() + ' load function hive');
      throw CacheException();
    }
  }

  @override
  Future<bool> save(dynamic response, String key) async {
    try {
      await _hive.put(key, response);
      return true;
    } catch (e) {
      debugPrint(e.toString() + ' save function hive');
      return false;
    }
  }
}
