import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_automation/locator.dart';
import 'package:home_automation/services/navgation_service.dart';
class AlertService {
  final NavigationService _navigationService = locator<NavigationService>();
  void showSignOut(BuildContext context, String title, String desc,
      VoidCallback onSignout, VoidCallback onCancel) {
    showDialog(
        useRootNavigator: true,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "YES",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: onSignout,
            ),
            TextButton(
              child: const Text(
                "NO",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: onCancel,
            )
          ],
        ));
  }

  void showSuccess(
      BuildContext context, String title, String desc, VoidCallback onCancel) {
    showDialog(
        useRootNavigator: true,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: onCancel),
          ],
        ));
  }

  void showError(
      BuildContext context, String title, String desc, VoidCallback onCancel) {
    showDialog(
        useRootNavigator: true,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "DONE",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: onCancel,
            )
          ],
        ));
  }

  void showWarning(String title, String desc, VoidCallback onCancel) {
    showCupertinoDialog(
        useRootNavigator: true,
        context: _navigationService.navigationKey.currentContext!,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "DONE",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: onCancel,
            )
          ],
        ));
  }

  void alertDialog(String title, String desc,
      VoidCallback functionCancel, VoidCallback functionDone) {
    showCupertinoDialog(
      context: _navigationService.navigationKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: <Widget>[
          TextButton(
            onPressed: functionCancel,
            child: const Text('Cancel', style: TextStyle(color: Colors.red),),
          ),
          TextButton(
            onPressed: functionDone,
            child: const Text('Yes'),
          ),
        ],
      ),
    );

  }
}
