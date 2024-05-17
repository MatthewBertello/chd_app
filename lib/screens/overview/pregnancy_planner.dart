// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:heart_safe/models/pregnancy_model.dart';
import 'package:flutter/material.dart';
import 'package:heart_safe/components/default_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

///Author: Matthew Bertello, Pachia Lee
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known

// Builds the pregnancy planner
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
  TextEditingController eventLocationTextFieldController =
      TextEditingController();
  DateFormat timeFormat = DateFormat('h:mm a');
  List events = [];

  // Initializer
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

  // Builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
          context: context, title: const Text('Pregnancy Planner')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createTableCalendar(), // For the calendar
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: createToDoAdder(), // For adding a to do item
          ),
          showToDoItems(), // For showing the to do list
        ],
      ),
    );
  }

  // Method that creates a calendar
  TableCalendar createTableCalendar() {
    return TableCalendar(
      headerStyle: const HeaderStyle(
          formatButtonVisible: false // Get rid of the format button
          ),
      onPageChanged: (focusedDay) => today = focusedDay,
      focusedDay: today,
      firstDay: DateTime(
          today.year - 1, DateTime.january, 1), // first day of the month
      lastDay: DateTime(
          today.year + 1, DateTime.december, 0), // last day of the month
      selectedDayPredicate: (day) => isSameDay(today, day),
      // When a day is selected popup a dialog and show that day's events
      onDaySelected: (selectedDay, focusedDay) =>
          _onDaySelected(selectedDay),
      calendarBuilders: CalendarBuilders(
        // Build the calendar
        headerTitleBuilder: (context, day) {
          // Build the header of the calendar
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // Display current month and year
                  '${getMonth(day.month)} ${day.year}',
                  style: TextStyle(
                      color: Colors.purple[300],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  // Icon for adding an event
                  icon: Icon(
                    Icons.add,
                    color: Colors.purple[200],
                  ),
                  onPressed: () =>
                      showAddEventDialog('Add New Event', addEvent),
                )
              ]);
        },
      ),
    );
  }

  // Method for creating field for adding a to do item
  Row createToDoAdder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Checkbox(
          // A checkbox that does nothing
          value: false,
          onChanged: null,
        ),
        SizedBox(
            // Text field for user to type in a to do
            height: 45,
            width: MediaQuery.of(context).size.width - 100,
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                  hintText: 'Add to your list',
                  labelStyle: TextStyle(fontSize: 10)),
            )),
        SizedBox(
            // Icon to add the to do item to the list
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => addToDo(textController.text, false),
            ))
      ],
    );
  }

  // Method to show all of the items in the to do list
  Expanded showToDoItems() {
    return Expanded(
      child: ListView.builder(
          // length of the to do list
          itemCount: Provider.of<PregnancyModel>(context).toDos.length,
          itemBuilder: (context, index) {
            return ListTile(
                leading: Checkbox(
                  value: Provider.of<PregnancyModel>(context).toDos[index]
                      ['is_checked'],
                  onChanged:
                      (value) => // If the checkbox is checked update it to true in db
                          Provider.of<PregnancyModel>(context, listen: false)
                              .updateCheckBox(
                                  value,
                                  Provider.of<PregnancyModel>(context,
                                          listen: false)
                                      .toDos[index]),
                ),
                title: Text(// Show the to do item
                    '${Provider.of<PregnancyModel>(context).toDos[index]['to_do']}'),
                trailing: IconButton(
                  icon: const Icon(
                      Icons.delete), // Icon to delete the to do item if pressed
                  onPressed: () => Provider.of<PregnancyModel>(context,
                          listen: false)
                      .deleteToDo(
                          Provider.of<PregnancyModel>(context, listen: false)
                              .toDos[index]['to_do_id']),
                ));
          }),
    );
  }

  // Adds a to do to the list and clears the text field
  void addToDo(String todo, bool isChecked) {
    Provider.of<PregnancyModel>(context, listen: false)
        .addToDo(todo, isChecked);
    textController.clear();
  }

  // If a day in the calendar is selected display that day's events
  Future<void> _onDaySelected(DateTime day) async {
    await Provider.of<PregnancyModel>(context, listen: false)
        .selectEvents(day); // set the all the events from that day in the model
    setState(() {
      today =
          day; // Just so that the day you select is visibly shown in calendar
      showDialog(
        // Show the popup
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display the day
                  Text(
                      '${getWeekday(day.weekday)}, ${getMonth(day.month)} ${day.day} ${day.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  showEvents(), // Show the day's events
                  const SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // Converts a day number to the day of the week
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

  // Converts a month number to the name of the month
  String getMonth(int monthNum) {
    String month = "";
    switch (monthNum) {
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

  // Pop up that either shows add event or update event dialog
  void showAddEventDialog(String dialogTitle, Function addOrUpdate,
      {String event = 'Title',
      String? location = 'Location',
      String date = 'Date',
      String time = 'Time'}) {
    if (dialogTitle.contains('Update')) {
      // If the dialog is supposed to be an update
      // Set all of the fields to the current event's details
      eventTitleTextFieldController.text = event;
      eventLocationTextFieldController.text =
          (location == null) ? "" : location;
      eventDateTextFieldController.text = date;
      eventTimeTextFieldController.text = time;
    }
    showDialog(
      // Show the pop up
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
                      Text(
                        dialogTitle,
                        style: const TextStyle(
                            color: Colors.purple, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => addOrUpdate(),
                      )
                    ]),
                TextFormField(
                  // For the title of the event
                  controller: eventTitleTextFieldController,
                  decoration: InputDecoration(
                    prefix: const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    hintText: event,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                    // For the location of the event
                    controller: eventLocationTextFieldController,
                    decoration: InputDecoration(
                        prefix: const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        hintText: location,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0))),
                const SizedBox(height: 20),
                TextFormField(
                  // For the date of the event
                  controller: eventDateTextFieldController,
                  onTap: () => popUpDatePicker(), // Pop up the date picker
                  decoration: InputDecoration(
                      prefix: const Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      hintText: date,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      alignLabelWithHint: true),
                ),
                const SizedBox(height: 20),
                TextFormField(
                    // For the time of the event
                    controller: eventTimeTextFieldController,
                    onTap: () => popUpTimePicker(), // Pop up the time picker
                    decoration: InputDecoration(
                        prefix: const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        hintText: time,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0))),
              ],
            ),
          ),
        );
      },
    );
  }

  // Pops up the date picker and sets the date that is selected
  Future<void> popUpDatePicker() async {
    final DateTime? datePicked = await showDatePicker(
        // Show the date picker
        context: context,
        firstDate: DateTime.now(), // Default for the first day
        lastDate: DateTime(today.year + 1, DateTime.december,
            0)); // last day is december of next year

    setState(() {
      selectedEventDateTime =
          datePicked; // Set the date that is selected and show it in the textfield
      eventDateTextFieldController.text =
          '${selectedEventDateTime!.month}/${selectedEventDateTime!.day}/${selectedEventDateTime!.year}';
    });
  }

  // Pops up the time picker and sets the time that is picked
  Future<void> popUpTimePicker() async {
    // Pop up for time picker
    final TimeOfDay? timePicked = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
    setState(() {
      // Set the time
      selectedEventDateTime = DateTime(
          selectedEventDateTime!.year,
          selectedEventDateTime!.month,
          selectedEventDateTime!.day,
          timePicked!.hour,
          timePicked.minute);
      // format the time and display it in the text field
      eventTimeTextFieldController.text =
          timeFormat.format(selectedEventDateTime!);
    });
  }

  // Adds an event to the database according to the text fields
  void addEvent() {
    Provider.of<PregnancyModel>(context, listen: false).addEvent(
        // Add event to the database
        eventTitleTextFieldController.text,
        eventLocationTextFieldController.text,
        selectedEventDateTime);

    setState(() {
      // Clear the text fields and pop off
      eventTitleTextFieldController.clear();
      eventDateTextFieldController.clear();
      eventTimeTextFieldController.clear();
      Navigator.of(context).pop();
    });
  }

  Future<void> deleteEvent(int eventID, DateTime currentDate) async {
    await Provider.of<PregnancyModel>(context, listen: false).deleteEvent(eventID);
    Navigator.of(context).pop();
    await _onDaySelected(currentDate);
  }

  // Updates an event to the database according to the text fields
  Future<void> updateEvent(int eventID) async {
    // Update the event
    await Provider.of<PregnancyModel>(context, listen: false).updateEvent(
        eventID,
        eventTitleTextFieldController.text,
        eventLocationTextFieldController.text,
        eventDateTextFieldController.text,
        eventTimeTextFieldController.text);
    var currentDate = DateTime.parse(eventDateTextFieldController.text);

    setState(() {
      // Clear the text fields and pop off
      eventTitleTextFieldController.clear();
      eventLocationTextFieldController.clear();
      eventDateTextFieldController.clear();
      eventTimeTextFieldController.clear();

    });

    Navigator.of(context).pop();
    Navigator.of(context).pop();
    await _onDaySelected(currentDate);
  }

  // Show the events
  Widget showEvents() {
    events = Provider.of<PregnancyModel>(context).events; // Get the events from the model

    if(events.isEmpty) {
      return const Text('No events');
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: IconButton(
              icon: const Icon(Icons.edit, size: 17),
              // If the edit icon is pressed show the update event dialog
              onPressed: () {
                showAddEventDialog(
                  'Update Event',
                  () async => await updateEvent(events[index]['event_id']),
                  event: events[index]['event'],
                  location: events[index]['location'],
                  date: events[index]['event_date'],
                  time: formatStringTime(
                    events[index]['event_time'],
                  ),
                );
              },
            ),
            // Event title
            title: (events[index]['event'] == null)
                ? null
                : Text('${events[index]['event']}',
                    style: const TextStyle(fontSize: 15)),
            // Event location
            subtitle: (events[index]['location'] == null)
                ? null
                : Text('Location: ${events[index]['location']}',
                    style: const TextStyle(fontSize: 10)),
            // Event time
            trailing: (events[index]['event_time'] == null)
                ? null
                : SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(formatStringTime(events[index]['event_time']), style: TextStyle()),
                      Center(child: IconButton(onPressed: () async => await deleteEvent(events[index]['event_id'], DateTime.parse(events[index]['event_date'])), icon: const Icon(Icons.delete)))
                  ]),
                ),
          );
        });
    }
  }

  // Formats a military time to a normal time
  String formatStringTime(String time) {
    List timeSplit = time.split(":"); // Split by the :
    String aMpM = (int.parse(timeSplit[0]) > 12)
        ? "PM"
        : "AM"; // If the hour is more than 12 its PM
    // If the hour is more than 12, subtract 12 from it
    String hour = (int.parse(timeSplit[0]) > 12)
        ? '${int.parse(timeSplit[0]) - 12}'
        : timeSplit[0];
    String min = timeSplit[1];

    return '$hour:$min $aMpM';
  }

  // Converts a normal time to military time
  String convertToMilitaryTime(String time) {
    List timeSplit =
        time.split(' '); // Split by space to separate the time from AM or PM
    List hourMin = timeSplit[0].split(':'); // Split to separate hour and min
    String hour = hourMin[0];
    String min = hourMin[1];

    if (timeSplit[1] == 'PM') {
      // If its pm, add 12 to the hour
      hour = '${int.parse(hour[0]) + 12}';
    }

    if (hour.length < 2) {
      // if the hour is less than 2 digits, pad it with a 0
      hour = '0$hour';
    }

    return '$hour:$min:00';
  }
}
