class KGattService {
  static const int SERVICE_TYPE_PRIMARY = 0;
  static const int SERVICE_TYPE_SECONDARY = 1;
  String uuid;
  int serviceType = SERVICE_TYPE_PRIMARY;

  KGattService(this.uuid);
}