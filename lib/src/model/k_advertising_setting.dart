class KAdvertisingSetting {
  static const int ADVERTISE_MODE_LOW_POWER = 0;
  static const int ADVERTISE_MODE_BALANCED = 1;
  static const int ADVERTISE_MODE_LOW_LATENCY = 2;

  static const int ADVERTISE_TX_POWER_ULTRA_LOW = 0;
  static const int ADVERTISE_TX_POWER_LOW = 1;
  static const int ADVERTISE_TX_POWER_MEDIUM = 2;
  static const int ADVERTISE_TX_POWER_HIGH = 3;

  String? name;
  bool connectable = true;
  int timeout = 0;
  int advertiseMode = ADVERTISE_MODE_BALANCED;
  int txPowerLevel = ADVERTISE_TX_POWER_MEDIUM;

  KAdvertisingSetting({
    this.name,
    this.connectable = true,
    this.timeout = 0,
    this.advertiseMode = ADVERTISE_MODE_BALANCED,
    this.txPowerLevel = ADVERTISE_TX_POWER_MEDIUM,
  });

  KAdvertisingSetting.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    connectable = json['connectable'];
    timeout = json['timeout'];
    advertiseMode = json['advertiseMode'];
    txPowerLevel = json['txPowerLevel'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['connectable'] = this.connectable;
    data['timeout'] = this.timeout;
    data['advertiseMode'] = this.advertiseMode;
    data['txPowerLevel'] = this.txPowerLevel;
    return data;
  }

  String toJson() => toMap().toString();
}
