class Plant {
  String id;
  String name;
  int wateringFrequency; // in days
  DateTime lastWatered;

  Plant({
    required this.id,
    required this.name,
    required this.wateringFrequency,
    required this.lastWatered,
  });
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'wateringFrequency': wateringFrequency,
      'lastWatered': lastWatered.toIso8601String(),
    };
  }

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      wateringFrequency: json['wateringFrequency'],
      lastWatered: DateTime.parse(json['lastWatered']),
    );
  }
  DateTime get nextWateringDate {
    return lastWatered.add(Duration(days: wateringFrequency));
  }
}
