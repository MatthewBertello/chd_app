import 'package:chd_app/models/info_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';
import 'package:searchable_listview/searchable_listview.dart';

class VariableSelectBottomSheet extends StatefulWidget {
  const VariableSelectBottomSheet({super.key});

  @override
  State<VariableSelectBottomSheet> createState() =>
      _VariableSelectBottomSheetState();
}

class _VariableSelectBottomSheetState extends State<VariableSelectBottomSheet> {
  List<bool> checkboxValues = List.filled(10, false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Center(
        child: Scaffold(
          body: SearchableList<Map<String, dynamic>>(
            initialList:
                Provider.of<InfoEntryModel>(context).variableDefinitions,
            builder: listItemBuilder,
            filter: (value) {
              value = value.toLowerCase();
              print((Provider.of<InfoEntryModel>(context, listen: false)
                      .variableDefinitions)
                  .where(
                    (element) => element['name'].toLowerCase().contains(value),
                  )
                  .toList());
              return Provider.of<InfoEntryModel>(context, listen: false)
                  .variableDefinitions
                  .where((element) =>
                      element['name'].toLowerCase().contains(value))
                  .toList();
            },
            emptyWidget: const Text("empty"),
            inputDecoration: const InputDecoration(
              labelText: "Search Variables",
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }

  Widget listItemBuilder(
      List<Map<String, dynamic>> list, int index, Map<String, dynamic> item) {
    return ListTile(
      title: Text(item['name']),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: LikeButton(
                animationDuration: const Duration(milliseconds: 0),
                circleColor: const CircleColor(start: Colors.transparent, end: Colors.transparent),
                bubblesColor: const BubblesColor(dotPrimaryColor: Colors.transparent, dotSecondaryColor: Colors.transparent, dotThirdColor: Colors.transparent, dotLastColor: Colors.transparent),
                bubblesSize: 0,
                isLiked: item['favorite'],
                onTap: (bool isLiked) {
                  setState(() {
                    item['favorite'] = !isLiked;
                    if (!isLiked) {
                      item['checkbox'] = true;
                    }
                  });
                  return Future.value(!isLiked);
                },
              ),
            ),
            SizedBox(
              width: 50,
              child: Checkbox(
                value: item['checkbox'],
                onChanged: (bool? value) {
                  setState(() {
                    item['checkbox'] = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
