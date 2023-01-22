import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardpage_site.dart';
import 'package:rfidapp/domain/enums/snackbar_type.dart';
import 'package:rfidapp/domain/enums/timer_actions.dart';
import 'package:rfidapp/pages/generate/visualize/cards_visualize.dart';
import 'package:rfidapp/pages/generate/widget/response_snackbar.dart';
import 'package:rfidapp/provider/connection/api/data.dart';
import 'package:rfidapp/provider/types/readercard.dart';
import 'package:web_socket_channel/io.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../widget/circular_timer/circular_countdown_timer.dart';

class RequestTimer {
  Map? _responseData;
  var timerController = CountDownController();
  late bool _successful = false;
  late _TimerType _timerType;
  int i = 0;
  late IOWebSocketChannel channel;
  final BuildContext context;
  final TimerAction action;
  final ReaderCard? card;
  final String? email;
  final String? storagename;

  RequestTimer(
      {required this.context,
      required this.action,
      this.card,
      this.email,
      this.storagename});

  Future<void> startTimer() async {
    i = 0;
    _successful = false;
    channel = IOWebSocketChannel.connect(
        Uri.parse('wss://10.0.2.2:7171/api/controller/log'));
    streamListener();
    return showDialog(
        //useRootNavigator: false,
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
                          if (card != null) {
                            if (_successful) {
                              SnackbarBuilder.build(SnackbarType.Karten,
                                  context, _successful, _responseData);
                            } else {
                              SnackbarBuilder.build(SnackbarType.Karten,
                                  context, _successful, _responseData);
                            }
                          } else if (storagename != null) {
                            if (_successful) {
                              SnackbarBuilder.build(SnackbarType.User, context,
                                  _successful, _responseData);
                            } else {
                              SnackbarBuilder.build(SnackbarType.User, context,
                                  _successful, _responseData);
                            }
                          }
                        }
                        try {
                          Navigator.of(context).maybePop();
                        } catch (e) {}
                      }),
                      onStart: () async {
                        //maybe you need threading
                        if (action == TimerAction.GETCARD) {
                          var response =
                              await Data.postGetCardNow(card!, email!);
                          if (response.statusCode != 200) {
                            Navigator.maybePop(context);
                          }
                        } else if (action == TimerAction.SIGNUP) {
                          var response = await Data.postCreateNewUser(
                              email!, storagename!);

                          if (response.statusCode != 200) {
                            Navigator.maybePop(context);
                          }
                        }
                      },
                      timeFormatterFunction:
                          (defaultFormatterFunction, duration) {
                        return Function.apply(
                            defaultFormatterFunction, [duration]);
                      },
                    )),
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

  Map getResponse() {
    return _responseData ?? {"Error": "No Message received"};
  }

  streamListener() {
    channel.stream.listen((message) async {
      _responseData = jsonDecode(message);
      _successful = _responseData!["successful"] ??
          _responseData!["status"]["successful"];
      _timerType = _TimerType.Breaktimer;
      timerController.restart(duration: 0);
      channel.sink.close();
    });
  }
}

enum _TimerType { InitTimer, Breaktimer }