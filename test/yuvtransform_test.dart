import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuvtransform/yuvtransform.dart';

void main() {
  const MethodChannel channel = MethodChannel('yuvtransform');

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
    expect(await Yuvtransform.platformVersion, '42');
  });
}
