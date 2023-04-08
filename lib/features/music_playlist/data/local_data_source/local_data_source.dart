import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_cast/commons/errors/exceptions.dart';
import 'package:music_cast/features/music_player/data/data_source/locale_data_source.dart';
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';

// Abstract class that defines the methods required for loading, saving, and deleting a playlist
abstract class LocalePlaylistDataSource {
  ItunesModel? loadList();// Method to load the playlist
  Future<bool> save(dynamic response, String key);// Method to save the playlist
  Future<bool> delete(String key);// Method to delete the playlist
}

// Implementation of the LocalePlaylistDataSource using Hive as the underlying data storage mechanism
class HivePlaylistDataSourceImpl implements LocalePlaylistDataSource {
  final Box _hive;
  // Constructor that takes a Hive box as input
  HivePlaylistDataSourceImpl(this._hive);
  // Implementation of the delete method that deletes a playlist from the Hive box
  @override
  Future<bool> delete(String key) async {
    try {
       // Use the Hive box to delete the playlist with the given key
     await _hive.delete(key).then((_) => true);
    } catch (e) {
        // Handle any exceptions that occur and throw a CacheException
       debugPrint(e.toString() + ' delete function hive');
      throw CacheException();
    }
    return false;
  }

  // Implementation of the loadList method that loads a playlist from the Hive box
  @override
  ItunesModel? loadList() {
    try {
      // Check if the Hive box is empty and return null if it is
      if (_hive.values.isEmpty) return null;
      // Otherwise, create a list of maps from the Hive box values and convert them to ItuneModel objects
      List<Map<String, dynamic>> playlist = _hive.values
          .map((element) => Map<String, dynamic>.from(element))
          .toList();
          // Return the ItunesModel object that contains the list of ItuneModel objects
      List<ItuneModel> savedOnes = playlist.map((data)
       => ItuneModel.fromJson(data)).toList();    
      return ItunesModel(
          results:savedOnes);
    } catch (e) {
        // Handle any exceptions that occur and throw a CacheException
      debugPrint(e.toString() + ' load function hive');
      throw CacheException();
    }
  }

// Implementation of the save method that saves a playlist to the Hive box
  @override
  Future<bool> save(response, String key) async {
    try {
       // Use the Hive box to save the playlist with the given key and response
      await _hive.put(key, response).then((_) => true);
    } catch (e) {
        // Handle any exceptions that occur and throw a CacheException
      debugPrint(e.toString() + ' save function hive');
      throw CacheException();
    }
    return false;
  }
}
