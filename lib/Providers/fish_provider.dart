import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_pokidex/OverallApp/user_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'fish_provider.g.dart';

@HiveType(typeId: 0)
class Fish extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String fishImagePath;

  @HiveField(2)
  final String userID;

  @HiveField(3)
  final double ? weight;

  @HiveField(4)
  final double ? length;

  Fish({required this.name, required this.fishImagePath, required this.userID, this.weight, this.length});
}

class FishProvider extends ChangeNotifier {
  late Box<Fish> _box;
  List<Fish> _fishList = [];
  final UserService _userService = UserService();

  List<Fish> get fishList => _fishList;

  Future<void> init() async {
    final user = FirebaseAuth.instance.currentUser;
    _box = await Hive.openBox<Fish>('fish_box');
    _fishList = _box.values.where((f) => f.userID == user?.uid).toList();

    notifyListeners();
  }

  Future<void> addFish(Fish fish) async {
    final user = FirebaseAuth.instance.currentUser;
    await _box.add(fish);
_fishList = _box.values.where((f) => f.userID == user?.uid).toList();
    notifyListeners();

    // Award XP in Firestore whenever a fish is logged
    
    if (user != null) {
      await _userService.recordFishCaught(user.uid, xpEarned: 10);
    }
  }
}