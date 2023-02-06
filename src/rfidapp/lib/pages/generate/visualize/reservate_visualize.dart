// ignore_for_file: deprecated_member_use, no_logic_in_create_state
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardpage_type.dart';
import 'package:rfidapp/pages/generate/views/reservate_view.dart';
import 'package:rfidapp/provider/connection/api/data.dart';
import 'package:rfidapp/provider/types/reservation.dart';

// ignore: must_be_immutable
class ReservationVisualizer extends StatefulWidget {
  CardPageTypes site;
  ReservationVisualizer({super.key, required this.site});

  @override
  State<ReservationVisualizer> createState() =>
      _ReservationVisualizerState(site: site);
}

class _ReservationVisualizerState extends State<ReservationVisualizer> {
  _ReservationVisualizerState({required this.site});
  late Future<List<Reservation>?> _futureReservations;

  String _searchString = "";
  TextEditingController _searchController = TextEditingController();
  CardPageTypes site;

  @override
  void initState() {
    super.initState();
    _reloadReaderCards();
  }

  void _reloadReaderCards() async {
    setState(() {
      _futureReservations = _getReservations();
    });
  }

  Future<List<Reservation>?> _getReservations() async {
    var reservationsResponse =
        await Data.check(Data.getAllReservationUser, null);
    var jsonReservation = jsonDecode(reservationsResponse.body) as List;
    List<Reservation> reservations = jsonReservation
        .map((tagJson) => Reservation.fromJson(tagJson))
        .toList();
    return Future.value(reservations);
  }

  @override
  Widget build(BuildContext context) {
    Widget seachField = const SizedBox(height: 0, width: 0);

    if (site != CardPageTypes.Favoriten) {
      seachField = Row(
        children: [
          Expanded(
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Karte suchen per Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Theme.of(context).dividerColor))),
                onChanged: ((value) {
                  setState(() {
                    _searchString = value;
                  });
                })),
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 100,
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text(site.toString().replaceAll("CardPageTypes.", ""),
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor))),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              seachField,
              const SizedBox(height: 10),
              FutureBuilder<List<Reservation>?>(
                  future: _futureReservations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height / 2 - 200,
                            horizontal: 0),
                        child: Text(
                          'No connection was found. Please check if you are connected!',
                          style: TextStyle(
                              color: Theme.of(context).dividerColor,
                              fontSize: 20),
                        ),
                      );
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height / 2 - 200,
                            horizontal: 0),
                        child: Text(
                          'Keine Reservierungen vorhanden',
                          style: TextStyle(
                              color: Theme.of(context).dividerColor,
                              fontSize: 20),
                        ),
                      );
                    } else {
                      final cards = snapshot.data!;
                      return ReservationView(
                          reservations: cards,
                          context: context,
                          searchstring: _searchString,
                          setState: setState);
                    }
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: const Icon(
            Icons.replay,
            color: Colors.white,
          ),
          onPressed: () => {_reloadReaderCards()},
        ));
  }
}


  //@TODO and voidCallback


