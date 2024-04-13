///GRACE DO
import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';

class SubstantialEntry extends StatelessWidget {
  const SubstantialEntry({super.key, required this.updatePage});

  final void Function(int) updatePage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Information Form',
      home: HealthInfoForm(updatePage: updatePage),
    );
  }
}

class HealthInfoForm extends StatefulWidget {
  final void Function(int) updatePage;

  const HealthInfoForm({super.key, required this.updatePage});

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
      appBar: DefaultAppBar(title: "Health Info Entry"),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Date of birth',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Weight',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Height',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Other health information',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            const Text(
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
                widget.updatePage(1);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
