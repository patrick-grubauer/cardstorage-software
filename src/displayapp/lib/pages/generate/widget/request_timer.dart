import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:rfidapp/domain/enum/snackbar_type.dart';
import 'package:rfidapp/pages/generate/widget/response_snackbar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/types/cards.dart';

class RequestTimer {
  Map? _responseData;
  var timerController = CountDownController();
  late bool _successful = false;
  late _TimerType _timerType;
  int i = 0;
  BuildContext context;
  ReaderCard card;
  late IOWebSocketChannel? channel;
  RequestTimer({required this.context, required this.card});

  Future<void> build() {
    _timerType = _TimerType.InitTimer;
    i = 0;
    channel = IOWebSocketChannel.connect(
        Uri.parse('wss://10.0.2.2:7171/api/controller/log'));
    streamListener();
    int timestamp = 0;
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircularCountDownTimer(
                    duration: 20,
                    initialDuration: 0,
                    controller: timerController,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    ringColor: Colors.green[300]!,
                    ringGradient: null,
                    fillColor: Colors.green[100]!,
                    fillGradient: null,
                    backgroundColor: Colors.green[500],
                    backgroundGradient: null,
                    strokeWidth: 20.0,
                    strokeCap: StrokeCap.round,
                    textStyle: const TextStyle(
                        fontSize: 33.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textFormat: CountdownTextFormat.S,
                    isReverse: false,
                    isReverseAnimation: false,
                    isTimerTextShown: true,
                    autoStart: true,
                    onComplete: (() {
                      if (i == 0) {
                        i++;
                        try {
                          print("seco");
                          SnackbarBuilder.build(SnackbarType.Karten, context,
                              _successful, _responseData);
                        } catch (e) {}
                      }
                      Navigator.of(context).maybePop();
                    }),
                    onStart: () async {
                      var response = await Data.postGetCardNow(card);
                      if (response.statusCode != 200) {
                        Navigator.maybePop(context);
                      }
                    },
                    timeFormatterFunction:
                        (defaultFormatterFunction, duration) {
                      return Function.apply(
                          defaultFormatterFunction, [duration]);
                    },
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 350, 0, 0),
                    child: Text(
                      "Halten Sie Ihre Karte an den Sensor!",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  bool getSuccessful() {
    return _successful;
  }

  streamListener() {
    channel?.stream.listen((message) async {
      _responseData = jsonDecode(message);
      _successful = _responseData!["successful"] ??
          _responseData!["status"]["successful"];
      _timerType = _TimerType.Breaktimer;
      channel!.sink.close();
      timerController.restart(duration: 0);
    });
  }
}

enum _TimerType { InitTimer, Breaktimer }
