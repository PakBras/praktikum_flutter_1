import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProvincesPage(),
    );
  }
}

class ProvincesPage extends StatefulWidget {
  @override
  _ProvincesPageState createState() => _ProvincesPageState();
}

class _ProvincesPageState extends State<ProvincesPage> {
  late Future<List<dynamic>> futureProvinces;

  @override
  void initState() {
    super.initState();
    futureProvinces = fetchProvinces();
  }

  Future<List<dynamic>> fetchProvinces() async {
    final response = await http.get(
      Uri.parse('https://api.goapi.io/regional/provinsi?api_key=009dd7a0-6002-58ea-c44b-93886950'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Provinsi')),
      body: FutureBuilder<List<dynamic>>(
        future: futureProvinces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final province = snapshot.data![index];
                return ListTile(
                  title: Text(province['name'] ?? 'Name not available'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CitiesPage(provinceId: province['id'].toString(), provinceName: province['name']),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

class CitiesPage extends StatefulWidget {
  final String provinceId;
  final String provinceName;

  const CitiesPage({required this.provinceId, required this.provinceName});

  @override
  _CitiesPageState createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  late Future<List<dynamic>> futureCities;

  @override
  void initState() {
    super.initState();
    futureCities = fetchCities(widget.provinceId);
  }

  Future<List<dynamic>> fetchCities(String provinceId) async {
    final response = await http.get(
      Uri.parse('https://api.goapi.io/regional/kota?api_key=009dd7a0-6002-58ea-c44b-93886950&provinsi_id=$provinceId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kota di ${widget.provinceName}')),
      body: FutureBuilder<List<dynamic>>(
        future: futureCities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final city = snapshot.data![index];
                return ListTile(
                  title: Text(city['name'] ?? 'Name not available'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DistrictsPage(cityId: city['id'].toString(), cityName: city['name']),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

class DistrictsPage extends StatefulWidget {
  final String cityId;
  final String cityName;

  const DistrictsPage({required this.cityId, required this.cityName});

  @override
  _DistrictsPageState createState() => _DistrictsPageState();
}

class _DistrictsPageState extends State<DistrictsPage> {
  late Future<List<dynamic>> futureDistricts;

  @override
  void initState() {
    super.initState();
    futureDistricts = fetchDistricts(widget.cityId);
  }

  Future<List<dynamic>> fetchDistricts(String cityId) async {
    final response = await http.get(
      Uri.parse('https://api.goapi.io/regional/kecamatan?api_key=009dd7a0-6002-58ea-c44b-93886950&kota_id=$cityId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load districts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kecamatan di ${widget.cityName}')),
      body: FutureBuilder<List<dynamic>>(
        future: futureDistricts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final district = snapshot.data![index];
                return ListTile(
                  title: Text(district['name'] ?? 'Name not available'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VillagesPage(districtId: district['id'].toString(), districtName: district['name']),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

class VillagesPage extends StatefulWidget {
  final String districtId;
  final String districtName;

  const VillagesPage({required this.districtId, required this.districtName});

  @override
  _VillagesPageState createState() => _VillagesPageState();
}

class _VillagesPageState extends State<VillagesPage> {
  late Future<List<dynamic>> futureVillages;

  @override
  void initState() {
    super.initState();
    futureVillages = fetchVillages(widget.districtId);
  }

  Future<List<dynamic>> fetchVillages(String districtId) async {
    final response = await http.get(
      Uri.parse('https://api.goapi.io/regional/kelurahan?api_key=009dd7a0-6002-58ea-c44b-93886950&kecamatan_id=$districtId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load villages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kelurahan di ${widget.districtName}')),
      body: FutureBuilder<List<dynamic>>(
        future: futureVillages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final village = snapshot.data![index];
                return ListTile(
                  title: Text(village['name'] ?? 'Name not available'),
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

