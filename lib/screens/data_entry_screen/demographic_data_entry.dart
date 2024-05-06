///GRACE DO
import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';

class SubstantialEntry extends StatelessWidget {
  const SubstantialEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Health Information Form',
      home: DemographicDataEntry(),
    );
  }
}
///this is the form for the demographic data entry
class DemographicDataEntry extends StatefulWidget {
  const DemographicDataEntry({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DemographicDataEntryState createState() => _DemographicDataEntryState();
}

class _DemographicDataEntryState extends State<DemographicDataEntry> {
  final _formKey = GlobalKey<FormState>();

 
  List<String> races = [ ///White, black, Hispanic, Asian, American Indian, other 
    'White',
    'Black',
    'Native American',
    'Asian',
    'Pacific Islander',
    'Other'
  ];

  Map<String, bool> selectedConcerns = {};

  @override
  void initState() {
    super.initState();
    // Initialize the selection state
    for (var concern in races) {
      selectedConcerns[concern] = false;
    }
  }

  final List<String> gender= ['Male','Female','Transitioning','Decline to answer']; 
  String? selectedGender; ///tracks selected gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text("Demographic Data")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Age', ///prompt user for age
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            const Text('Gender'),
              ListView(
             children: gender.map((option) {
              return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: selectedGender,
              onChanged: (String? value) {
              setState(() {
                selectedGender = value;
              });
            },
          );
        }).toList(),
        ),
            const SizedBox(height: 16.0),
            const Text(
              'Race(check all that apply):', ///prompt user for race
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...races.map((concern) {
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
                //widget.updatePage(1);
              },
              child: const Text('Submit'), ///submits values and sends them to database
            ),
          ],
        ),
      ),
    );
  }
}
