import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'one_loyalty_data_flutter_method_channel.dart';

abstract class OneLoyaltyDataFlutterPlatform extends PlatformInterface {
  /// Constructs a OneLoyaltyDataFlutterPlatform.
  OneLoyaltyDataFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static OneLoyaltyDataFlutterPlatform _instance = MethodChannelOneLoyaltyDataFlutter();

  /// The default instance of [OneLoyaltyDataFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelOneLoyaltyDataFlutter].
  static OneLoyaltyDataFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OneLoyaltyDataFlutterPlatform] when
  /// they register themselves.
  static set instance(OneLoyaltyDataFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
