import 'package:toast/toast.dart';

showToast(String msg, {int duration = 1, int? gravity}) {
  Toast.show(msg, duration: duration, gravity: gravity);
}
