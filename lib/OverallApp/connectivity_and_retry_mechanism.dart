import 'dart:io';
import '../Screens/camera_screen.dart';
import '../Providers/fish_provider.dart';
import 'package:flutter/services.dart';
import 'package:fishing_pokidex/OverallApp/global_errors_announcment.dart';
import 'package:flutter/material.dart';
Future<bool> hasInternet() async{
   try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

Future<void> retryPendingFish(FishProvider provider) async{
  final pendingFish = provider.fishList.where((fish)=> fish.idStatus == IdentificationStatus.pending);
  for(var f in pendingFish){
    await identifyAndUpdateFish(f, provider);
  }
 final stillHasPending = provider.fishList.any((fish) => fish.idStatus == IdentificationStatus.pending);
 
  final context = navigatorKey.currentContext;
  if (context == null) return;
  //alert user all fish successfully added
  if(!stillHasPending){
    await HapticFeedback.heavyImpact();
     
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("All the fish were successfully scanned!")),
);
  }
  else{
    //alert user some fish were unable to be added
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Some fish were unable to be scanned :(")),
);

  }
  



}

