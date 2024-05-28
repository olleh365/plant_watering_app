import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/plant.dart';
import '../utils/notification_helper.dart';

class PlantProvider with ChangeNotifier {
  List<Plant> _plants = [];

  List<Plant> get plants => _plants;

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
    savePlants();
    scheduleNotification(plant);
  }

  void updatePlant(Plant plant) {
    final index = _plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      _plants[index] = plant;
      notifyListeners();
      savePlants();
      scheduleNotification(plant);
    }
  }

  void deletePlant(String id) {
    final plant = _plants.firstWhere((p) => p.id == id);
    _plants.removeWhere((p) => p.id == id);
    notifyListeners();
    savePlants();
    NotificationHelper.cancelNotification(plant.id.hashCode);
  }

  void savePlants() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('plants', json.encode(_plants.map((plant) => plant.toJson()).toList()));
  }

  void loadPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final plantsData = prefs.getString('plants');
    if (plantsData != null) {
      _plants = (json.decode(plantsData) as List)
          .map((item) => Plant.fromJson(item))
          .toList();
      notifyListeners();
    }
  }

  void scheduleNotification(Plant plant) {
    final nextWateringDate = plant.lastWatered.add(Duration(days: plant.wateringFrequency));
    NotificationHelper.scheduleWateringNotification(
      id: plant.id.hashCode,
      title: 'Water your plant',
      body: 'It\'s time to water ${plant.name}!',
      scheduledDate: nextWateringDate,
    );
  }
}