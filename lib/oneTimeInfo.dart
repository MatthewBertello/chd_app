///GRACE DO
import 'package:flutter/material.dart';

class SubstantialEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Information Form',
      home: HealthInfoForm(),
    );
  }
}

class HealthInfoForm extends StatefulWidget {
  @override
  _HealthInfoFormState createState() => _HealthInfoFormState();
}

class _HealthInfoFormState extends State<HealthInfoForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Assuming you have a class for health concerns that you will fetch from your backend or service
  List<String> healthConcerns = [
    'Health concern 1',
    'Health concern 2',
    'Health concern 3',
    '...',
    'Health concern n',
  ];

  Map<String, bool> selectedConcerns = {};

  @override
  void initState() {
    super.initState();
    // Initialize the selection state
    for (var concern in healthConcerns) {
      selectedConcerns[concern] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Information', style: TextStyle(
      color: Colors.white, fontSize: 25)),
        backgroundColor: Colors.red,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date of birth',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Weight',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Height',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Other health information',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16.0),
            Text(
              'Health concerns (check all that apply):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...healthConcerns.map((concern) {
              return CheckboxListTile(
                title: Text(concern),
                value: selectedConcerns[concern],
                onChanged: (bool? value) {
                  setState(() {
                    selectedConcerns[concern] = value!;
                  });
                },
              );
            }).toList(),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement the submit logic (with db milestone)
              },
              style: ButtonStyle(
                 backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Makes the button rectangular
                      side: BorderSide( width: 2.0), // blue boarder for the button
                    ),
                  ),
                ),
              child: Text('Submit'style: TextStyle(
      color: Colors.white, fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }
}