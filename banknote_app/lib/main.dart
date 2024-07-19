import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _varianceController = TextEditingController();
  final _skewnessController = TextEditingController();
  final _curtosisController = TextEditingController();
  final _entropyController = TextEditingController();
  String _prediction = '';

  Future<void> _makePrediction() async {
    final variance = _varianceController.text;
    final skewness = _skewnessController.text;
    final curtosis = _curtosisController.text;
    final entropy = _entropyController.text;

    if (variance.isEmpty ||
        skewness.isEmpty ||
        curtosis.isEmpty ||
        entropy.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://marchine-learning-summative-1.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'variance': double.parse(variance),
          'skewness': double.parse(skewness),
          'curtosis': double.parse(curtosis),
          'entropy': double.parse(entropy),
        }),
      );

      // Debugging statements
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _prediction = 'Prediction: ${result['prediction']}';
        });
      } else {
        Fluttertoast.showToast(
          msg: "Error: ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _varianceController,
              decoration: InputDecoration(labelText: 'Variance'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _skewnessController,
              decoration: InputDecoration(labelText: 'Skewness'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _curtosisController,
              decoration: InputDecoration(labelText: 'Curtosis'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _entropyController,
              decoration: InputDecoration(labelText: 'Entropy'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _makePrediction,
              child: Text('Predict'),
            ),
            SizedBox(height: 20),
            Text(
              _prediction,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
