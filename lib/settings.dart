import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    required this.selectedCategories,
    required this.selectedDifficulties,
    required this.onCategoriesChanged,
    required this.onDifficultiesChanged,
  });

  final List<String> selectedCategories;
  final List<String> selectedDifficulties;
  final ValueChanged<List<String>> onCategoriesChanged;
  final ValueChanged<List<String>> onDifficultiesChanged;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  List<String> _selectedCategories = [];
  List<String> _selectedDifficulties = ['easy', 'medium', 'hard'];

  final List<String> _categories = [
    'music',
    'sport_and_leisure',
    'film_and_tv',
    'arts_and_literature',
    'history',
    'society_and_culture',
    'science',
    'geography',
    'food_and_drink',
    'general_knowledge'
  ];
  final List<String> _difficulties = ['easy', 'medium', 'hard'];

  Future<void> clearSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _selectedCategories = widget.selectedCategories;
    _selectedDifficulties = widget.selectedDifficulties;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownSearch<String>.multiSelection(
            popupProps: const PopupPropsMultiSelection.menu(
              showSelectedItems: true,
            ),
            items: _categories,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Select Categories',
              ),
            ),
            onChanged: (value) {
              setState(() {
                _selectedCategories = value;
              });
              widget.onCategoriesChanged(_selectedCategories);
            },
            selectedItems: _selectedCategories,
          ),
          DropdownSearch<String>.multiSelection(
            popupProps: const PopupPropsMultiSelection.menu(
              showSelectedItems: true,
            ),
            items: _difficulties,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Select Difficulties',
              ),
            ),
            onChanged: (value) {
              setState(() {
                _selectedDifficulties = value;
              });
              widget.onDifficultiesChanged(_selectedDifficulties);
            },
            selectedItems: _selectedDifficulties,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(onPressed: () {
          clearSharedPrefs();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));
        },
            child: const Text('Logout')),
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}