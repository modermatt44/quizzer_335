import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'quiz.dart';

class ReactionPage extends StatefulWidget {
  const ReactionPage({super.key, required this.currentPoints, required this.currentName});

  final int currentPoints;
  final String currentName;

  @override
  State<ReactionPage> createState() => _ReactionPageState();
}

class _ReactionPageState extends State<ReactionPage> {
  int elapsedReaction = 0;
  Stopwatch stopWatchReaction = Stopwatch();
  Timer? timer;
  late ShakeDetector detector;

  int _points = 0;
  String _name = '';

  void calculatePoints() {
    if (elapsedReaction < 200) {
      _points += 100;
    } else if (elapsedReaction < 300) {
      _points += 80;
    } else if (elapsedReaction < 400) {
      _points += 60;
    } else if (elapsedReaction < 500) {
      _points += 50;
    } else if (elapsedReaction < 600) {
      _points += 20;
    } else if (elapsedReaction < 700) {
      _points += 10;
    } else if (elapsedReaction < 800) {
      _points += 5;
    } else if (elapsedReaction < 900) {
      _points += 0;
    } else if (elapsedReaction > 900) {
      _points -= 5;
    }
  }

  @override
  void initState() {
    super.initState();
    _points = widget.currentPoints;
    _name = widget.currentName;

    int points = widget.currentPoints;
    stopWatchReaction.start();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        stopWatchReaction.stop();
        calculatePoints();
        detector.stopListening();
        timer?.cancel();
        stopWatchReaction.reset();
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Quiz(name: _name, points: _points),
            ),
          );
        });
      });
    });
    timer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
      setState(() {
        elapsedReaction = stopWatchReaction.elapsed.inMilliseconds;
        print(elapsedReaction);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.blue,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('Shake your phone to stop the timer!', style: TextStyle(fontSize: 30)),
              const SizedBox(height: 20),
              Text('$elapsedReaction ms', style: const TextStyle(fontSize: 24, color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    stopWatchReaction.stop();
    detector.stopListening();
  }
}
