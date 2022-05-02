// flutter
import 'package:flutter/material.dart';

// custom widgets
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

Future toastWidget(String msg) async {
  SmartDialog.showToast(msg, alignment: Alignment.center);

  await Future.delayed(const Duration(seconds: 2));

  SmartDialog.dismiss();
}
