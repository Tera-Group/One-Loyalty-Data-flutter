import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'one_loyalty_data_flutter_platform_interface.dart';

/// An implementation of [OneLoyaltyDataFlutterPlatform] that uses method channels.
class MethodChannelOneLoyaltyDataFlutter extends OneLoyaltyDataFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('one_loyalty_data_flutter');

  @override
  Future<bool> setupSDK(Map<String, dynamic> configMap) async {
    final result =
        await methodChannel.invokeMethod<bool>('setupSDK', configMap);
    return result ?? false;
  }

  @override
  Future<String?> getListMission() async {
    return await methodChannel.invokeMethod<String?>('getListMission');
  }

  @override
  Future<String?> getUser() async {
    return await methodChannel.invokeMethod<String?>('getUser');
  }
}
