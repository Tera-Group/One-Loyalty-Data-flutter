import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_loyalty_data_flutter/one_loyalty_data_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelOneLoyaltyDataFlutter platform = MethodChannelOneLoyaltyDataFlutter();
  const MethodChannel channel = MethodChannel('one_loyalty_data_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });
}
