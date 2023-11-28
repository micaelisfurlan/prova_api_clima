import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempo Agora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _cepController = TextEditingController();
  String _weather = "";
  String _city = "";

  Future<void> _getWeather(String cep) async {
    // Consulta o clima utilizando a API HGBRASIL
    String weatherUrl =
        'https://api.hgbrasil.com/weather?format=json&key=0add4ae4&city_name=$cep';
    final responseWeather = await http.get(Uri.parse(weatherUrl));

    if (responseWeather.statusCode == 200) {
      Map<String, dynamic> data = json.decode(responseWeather.body);
      setState(() {
        _city = data['results']['city'];
        _weather = data['results']['description'];
      });
    } else {
      setState(() {
        _city = "Erro na consulta";
        _weather = "";
      });
    }
  }

  Future<void> _getCityFromCEP(String cep) async {
    // Consulta o nome da cidade utilizando a API viaCEP
    String viaCepUrl = 'https://viacep.com.br/ws/$cep/json/';
    final responseViaCep = await http.get(Uri.parse(viaCepUrl));

    if (responseViaCep.statusCode == 200) {
      Map<String, dynamic> data = json.decode(responseViaCep.body);
      String city = data['localidade'];
      _getWeather(city);
    } else {
      setState(() {
        _city = "Erro na consulta";
        _weather = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tempo Agora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Informe um CEP'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String cep = _cepController.text;
                _getCityFromCEP(cep);
              },
              child: Text('VER'),
            ),
            SizedBox(height: 16),
            Text('Cidade: $_city'),
            SizedBox(height: 8),
            Text('Clima Atual: $_weather'),
          ],
        ),
      ),
    );
  }
}
