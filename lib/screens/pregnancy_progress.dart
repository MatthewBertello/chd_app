import 'package:flutter/material.dart';
import 'package:chd_app/components/default_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class PregnancyProgress extends StatefulWidget {
  @override
  State<PregnancyProgress> createState() => _PregnancyProgressState();
}

class _PregnancyProgressState extends State<PregnancyProgress> {
  var _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text('Pregnancy Planner')),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay, 
            firstDay: DateTime(_focusedDay.year, _focusedDay.month, 1 ), 
            lastDay: DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
            onPageChanged:(focusedDay) {
              setState(() {_focusedDay = focusedDay;});
            },
            onFormatChanged:(format) => setState(() => _calendarFormat = format),

          ),
        ],
      )
    );
  }
}