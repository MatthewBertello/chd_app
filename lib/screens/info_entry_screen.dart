import 'package:flutter/material.dart';

class DailyInfoWidget extends StatefulWidget {
  const DailyInfoWidget({super.key});

  @override
  State<DailyInfoWidget> createState() => _DailyInfoWidgetState();
}

class _DailyInfoWidgetState extends State<DailyInfoWidget> {
  List<Map<String, String>> items = [
    {'category': 'Select a category'}
  ];

  List<TextEditingController> controllers = [];
  
  List<String> categories = [
    'Select a category',
    'Water intake (cups)',
    'Sleep (hours)',
    'Fruit intake (servings)',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildInputs(context),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () {
                // Get the values from the text controllers
                List<String> values =
                    controllers.map((controller) => controller.text).toList();
                print(values);
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            items.add({'category': categories[0]});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Builds the app bar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Info Entry",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      flexibleSpace: Container(
          decoration: BoxDecoration(
              // Gives the app bar a gradient red color
              gradient: LinearGradient(colors: <Color>[
        const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9),
        const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
      ]))),
    );
  }

  Widget buildInputs(BuildContext context) {
    return Column(
      children: items.map((item) {
        int index = items.indexOf(item);
        TextEditingController controller = TextEditingController();
        controllers.add(controller);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: item['category'],
                  onChanged: (String? newValue) {
                    setState(() {
                      item['category'] = newValue!;
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                items.length > 1
                    ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            items.removeAt(index);
                            controllers.removeAt(index);
                          });
                        },
                      )
                    : Container(),
              ],
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.indigo[900]!, width: 1),
                ),
              ),
              style: TextStyle(
                color: Colors.indigo[900],
              ),
            ),
            
            const Divider(color: Colors.grey), // Add a divider between each item
          ],
        );
      }).toList(),
    );
  }
}
