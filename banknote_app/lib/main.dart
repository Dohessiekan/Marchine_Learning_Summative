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

// Define the PredictionService class
class PredictionService {
  static const String apiUrl =
      'https://marchine-learning-summative-1.onrender.com/predict';

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
        print('Response body: ${response.body}');
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

class _PredictionScreenState extends State<PredictionScreen>
    with SingleTickerProviderStateMixin {
  final _ageController = TextEditingController();
  final _bmiController = TextEditingController();
  final _childrenController = TextEditingController();
  final _sexController = TextEditingController();
  final _smokerController = TextEditingController();
  final _regionController = TextEditingController();

  double? _prediction;
  List<String> _predictionHistory = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _animationController..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _getPrediction() async {
    try {
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
        if (prediction != null) {
          _predictionHistory.add(
              'Age: ${input.age}, BMI: ${input.bmi}, Children: ${input.children}, Sex: ${input.sex}, Smoker: ${input.smoker}, Region: ${input.region} => Prediction: $_prediction');
        }
      });
    } catch (e) {
      print('Input Error: $e');
    }
  }

  void _clearHistory() {
    setState(() {
      _predictionHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Insurance Prediction'),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Welcome to your insurance prediction',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
          ],
        ),
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
              decoration:
                  InputDecoration(labelText: 'Sex (0 for Female, 1 for Male)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _smokerController,
              decoration:
                  InputDecoration(labelText: 'Smoker (0 for No, 1 for Yes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _regionController,
              decoration: InputDecoration(
                  labelText:
                      'Region (1 for northwest, 2 for southeast, or 3 for southwest)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getPrediction,
              child: Text('Get Prediction'),
            ),
            SizedBox(height: 20),
            if (_prediction != null) Text('Predicted Value: $_prediction'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _clearHistory,
              child: Text('Clear History'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _predictionHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_predictionHistory[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
