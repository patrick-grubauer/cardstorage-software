import 'dart:convert';
import 'package:http/http.dart' as http;

String adress = "https://192.168.125.67:7171/api/storages/cards";

class Cards {
  String name;
  int storage;

  Cards({
    required this.name,
    required this.storage,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      name: json['name'] ?? "",
      storage: json['storage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'storage': storage,
      };
}

Future<List<Cards>> fetchData() async {
  final response = await http.get(
    Uri.parse(adress),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Cards.fromJson(data)).toList();
  } else {
    throw Exception('Failed to get Cards!');
  }
}

Future<dynamic> deleteData(String name) async {
  final http.Response response = await http.delete(
    Uri.parse(adress + "/name/" + name),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return Cards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete Card!');
  }
}

Future<dynamic> updateData(String name, Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(adress + "/name/" + name),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return Cards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update Card!');
  }
}

Future<dynamic> sendData(Map<String, dynamic> data) async {
  final http.Response response = await http.post(
    Uri.parse(adress),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  if (response.statusCode == 201) {
    return Cards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to add Card!');
  }
}
