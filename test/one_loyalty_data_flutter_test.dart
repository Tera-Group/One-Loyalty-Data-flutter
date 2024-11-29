import 'package:flutter_test/flutter_test.dart';
import 'package:one_loyalty_data_flutter/one_loyalty_data_flutter.dart';
import 'package:one_loyalty_data_flutter/one_loyalty_data_flutter_platform_interface.dart';
import 'package:one_loyalty_data_flutter/one_loyalty_data_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOneLoyaltyDataFlutterPlatform
    with MockPlatformInterfaceMixin
    implements OneLoyaltyDataFlutterPlatform {

  @override
  Future<bool> setupSDK(Map<String, dynamic> configMap) => Future.value(true);

  @override
  Future<String?> getListMission() => Future.value("");

  @override
  Future<String?> getUser() => Future.value("");
}

void main() {
  final OneLoyaltyDataFlutterPlatform initialPlatform =
      OneLoyaltyDataFlutterPlatform.instance;

  test('$MethodChannelOneLoyaltyDataFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOneLoyaltyDataFlutter>());
  });
}
