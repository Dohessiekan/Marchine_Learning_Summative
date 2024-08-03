import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Define the PredictionInput class
class PredictionInput {
  final double age;
  final double bmi;
  final int children;
  final int sex;
  final int smoker;
  final int region;

  PredictionInput({
    required this.age,
    required this.bmi,
    required this.children,
    required this.sex,
    required this.smoker,
    required this.region,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'bmi': bmi,
      'children': children,
      'sex': sex,
      'smoker': smoker,
      'region': region,
    };
  }
}

class PredictionService {
  static const String apiUrl = 'http://127.0.0.1:8000/predict';

  Future<double?> getPrediction(PredictionInput input) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(input.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['prediction'];
      } else {
        print('Failed to get prediction: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _ageController = TextEditingController();
  final _bmiController = TextEditingController();
  final _childrenController = TextEditingController();
  final _sexController = TextEditingController();
  final _smokerController = TextEditingController();
  final _regionController = TextEditingController();

  double? _prediction;

  void _getPrediction() async {
    final input = PredictionInput(
      age: double.parse(_ageController.text),
      bmi: double.parse(_bmiController.text),
      children: int.parse(_childrenController.text),
      sex: int.parse(_sexController.text),
      smoker: int.parse(_smokerController.text),
      region: int.parse(_regionController.text),
    );

    final prediction = await PredictionService().getPrediction(input);
    setState(() {
      _prediction = prediction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insurance Prediction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _bmiController,
              decoration: InputDecoration(labelText: 'BMI'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _childrenController,
              decoration: InputDecoration(labelText: 'Children'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sexController,
              decoration: InputDecoration(labelText: 'Sex'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _smokerController,
              decoration: InputDecoration(labelText: 'Smoker'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _regionController,
              decoration: InputDecoration(labelText: 'Region'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getPrediction,
              child: Text('Get Prediction'),
            ),
            SizedBox(height: 20),
            if (_prediction != null) Text('Predicted Value: $_prediction'),
          ],
        ),
      ),
    );
  }
}
