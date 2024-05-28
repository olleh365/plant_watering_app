import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plant_watering_app/providers/plant_provider.dart';
import 'package:plant_watering_app/screens/plant_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('🪴식물 물주기 알림🪴'),
      ),
      body: ListView.builder(
        itemCount: plantProvider.plants.length,
        itemBuilder: (ctx, index) {
          final plant = plantProvider.plants[index];
          return ListTile(
            title: Text(plant.name),
            subtitle: Text('다음 급수일: ${plant.nextWateringDate}'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlantDetailScreen(plant),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlantDetailScreen(null),
            ),
          );
        },
      ),
    );
  }
}
