import 'package:bus_app/app_localization/l10n.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/bus_location_repository_impl.dart';
import '../bloc/bus_location_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DateTime> _dates = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusLocationBloc(
          RepositoryProvider.of<BusLocationRepositoryImpl>(context))
        ..add(GetBusLocationEvent()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Text(l10n.busApp),
          elevation: 5,
        ),
        body: BlocBuilder<BusLocationBloc, BusLocationState>(
          builder: (context, state) {
            if (state is BusLocationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BusLocationSuccessState) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 5,
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      selectedDayHighlightColor:
                          Colors.blueAccent, // Color for selected day
                      weekdayLabels: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
                      weekdayLabelTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      dayTextStyle: const TextStyle(
                          // Color for regular days
                          ),
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.white, // Color for text in selected day
                        fontWeight: FontWeight.bold,
                      ),
                      todayTextStyle: const TextStyle(
                        color: Colors.redAccent, // Color for today's date
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: _dates,
                    onValueChanged: (dates) {
                      setState(() {
                        _dates = dates;
                        print(_dates);
                      });
                    },
                  ),
                ),
              );
            }
            if (state is BusLocationFailureState) {
              return const Center(child: Text('Something went wrong '));
            }

            return const Center(child: Text('Unable to view data'));
          },
        ),
      ),
    );
  }
}
