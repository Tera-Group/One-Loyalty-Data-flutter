import 'one_loyalty_data_flutter_platform_interface.dart';

class OneLoyaltyDataFlutter {

  Future<bool> setupSDK(Map<String, dynamic> configMap) {
    return OneLoyaltyDataFlutterPlatform.instance.setupSDK(configMap);
  }

  Future<String?> getListMission() {
    return OneLoyaltyDataFlutterPlatform.instance.getListMission();
  }

  Future<String?> getUser() {
    return OneLoyaltyDataFlutterPlatform.instance.getUser();
  }
}
