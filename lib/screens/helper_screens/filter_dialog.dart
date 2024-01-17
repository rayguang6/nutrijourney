import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Map<String, bool> selectedFilter;
  final Function(Map<String, bool>) onApply;

  FilterDialog({Key? key, required this.selectedFilter, required this.onApply}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Map<String, bool> currentFilter;

  @override
  void initState() {
    super.initState();
    currentFilter = Map.from(widget.selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Filter Recipes"),
      content: Container(
        height: 300,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: currentFilter.keys.length,
          itemBuilder: (BuildContext context, int index) {
            String key = currentFilter.keys.elementAt(index);
            return CheckboxListTile(
              title: Text(key),
              value: currentFilter[key],
              onChanged: (bool? value) {
                setState(() {
                  currentFilter[key] = value!;
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            widget.onApply(currentFilter);
            Navigator.of(context).pop();
          },
          child: Text("Apply"),
        ),
      ],
    );
  }
}
