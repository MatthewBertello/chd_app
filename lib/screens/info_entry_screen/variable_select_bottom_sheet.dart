import 'package:chd_app/components/tile.dart';
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Center(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchableList<Map<String, dynamic>>.expansion(
              hideEmptyExpansionItems: true,
              closeKeyboardWhenScrolling: true,
              expansionTitleBuilder: (category) {
                return Tile(
                  child: Center(
                    child: Text(category.toString()),
                  ),
                );
              },
              expansionListData: Provider.of<InfoEntryModel>(context)
                  .categorizedVariableDefinitions,
              expansionListBuilder: listItemBuilder,
              filterExpansionData: (value) {
                value = value.toLowerCase();
                final filteredMap = {
                  for (final entry
                      in Provider.of<InfoEntryModel>(context, listen: false)
                          .categorizedVariableDefinitions
                          .entries)
                    entry.key: entry.value
                        .where((element) =>
                            element['name'].toLowerCase().contains(value))
                        .toList()
                };
                return filteredMap;
              },
              emptyWidget: const Text("empty"),
              inputDecoration: const InputDecoration(
                labelText: "Search Variables",
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: 80,
            height: 40,
            margin: const EdgeInsets.only(bottom: 25),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              shape: const StadiumBorder(),
              child: const Icon(Icons.keyboard_arrow_down, size: 35),
            ),
          ),
        ),
      ),
    );
  }

  Widget listItemBuilder(int index, Map<String, dynamic> item) {
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
                circleColor: const CircleColor(
                    start: Colors.transparent, end: Colors.transparent),
                bubblesColor: const BubblesColor(
                    dotPrimaryColor: Colors.transparent,
                    dotSecondaryColor: Colors.transparent,
                    dotThirdColor: Colors.transparent,
                    dotLastColor: Colors.transparent),
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
