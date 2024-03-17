import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'question.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key, required this.name});

  final String name;

  Future<List<Question>> fetchQuestions(List<String> selectedCategories,
      List<String> selectedDifficulties) async {
    String url =
        'https://the-trivia-api.com/v2/questions?categories=${selectedCategories.join(',')}&difficulties=${selectedDifficulties.join(',')}&limit=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(url);
      return (jsonDecode(response.body) as List<dynamic>)
          .map((item) => Question.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  State<Quiz> createState() => _QuizPageState();
}

class _QuizPageState extends State<Quiz> {
  late Future<List<Question>> futureQuestions;

  List<String> _selectedCategories = [];
  List<String> _selectedDifficulties = ['easy'];

  void checkSelectedAnswer(String selectedAnswer, String correctAnswer) {
    if (selectedAnswer == correctAnswer) {
      print('Correct');
    } else {
      print('Incorrect');
    }
  }

  @override
  void initState() {
    super.initState();
    futureQuestions = Quiz(name: widget.name)
        .fetchQuestions(_selectedCategories, _selectedDifficulties);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<List<Question>>(
          future:
          widget.fetchQuestions(_selectedCategories, _selectedDifficulties),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> answers = List<String>.from(snapshot.data![0].incorrectAnswers)
                ..add(snapshot.data![0].correctAnswer);
              answers.shuffle();

              return Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/v859-katie-11.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 100,
                            ),
                            Text(snapshot.data![0].questionText,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30)),
                            const SizedBox(
                              height: 50,
                            ),
                            Column(
                              children: answers.map((answer) {
                                return Column(
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        checkSelectedAnswer(answer, snapshot.data![0].correctAnswer);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(500, 50),
                                      ),
                                      child: Text(answer),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.fetchQuestions(
                                    _selectedCategories, _selectedDifficulties);
                              },
                              child: const Text('Skip'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SettingsDialog(
                              selectedCategories: _selectedCategories,
                              selectedDifficulties: _selectedDifficulties,
                              onCategoriesChanged: (categories) {
                                setState(() {
                                  _selectedCategories = categories;
                                });
                              },
                              onDifficultiesChanged: (difficulties) {
                                setState(() {
                                  _selectedDifficulties = difficulties;
                                });
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.settings),
                      alignment: Alignment.center,
                      iconSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: Text(
                      widget.name,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

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
  List<String> _selectedDifficulties = ['easy'];

  final List<String> _categories = [
    "music",
    "sport_and_leisure",
    "film_and_tv",
    "arts_and_literature",
    "history",
    "society_and_culture",
    "science",
    "geography",
    "food_and_drink",
    "general_knowledge"
  ];
  final List<String> _difficulties = ['easy', 'medium', 'hard'];

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
                labelText: "Select Categories",
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
                labelText: "Select Difficulties",
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