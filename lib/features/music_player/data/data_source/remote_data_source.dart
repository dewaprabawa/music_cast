import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_cast/features/music_player/data/models/itunes_model.dart';
import 'package:music_cast/commons/constants/constants.dart';
import 'package:music_cast/commons/errors/errors.dart';

abstract class RemoteDataSource {
  Future<ItunesModel> getSongs({int limit = 20});
  Future<ItunesModel> getSongsByName(String name);
}

class RemoteDataServiceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataServiceImpl(this.client);

  @override
  Future<ItunesModel> getSongsByName(String name) async {
    final Uri url =
        Uri.parse("https://itunes.apple.com/search?term=$name&limit=10");
    debugPrint(url.toString());
    try {
      http.Response response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());
      dynamic decodedResult = jsonDecode(response.body);
      return ItunesModel.fromJson(decodedResult);
    } catch (exception) {
      throw RemoteServerFailure();
    }
  }

  @override
  Future<ItunesModel> getSongs({int limit = 20}) async {
    final Uri url = Uri.parse(SharedConstant.baseURL+"&limit=$limit");
    try {
      http.Response response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      // debugPrint(response.statusCode.toString());
      // log(response.body.toString());
      dynamic decodedResult = jsonDecode(response.body);
      return ItunesModel.fromJson(decodedResult);
    } catch (_) {
      throw RemoteServerFailure();
    }
  }
}
