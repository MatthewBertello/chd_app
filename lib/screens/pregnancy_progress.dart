import 'package:chd_app/models/pregnancy_model.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class PregnancyProgress extends StatefulWidget {
  @override
  State<PregnancyProgress> createState() => _PregnancyProgressState();
}

class _PregnancyProgressState extends State<PregnancyProgress> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool isChecked = false;
  TextEditingController textController = TextEditingController();

  void addToToDo(String todo, bool isChecked) {
    Provider.of<PregnancyModel>(context, listen: false).addToToDo(todo, isChecked);
    textController.clear();
  }

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
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Checkbox(value: false, onChanged: null,),
                SizedBox(
                  height: 45,
                  width: 300,
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                    hintText: 'Add to your list',
                    labelStyle: TextStyle(fontSize: 10)
                    
                  ),)),
                IconButton(icon: const Icon(Icons.add), onPressed: () => addToToDo(textController.text, false),)
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: Provider.of<PregnancyModel>(context).toDos.length,
              itemBuilder: (context, index) {
                
                return ListTile(
                  leading: Checkbox(value: Provider.of<PregnancyModel>(context).toDos[index]['isChecked'],
                  onChanged: (value) => setState(() => Provider.of<PregnancyModel>(context, listen: false).toDos[index]['isChecked'] = value ?? false)),
                  title: Text('${Provider.of<PregnancyModel>(context).toDos[index]['todo']}'),
                  trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => Provider.of<PregnancyModel>(context, listen: false).deleteToDo(index),)
                  );
              }
            ),
          ),
        ],  
      )
    );
  }
}