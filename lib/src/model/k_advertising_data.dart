class KAdvertisingData {
  final Map<String, List<int>?> serviceData = Map();
  final Map<int, List<int>> manufacturerData = Map();
  bool includeDeviceName = true;
  bool includeTxPowerLevel = true;

  KAdvertisingData({
    this.includeDeviceName = true,
    this.includeTxPowerLevel = true,
  });

  addServiceData(String uuid, List<int>? data) {
    serviceData[uuid] = data;
  }

  addManufacturer(int uuid, List<int> data) {
    manufacturerData[uuid] = data;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceData'] = serviceData;
    data['manufacturerData'] = manufacturerData;
    data['includeDeviceName'] = includeDeviceName;
    data['includeTxPowerLevel'] = includeTxPowerLevel;
    return data;
  }
}
