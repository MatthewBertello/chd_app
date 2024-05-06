// ignore_for_file: avoid_print

import 'package:chd_app/models/pregnancy_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class PregnancyProgress extends StatefulWidget {
  const PregnancyProgress({super.key});

  @override
  State<PregnancyProgress> createState() => _PregnancyProgressState();
}

class _PregnancyProgressState extends State<PregnancyProgress> {
  DateTime today = DateTime.now();
  bool isChecked = false;
  TextEditingController textController = TextEditingController();
  DateTime? selectedEventDateTime = DateTime.now();
  TimeOfDay? selectedEventTime = TimeOfDay.now();
  TextEditingController eventDateTextFieldController = TextEditingController();
  TextEditingController eventTitleTextFieldController = TextEditingController();
  TextEditingController eventTimeTextFieldController = TextEditingController();
  TextEditingController eventLocationTextFieldController = TextEditingController();
  DateFormat timeFormat = DateFormat('h:mm a');

  @override
  void initState() {
    // Initialize the model if it has not been loaded
    if (Provider.of<PregnancyModel>(context, listen: false).loaded == false &&
        Provider.of<PregnancyModel>(context, listen: false).loading == false) {
      Provider.of<PregnancyModel>(context, listen: false).init();
    }
    Provider.of<PregnancyModel>(context, listen: false).selectedDate =
        DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
            context: context, title: const Text('Pregnancy Planner')),
        body: 
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false
                ),
                focusedDay: today,
                firstDay: DateTime(today.year - 1, DateTime.january, 1), // first day of the month
                lastDay: DateTime(today.year + 1, DateTime.december, 0), // last day of the month
                selectedDayPredicate: (day) => isSameDay(today, day),
                onDaySelected: (selectedDay, focusedDay) => _onDaySelected(selectedDay, focusedDay),
                calendarBuilders: CalendarBuilders(
                  headerTitleBuilder: (context, day) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${getMonth(day.month)} ${day.year}', 
                          style: TextStyle(color: Colors.purple[300], fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(icon: Icon(Icons.add, color: Colors.purple[200],), onPressed: () => showAddEventDialog(),)
                      ]
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Checkbox(
                      value: false,
                      onChanged: null,
                    ),
                    SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width - 100,
                        child: TextField(
                          controller: textController,
                          decoration: const InputDecoration(
                              hintText: 'Add to your list',
                              labelStyle: TextStyle(fontSize: 10)),
                        )),
                    SizedBox(
                        width: 50,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => addToDo(textController.text, false),
                        ))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: Provider.of<PregnancyModel>(context).toDos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          leading: Checkbox(
                              value: Provider.of<PregnancyModel>(context).toDos[index]['is_checked'],
                              onChanged: (value) =>
                                  Provider.of<PregnancyModel>(context, listen: false)
                                  .updateCheckBox(value, Provider.of<PregnancyModel>(context,listen: false).toDos[index]),),
                          title: Text(
                              '${Provider.of<PregnancyModel>(context).toDos[index]['to_do']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => Provider.of<PregnancyModel>(context, listen: false)
                                .deleteToDo(Provider.of<PregnancyModel>(context, listen: false).toDos[index]['to_do_id']),
                          ));
                    }),
              ),
            ],
          ),);
  }

  void addToDo(String todo, bool isChecked) {
    Provider.of<PregnancyModel>(context, listen: false)
        .addToDo(todo, isChecked);
    textController.clear();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${getWeekday(day.weekday)}, ${getMonth(day.month)} ${day.day} ${day.year}'),
              
              const SizedBox(
                height: 16.0,
              ),
            ],),
          ),
          );
        },
      );
    });
  }

  String getWeekday(int dayNum) {
    String weekday = "";
    switch (dayNum) {
      case 1:
        weekday = "Monday";
      case 2: 
        weekday = "Tuesday";
      case 3:
        weekday = "Wednesday";
      case 4:
        weekday = "Thursday";
      case 5:
        weekday = "Friday";
      case 6:
        weekday = "Saturday";
      case 7:
        weekday = "Sunday";
    }
    return weekday;
  }

  String getMonth(int monthNum) {
    String month = "";
    switch(monthNum) {
      case 1:
        month = "January";
      case 2:
        month = "February";
      case 3:
        month = "March";
      case 4:
        month = "April";
      case 5:
        month = "May";
      case 6:
        month = "June";
      case 7:
        month = "July";
      case 8:
        month = "August";
      case 9:
        month = "September";
      case 10:
        month = "October";
      case 11:
        month = "November";
      case 12:
        month = "December";
    }
    return month;
  }

  void showAddEventDialog()  {
    showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: 350,
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Text('Add New Event', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),), 
                IconButton(icon: const Icon(Icons.add), onPressed: () => addEvent(),)]),
              TextFormField(
                controller: eventTitleTextFieldController,
                decoration: const InputDecoration(
                  prefix: Padding(padding: EdgeInsets.all(5),),
                  hintText: 'Title', 
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: eventLocationTextFieldController,
                decoration: const InputDecoration(
                  prefix: Padding(padding: EdgeInsets.all(5),),
                  hintText: 'Location', 
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0))
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: eventDateTextFieldController,
                onTap: () => popUpDatePicker(),
                decoration: const InputDecoration(
                  prefix: Padding(padding: EdgeInsets.all(5),),
                  hintText: 'Date', 
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0), alignLabelWithHint: true),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: eventTimeTextFieldController,
                onTap: () => popUpTimePicker(),
                decoration: const InputDecoration(
                  prefix: Padding(padding: EdgeInsets.all(5),),
                  hintText: 'Time', 
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0))
              ),
            ],
          ),
        ),
      );
    },);

  }

  Future<void> popUpDatePicker() async {
    final DateTime? datePicked = await showDatePicker(
        context: context, 
        firstDate: DateTime.now(), 
        lastDate: DateTime(today.year + 1, DateTime.december, 0));

    setState(() {
        selectedEventDateTime = datePicked;
        eventDateTextFieldController.text = '${selectedEventDateTime!.month}/${selectedEventDateTime!.day}/${selectedEventDateTime!.year}';
    });
  }

  Future<void> popUpTimePicker() async {
    final TimeOfDay? timePicked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
    setState(() {   
      selectedEventDateTime = DateTime(
        selectedEventDateTime!.year,
        selectedEventDateTime!.month,
        selectedEventDateTime!.day,
        timePicked!.hour,
        timePicked.minute
      );
      eventTimeTextFieldController.text = timeFormat.format(selectedEventDateTime!);
    });
  }

  void addEvent() {
    Provider.of<PregnancyModel>(context, listen: false).addEvent(eventTitleTextFieldController.text, eventLocationTextFieldController.text,selectedEventDateTime);
    
    setState(() {
      eventTitleTextFieldController.clear();
      eventDateTextFieldController.clear();
      eventTimeTextFieldController.clear();

      Navigator.of(context).pop();
    });
  }
}
