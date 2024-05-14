import 'package:heart_safe/components/tile.dart';
import 'package:heart_safe/models/info_entry_model.dart';
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
            // Searchable List widget
            child: SearchableList<Map<String, dynamic>>.expansion(
              hideEmptyExpansionItems: true,
              closeKeyboardWhenScrolling: true,
              // Builds the category headers
              expansionTitleBuilder: (category) {
                return Tile(
                  child: Center(
                    child: Text(category.toString()),
                  ),
                );
              },
              // The data to populate the list with
              expansionListData: Provider.of<InfoEntryModel>(context)
                  .categorizedVariableDefinitions,
              expansionListBuilder: listItemBuilder,
              // The filter method for the search bar
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
              emptyWidget: const Text("No Variables Found"),
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

  // Creates the ListTile widget for each item
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
                onTap: (bool isFavorited) {
                  setState(() {
                    item['favorite'] = !isFavorited;
                    Provider.of<InfoEntryModel>(context, listen: false).updateFavorite(item['id'], !isFavorited);
                    if (!isFavorited) {
                      item['checkbox'] = true;
                    }
                  });
                  return Future.value(!isFavorited);
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
