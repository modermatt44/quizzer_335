import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'question.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reaction.dart';
import 'dart:math' as math;
import 'settings.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key, required this.name});

  final String name;

  Future<List<Question>> fetchQuestions(List<String> selectedCategories,
      List<String> selectedDifficulties) async {
    final String url =
        'https://the-trivia-api.com/v2/questions?categories=${selectedCategories.join(',')}&difficulties=${selectedDifficulties.join(',')}&limit=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
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
  late List<String> answers;

  String selectedAnswer = '';

  List<String> _selectedCategories = [];
  List<String> _selectedDifficulties = ['easy', 'medium', 'hard'];

  late final SharedPreferences prefs;

  late int points;

  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    points = prefs.getInt('sharedPoints') ?? 0;
  }

  void prepareForNextQuestion() {
    setState(() {
      futureQuestions =
          widget.fetchQuestions(_selectedCategories, _selectedDifficulties);
      futureQuestions = Quiz(name: widget.name)
          .fetchQuestions(_selectedCategories, _selectedDifficulties);
      futureQuestions.then((questions) {
        answers = List<String>.from(questions[0].incorrectAnswers)
          ..add(questions[0].correctAnswer);
        answers.shuffle();
      });
    });
  }

  void checkSelectedAnswer(String selectedAnswer, String correctAnswer) {
    setState(() {
      final int randomReaction = math.Random().nextInt(10);
      this.selectedAnswer = selectedAnswer;
      if (selectedAnswer == correctAnswer) {
        Vibration.vibrate(duration: 100);

        points += 10;

        prefs.setInt('sharedPoints', points);

        points = prefs.getInt('sharedPoints') ?? 0;

        prepareForNextQuestion();

        if (randomReaction == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReactionPage(
                      currentName: widget.name,
                    )),
          );
        }
      } else if (points > 0) {
        points -= 5;
        prefs.setInt('sharedPoints', points);
        points = prefs.getInt('sharedPoints') ?? 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
    prepareForNextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PopScope(
          canPop: false,
          child: FutureBuilder<List<Question>>(
            future: futureQuestions,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/v859_katie_11.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 15,
                              ),
                              Text('Points: $points',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 50,
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
                                          checkSelectedAnswer(answer,
                                              snapshot.data![0].correctAnswer);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(500, 50),
                                          backgroundColor:
                                              answer == selectedAnswer &&
                                                      answer ==
                                                          snapshot.data![0]
                                                              .correctAnswer
                                                  ? Colors.green
                                                  : answer == selectedAnswer
                                                      ? Colors.red
                                                      : null,
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
                                  setState(() {
                                    prepareForNextQuestion();
                                    if (points > 0) {
                                      points -= 5;
                                      prefs.setInt('sharedPoints', points);
                                      points =
                                          prefs.getInt('sharedPoints') ?? 0;
                                    }
                                  });
                                },
                                child: const Text('Skip'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25,
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
                        top: 35,
                        right: 20,
                        child: SizedBox(
                          width: 100,
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
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
          ),
        ));
  }
}
