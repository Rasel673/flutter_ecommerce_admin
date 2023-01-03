
const String firebaseProductImageUpload='ProductImage';
const String currencySymbol='৳';


abstract class orderStatus{
  static const String pending='pending';
  static const String processing='Processing';
  static const String delivered='Delivered';
  static const String cencelled='Cencelled';
  static const String returned='Returned';
}

abstract class NotificationType {
  static const String comment = 'New Comment';
  static const String order = 'New Order';
  static const String user = 'New User';
}
