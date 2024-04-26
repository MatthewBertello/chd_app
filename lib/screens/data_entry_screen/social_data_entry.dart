import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';

class SubstantialEntry extends StatelessWidget {
  const SubstantialEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Health Information Form',
      home: HealthInfoForm(),
    );
  }
}

class HealthInfoForm extends StatefulWidget {
  const HealthInfoForm({super.key});

  @override
  _HealthInfoFormState createState() => _HealthInfoFormState();
}

class _HealthInfoFormState extends State<HealthInfoForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text("Health and Lifestyle")),
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
