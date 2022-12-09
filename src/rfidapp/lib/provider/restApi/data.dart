import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rfidapp/provider/restApi/api-parser.dart';
import 'package:rfidapp/provider/types/cards-status.dart';
import 'dart:async';

import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class Data {
  static String uriRaspi = 'http://10.0.2.2:7171/api/';
  static String uriMsGraph = 'http://10.0.2.2:7171/';

  static Future<List<Cards>> getCardsData() async {
    try {
      var responseCards = await get(Uri.parse("${uriRaspi}cards"),
          headers: {"Accept": "application/json"});
      var responseCardsStatus = await get(Uri.parse("${uriRaspi}cards/status"),
          headers: {"Accept": "application/json"});
      var responseStorages = await get(Uri.parse("${uriRaspi}storage-units"),
          headers: {"Accept": "application/json"});

      List<Storage> storages = jsonDecode(responseStorages.body)
          .map<Storage>(Storage.fromJson)
          .toList();
      List<Cards> cards =
          jsonDecode(responseCards.body).map<Cards>(Cards.fromJson).toList();
      List<CardsStatus> cardsStatus = jsonDecode(responseCardsStatus.body)
          .map<CardsStatus>(CardsStatus.fromJson)
          .toList();
      ApiParser.combineCardDatas(cards, cardsStatus, storages);
      return cards;
    } on Exception catch (_) {
      rethrow;
    }
  }

  static Future<bool> checkUserRegistered(String email) async {
    var responseUser = await get(Uri.parse("${uriRaspi}users/email/${email}"),
        headers: {"Accept": "application/json"});
    if (responseUser.statusCode != 200) {
      return false;
    }
    return true;
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

  static Future<List<String>> getStorageNames() async {
    try {
      var responeStorages = await get(Uri.parse("${uriRaspi}storage-units"),
          headers: {"Accept": "application/json"});

      List<Storage> storages = jsonDecode(responeStorages.body)
          .map<Storage>(Storage.fromJson)
          .toList();
      return ApiParser.getNamesOfStorages(storages);
    } on Exception catch (_) {
      rethrow;
    }
  }

  static void postData(
      String type, Map<String, dynamic> datas, String adress) async {
    //TODO add try catch
    await post(Uri.parse(uriRaspi + type),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datas));
  }

  static void putData(String type, Map<String, dynamic> datas) async {
    //TODO add try catch
    await put(Uri.parse(uriRaspi + type),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datas));
  }
}
