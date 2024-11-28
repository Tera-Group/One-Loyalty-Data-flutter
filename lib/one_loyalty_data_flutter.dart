
import 'one_loyalty_data_flutter_platform_interface.dart';

class OneLoyaltyDataFlutter {
  Future<String?> getPlatformVersion() {
    return OneLoyaltyDataFlutterPlatform.instance.getPlatformVersion();
  }
}
