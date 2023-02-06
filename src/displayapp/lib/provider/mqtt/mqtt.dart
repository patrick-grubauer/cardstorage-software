// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rfidapp/pages/generate/widget/request_timer.dart';

class MQTTClientManager {
  static final MqttServerClient _client =
      MqttServerClient.withPort("10.0.2.2", 'test', 1884);
  static BuildContext? _context;
  static Future<int> connect(BuildContext context) async {
    _client.logging(on: true);
    _context = context;
    _client.disconnect();
    _client.keepAlivePeriod = 60;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onSubscribed = onSubscribed;
    _client.pongCallback = pong;
    final connMessage =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    _client.connectionMessage = connMessage;

    try {
      await _client.connect("CardStorageManagement", "CardStorageManagement");
      _client.subscribe("S4@L4/1", MqttQos.atLeastOnce);
      _client.updates!.listen(_onMessage);
    } on NoConnectionException catch (e) {
      print('MQTTClient::Client exception - $e');
      _client.disconnect();
    } on SocketException catch (e) {
      print('MQTTClient::Socket exception - $e');
      _client.disconnect();
    }
    return 0;
  }

  static void disconnect() {
    _client.disconnect();
  }

  static void _onMessage(List<MqttReceivedMessage> event) async {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    Map response = json.decode(message);
    if (response["action"] == "user-signup" &&
        response["client-id"].toString().contains("CSMC")) {
      await RequestTimer(context: _context!).build();
    }
  }

  static void onConnected() {
    print('MQTTClient::Connected');
  }

  static void onDisconnected() {
    print('MQTTClient::Disconnected');
  }

  static void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
  }

  static void pong() {
    print('MQTTClient::Ping response received');
  }

  static void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  static Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return _client.updates;
  }
}