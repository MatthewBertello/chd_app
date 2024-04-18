import 'package:chd_app/models/info_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';

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
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SearchBar(
                  hintText: "Search",
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Provider.of<InfoEntryModel>(context)
                          .variableDefinitions
                          ?.length ??
                      0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Provider.of<InfoEntryModel>(context)
                              .variableDefinitions?[index]['name'] ??
                          ""),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: LikeButton(
                                isLiked: Provider.of<InfoEntryModel>(context)
                                        .variableDefinitions?[index]['favorite'] ??
                                    false,
                                onTap: (bool isLiked) {
                                  setState(() {
                                    Provider.of<InfoEntryModel>(context,
                                                listen: false)
                                            .variableDefinitions?[index]
                                        ['favorite'] = !isLiked;
                                  });
                                  return Future.value(!isLiked);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: Checkbox(
                                value: Provider.of<InfoEntryModel>(context)
                                        .variableDefinitions?[index]['checkbox'] ??
                                    false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    Provider.of<InfoEntryModel>(context,
                                                listen: false)
                                            .variableDefinitions?[index]
                                        ['checkbox'] = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                    );
                  },
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}
