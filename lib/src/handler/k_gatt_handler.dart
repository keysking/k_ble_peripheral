import 'package:flutter/services.dart';

class KGattHandler {
  static const method = const MethodChannel('m:kbp/gatt');
  static const event = const EventChannel("e:kbp/gatt");

  late final Stream<Map<String, dynamic>> eventStream;
  // 实现单例
  factory KGattHandler() => _getInstance();
  static KGattHandler? _instance;

  KGattHandler._internal() {
    eventStream = event
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event));
  }
  static KGattHandler _getInstance() {
    if (_instance == null) {
      _instance = new KGattHandler._internal();
    }
    return _instance!;
  }
}
