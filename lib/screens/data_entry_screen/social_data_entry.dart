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


final List<String> maritalStatus = ['single','married','divorced','partnered','widowed','other']; 
 String? selectedStatus; ///tracks selected status
 
final List<String> education = ['K-6','Some HS','Completed HS','some college','technical college','college graduate','graduate level']; 
String? selectedEducation; ///tracks selected education level

final List<String> income = ['10,000','11,000-20,000','']; ///>$10K, $11-20K, $21-30K, $31-50, $51-75, $75-100K, $100-150, $150+
String? selectedIncome; ///tracks selected income

final List<String> employements = ['methedone','suboxone','none']; ///Unemployed, PT, FT
String? selectedEmployement;

final List<String> language = ['methedone','suboxone','none']; ///Write in, English, Spanish, French, Hmong, Somalia othe
String? selectedLanguage;

final List<String> family = ['methedone','suboxone','none']; ///Husband, wife, brother, sister, child-m/f #s, grandmother, grandfather, aunt, uncle, friend, other
String? selectedFamily;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text("Social data entry")),
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
