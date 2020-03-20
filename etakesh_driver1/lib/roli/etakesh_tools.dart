
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ETakeshTools {

  static void showSimpleLoadingDialog(
      BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: ListTile(
                leading: CircularProgressIndicator(),
                title: new Text("${message}")),
          );
        });
  }
  static void showComplexLoadingDialog(
      BuildContext context, String message, String submessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: ListTile(
              leading: CircularProgressIndicator(),
              title: new Text("${message}"),
              subtitle: new Text("${submessage}")),
        );
      },
    );
  }

  static void dismissAlertDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static String amountFormat(double value) {
    final oCcy = new NumberFormat("#,##0.00", "en_US");

    return oCcy.format(value);
  }
}