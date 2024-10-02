import 'package:bus_app/app_localization/l10n.dart';
import 'package:bus_app/src/features/bus_location_history/presentation/page/bus_location_history_page.dart';
import 'package:bus_app/src/features/home_page/data/model/bus_location.dart';
import 'package:bus_app/src/features/map_page/presentation/pages/map_page.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/repository/bus_location_repository_impl.dart';
import '../bloc/bus_location_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime currentDate = DateTime.now();
  List<DateTime> _dates = [];
  late List<BusLocationModel> busLocationModel;
  List<LatLng> busCoordinates = [];

  @override
  void initState() {
    super.initState();

    // Add the currentDate (truncated to y-m-d) to _dates inside initState
    _dates.add(DateTime(currentDate.year, currentDate.month, currentDate.day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: const Text("GPS Tracking"),
          elevation: 5,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 5,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.single,
                selectedDayHighlightColor: Colors.blueAccent,
                weekdayLabels: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
                weekdayLabelTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                dayTextStyle: const TextStyle(),
                selectedDayTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                todayTextStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: _dates,
              onValueChanged: (dates) {
                setState(() {
                  _dates = dates;
                  print(_dates);
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => BusLocationBloc(
                                RepositoryProvider.of<
                                    BusLocationRepositoryImpl>(context),
                                _dates,
                              )..add(GetBusLocationEvent()),
                              child: BlocBuilder<BusLocationBloc,
                                  BusLocationState>(
                                builder: (context, state) {
                                  if (state is BusLocationLoadingState) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ));
                                  }
                                  if (state is BusLocationSuccessState) {
                                    busLocationModel =
                                        state.busLocationResponse;
                                    busCoordinates.clear();
                                    for (var location in busLocationModel) {
                                      double latitude =
                                          double.parse(location.latitude);
                                      double longitude =
                                          double.parse(location.longitude);
                                      busCoordinates
                                          .add(LatLng(latitude, longitude));
                                    }
                                    return BusLocationHistoryPage(
                                      locationHistory: busCoordinates,
                                    );
                                  }
                                  if (state is BusLocationFailureState) {
                                    return const Center(
                                        child: Text('Something went wrong'));
                                  }
                                  return const Center(
                                      child: Text('Unable to load data'));
                                },
                              ),
                            )));
              },
            ),
          ),
        ));
  }
}
