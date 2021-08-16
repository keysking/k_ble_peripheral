import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_ble_peripheral/src/k_ble_peripheral.dart';

void main() {
  const MethodChannel channel = MethodChannel('k_ble_peripheral');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await KBlePeripheral.platformVersion, '42');
  });
}
