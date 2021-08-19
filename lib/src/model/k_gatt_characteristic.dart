class KGattCharacteristic {
  static const int PROPERTY_BROADCAST = 0x01;
  static const int PROPERTY_READ = 0x02;
  static const int PROPERTY_WRITE_NO_RESPONSE = 0x04;
  static const int PROPERTY_WRITE = 0x08;
  static const int PROPERTY_NOTIFY = 0x10;
  static const int PROPERTY_INDICATE = 0x20;
  static const int PROPERTY_SIGNED_WRITE = 0x40;
  static const int PROPERTY_EXTENDED_PROPS = 0x80;

  static const int PERMISSION_READ = 0x01;
  static const int PERMISSION_READ_ENCRYPTED = 0x02;
  static const int PERMISSION_READ_ENCRYPTED_MITM = 0x04;
  static const int PERMISSION_WRITE = 0x10;
  static const int PERMISSION_WRITE_ENCRYPTED = 0x20;
  static const int PERMISSION_WRITE_ENCRYPTED_MITM = 0x40;
  static const int PERMISSION_WRITE_SIGNED = 0x80;
  static const int PERMISSION_WRITE_SIGNED_MITM = 0x100;

  String uuid;
  int properties = 0;
  int permissions = 0;

  KGattCharacteristic(this.uuid);

  addProperty(int property) {
    properties += property;
  }

  addPermission(int permission) {
    permissions += permission;
  }
}
