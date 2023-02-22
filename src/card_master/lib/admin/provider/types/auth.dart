import 'package:http/http.dart';

class Auth {
  String token;

  Auth({
    required this.token,
  });

  factory Auth.fromJson(dynamic json) {
    return Auth(
      token: json,
    );
  }
}

Future<Response> authAdminLogin(Map<String, dynamic> data) async {
  return await get(
    Uri.parse("https://10.0.2.2:7171/api/v1/auth/user/email/" + data["name"]),
    headers: <String, String>{
      'Content-Type': 'text/plain',
    },
  );
}