import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plant_watering_app/models/plant.dart';
import 'package:plant_watering_app/providers/plant_provider.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant? plant;

  PlantDetailScreen(this.plant);

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _wateringFrequency;
  late DateTime _lastWatered;
  

  @override
  void initState() {
    super.initState();
    if (widget.plant != null) {
      _name = widget.plant!.name;
      _wateringFrequency = widget.plant!.wateringFrequency;
      _lastWatered = widget.plant!.lastWatered;
    } else {
      _name = '';
      _wateringFrequency = 1;
      _lastWatered = DateTime.now();
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPlant = Plant(
        id: widget.plant?.id ?? DateTime.now().toString(),
        name: _name,
        wateringFrequency: _wateringFrequency,
        lastWatered: _lastWatered,
      );

      if (widget.plant == null) {
        Provider.of<PlantProvider>(context, listen: false).addPlant(newPlant);
      } else {
        Provider.of<PlantProvider>(context, listen: false).updatePlant(newPlant);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant == null ? '내 식물 추가' : '식물 정보 변경'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: '식물 이름'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '식물 이름을 기입해주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _wateringFrequency.toString(),
                decoration: InputDecoration(labelText: '물주는 빈도 (일)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return '유효한 숫자 또는 값을 입력해주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _wateringFrequency = int.parse(value!);
                },
              ),
              // 추가적으로 DateTimePicker 등을 넣어 lastWatered를 설정할 수 있습니다.
            ],
          ),
        ),
      ),
    );
  }
}
