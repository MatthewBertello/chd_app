import 'package:flutter/material.dart';
import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class PregnancyProgress extends StatefulWidget {
  @override
  State<PregnancyProgress> createState() => _PregnancyProgressState();
}

class _PregnancyProgressState extends State<PregnancyProgress> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List _todos = ["call OB/GYN"];
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text('Pregnancy Planner')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay, 
            firstDay: DateTime(_focusedDay.year, _focusedDay.month, 1 ), // first day of the month
            lastDay: DateTime(_focusedDay.year, _focusedDay.month + 1, 0), // last day of the month
            onPageChanged:(focusedDay) {
              setState(() => _focusedDay = focusedDay);
            },
            onFormatChanged:(format) => setState(() => _calendarFormat = format),
            pageJumpingEnabled: true,
          ),

          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Checkbox(value: false, onChanged: null,),
                Container(
                  height: 45,
                  width: 300,
                  child: TextField(decoration: InputDecoration(
                    hintText: 'Add to your list',
                    labelStyle: TextStyle(fontSize: 10)
                    
                  ),)),
                const IconButton(icon: Icon(Icons.add), onPressed: null,)
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                
                return ListTile(
                  leading: Checkbox(value: isChecked,
                  onChanged: (value) => setState(() => isChecked = value?? false)),
                  title: Text('${_todos[index]}'),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: null,)
                  );
              }
            ),
          ),
        ],  
      )
    );
  }
}