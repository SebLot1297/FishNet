import 'package:flutter/material.dart';
final navigatorKey = GlobalKey<NavigatorState>();


Future<void> showUrgentAlert(String message) async {
  
  final context = navigatorKey.currentContext; //context comes from globalKey
  if (context == null) return; //would be null if materialApp does not build navigator before this function is called

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 1000),
    barrierLabel: '',
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.topCenter,
        child: AlertDialog(title: Text(message), 
        actions: [
              TextButton(onPressed: ()=> Navigator.pop(context, null), child: Text("OK"))
        ],),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      // slide-down animation 
      final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOut);
      return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    )
    .animate(curved),
    child: child,
  );

    },
  );
}

