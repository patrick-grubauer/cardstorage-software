import 'dart:convert';
import 'package:http/http.dart' as http;

String ipadress = "http://192.168.120.186:7171/api/storages";

class Storages {
  String name;
  int numberOfCards;
  int location;

  Storages({
    required this.name,
    required this.numberOfCards,
    required this.location,
  });

  factory Storages.fromJson(Map<String, dynamic> json) {
    return Storages(
        name: json['name'] ?? "",
        numberOfCards: json['capacity'] ?? 0,
        location: json['location'] ?? 0);
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'capacity': numberOfCards,
        'location': location,
      };
}

Future<List<Storages>> fetchData() async {
  final response = await http.get(
    Uri.parse(ipadress),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Storages.fromJson(data)).toList();
  } else {
    throw Exception('Failed to get Storages!');
  }
}

Future<Storages> deleteData(String name) async {
  final http.Response response = await http.delete(
    Uri.parse(ipadress + "/name/" + name),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete Storage!');
  }
}

Future<Storages> updateData(String name, Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(ipadress + "/name/" + name),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update Storage!');
  }
}

Future<Storages> sendData(Map<String, dynamic> data) async {
  final http.Response response = await http.post(
    Uri.parse(ipadress),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  if (response.statusCode == 201) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to add Storage!');
  }
}

Future<Storages> focusStorage(String name) async {
  final http.Response response = await http.put(
    Uri.parse(ipadress + "/focus/name/" + name),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(name),
  );

  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to focus Storage!');
  }
}
