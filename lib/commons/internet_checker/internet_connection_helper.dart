
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:music_cast/commons/internet_checker/network_checker.dart';

class InternetConnectionHelper {
 static NetworkInfo? _networkInfo;

  static Future<bool> hasInternet() async {
    _networkInfo ??= NetworkInfoImpl(InternetConnectionChecker());
    return await _networkInfo!.isConnected;
  }
}

