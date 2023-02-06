import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'dart:async';
import 'package:rfidapp/provider/types/readercard.dart';
import 'package:rfidapp/provider/types/reservation.dart';

class Data {
  static String? bearerToken;
  static String uriRaspi = 'https://10.0.2.2:7171/api/';

  static Future<Response> check(Function function, String? args) async {
    if (bearerToken == null) {
      await generateToken();
    }
    Response response;
    if (args != null) {
      response = await function(args);
    } else {
      response = await function();
    }
    if (response.statusCode == 401) {
      await generateToken();

      if (args != null) {
        response = await function(args);
      } else {
        response = await function();
      }
    }
    return response;
  }

  static Future<Response?> getReaderCards() async {
    try {
      return await get(Uri.parse("${uriRaspi}storages"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Response?> checkUserRegistered(String email) async {
    var responseUser =
        await get(Uri.parse("${uriRaspi}users/email/${email}"), headers: {
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $bearerToken",
    });
    return responseUser;
  }

  static Future<Response?> getUserData(String accessToken) async {
    try {
      final response =
          await get(Uri.parse("https://graph.microsoft.com/v1.0/me"), headers: {
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
        "Accept": "application/json"
      });

      return response;
    } catch (e) {}
  }

  static Future<Response?> getAllReservationUser() async {
    return await get(
        Uri.parse(
            "${uriRaspi}storages/cards/reservations/details/user/email/${await UserSecureStorage.getUserEmail()}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          "Accept": "application/json"
        });
  }

  static Future<Response> postCreateNewUser(
      String email, String storageName) async {
    return post(Uri.parse('${uriRaspi}users'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        },
        body: jsonEncode({"email": email, "storage": storageName}));
  }

  static Future<Response> postGetCardNow(
      ReaderCard readerCard, String email) async {
    // "/api/storages/cards/name/NAME/fetch/user/email/USER@PROVIDER.COM",
    // "/api/storages/cards/name/NAME/fetch",
    print(Uri.parse(
        '${uriRaspi}storages/cards/name/${readerCard.name}/fetch/user/email/${email}'));
    String readerCards = jsonEncode(readerCard.toJson());
    return put(
        Uri.parse(
            '${uriRaspi}storages/cards/name/${readerCard.name}/fetch/user/email/${email}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        });
  }

  static Future<Response?> getReservationsOfCard(ReaderCard card) async {
    //https: //localhost:7171/api/storages/cards/reservations/card/Card1
    return await get(
        Uri.parse("${uriRaspi}storages/cards/reservations/card/${card.name}"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        });

    // var jsonReservation = jsonDecode(reservationResponse.body) as List;
    // List<Reservation> reservations = jsonReservation
    //     .map((tagJson) => Reservation.fromJson(tagJson))
    //     .toList();

    // return reservations;
  }

  static Future<Response> newReservation(
      String CardName, int since, int till) async {
    //https://localhost:7171/api/users/reservations/email/40146720180276@litec.ac.at

    return await post(
        Uri.parse(
            "${uriRaspi}users/reservations/email/${await UserSecureStorage.getUserEmail()}"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        },
        body: jsonEncode({
          "card": CardName,
          "since": since,
          "until": till,
          "is-reservation": true
        }));
    ;
  }

  static Future<Response> deleteReservation(Reservation reservation) async {
    //https://localhost :7171/api/users/reservations/email/40146720180276@litec.ac.at
    var reservationResponse = await delete(
      Uri.parse("${uriRaspi}storages/cards/reservations/id/${reservation.id}"),
      headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      },
    );

    return reservationResponse;
  }

  static Future<void> generateToken() async {
    var response = await get(
        Uri.parse("${uriRaspi}auth/user/email/card_storage_admin@default.com"),
        headers: {
          "Content-Type": "text/plain",
        });
    bearerToken = response.body;
  }

  static void setToken(String token) async {
    // https://localhost:7171/api/auth/user/email/card_storage_admin@default.com
  }
}