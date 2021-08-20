import 'package:k_ble_peripheral/src/model/k_gatt_device.dart';

class KGattConnextState {
  static const int STATE_DISCONNECTED = 0; // 连接断开
  static const int STATE_CONNECTED = 2; // 连接成功

  KGattDevice device;
  int status;
  int newState;

  KGattConnextState(this.device, this.status, this.newState);
}
