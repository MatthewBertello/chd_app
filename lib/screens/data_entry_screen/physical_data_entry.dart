import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';

class SubstantialEntry extends StatelessWidget {
  const SubstantialEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Health Information Form',
      home: PhysicalDataEntry(),
    );
  }
}

class PhysicalDataEntry extends StatefulWidget {
  const PhysicalDataEntry({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _PhysicalDataEntryState createState() => _PhysicalDataEntryState();
}

class _PhysicalDataEntryState extends State<PhysicalDataEntry> {
  final _formKey = GlobalKey<FormState>();

  ///mental health concerns
  List<String> healthConcerns = [ ///anxiety, depression, post pardon, bipolar, schizophrenia,
    'Anxiety',
    'Depression',
    'Bipolar',
    'Attention deficit hyperactivity disorder (ADHD)',
    'Attention deficit disorder(ADD)',
    'Schizophrenia',
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

///list for recreational drug use
 List<String> recreationalDrugs = [ /// meth, cocaine, marijuana, crack, heroin, speed, prescript-opioids,
    'Meth',
    'Cocaine',
    'Crack',
    'Marijuana',
    'Speed',
    'Prescription opioids'
  ];

  Map<String, bool> selectedDrugs = {};

  void state1() {
    super.initState();
    // Initialize the selection state
    for (var recreationalDrugs in recreationalDrugs) {
      selectedConcerns[recreationalDrugs] = false;
    }
  }

///drug use selection (methedone or suboxone, none)
final List<String> drugUse = ['methedone','suboxone','none'];

  String? selectedDrug; ///tracks selected drug

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text("Physical data entry")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'last Menstural cycle', ///prompt user for last mestural cycle
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Number of live pregnancies', ///prompt user for # of live pregnancies
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Number of Miscarriages',        ///prompt user for # of miscarriages
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
             TextFormField(
              decoration: const InputDecoration(
                hintText: 'Expected due date',  ///prompt for expected due date
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Immunization hx- COVID, flu, MMR',  ///prompt for immunization
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Mental Health History:', ///prompt user for mental health diagnosies
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...healthConcerns.map((concern) { ///lists mental health concerns
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
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'perscription meds', ///prompt user to enter perscription meds
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            const Text('Drug Use'),
             ListView(  ///lists the drugs off from the database
             children: drugUse.map((option) {
              return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: selectedDrug,
              onChanged: (String? value) {
              setState(() {
                selectedDrug = value;
              });
            },
          );
        }).toList(),
        ),
          const SizedBox(height: 16.0),
            const Text(
              'Recreational drug:', ///prompt user for recreational drug use
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...recreationalDrugs.map((recreationalDrugs) {
              return CheckboxListTile(
                title: Text(recreationalDrugs),
                value: selectedDrugs[recreationalDrugs],
                onChanged: (bool? value) {
                  setState(() {
                    selectedDrugs[recreationalDrugs] = value!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                //widget.updatePage(1);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
