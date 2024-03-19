import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReactionPage extends StatefulWidget {
  const ReactionPage({super.key, required this.currentName});

  final String currentName;

  @override
  State<ReactionPage> createState() => _ReactionPageState();
}

class _ReactionPageState extends State<ReactionPage> {

  late final SharedPreferences prefs;

  int elapsedReaction = 0;
  Stopwatch stopWatchReaction = Stopwatch();
  Timer? timer;
  late ShakeDetector detector;

  late int finalPoints;
  String _name = '';

  Future<void> calculatePoints() async{
      prefs = await SharedPreferences.getInstance();
      finalPoints = prefs.getInt('sharedPoints') ?? 0;
      if (elapsedReaction < 200) {
        prefs.setInt('sharedPoints', finalPoints += 100);
      } else if (elapsedReaction < 300) {
        prefs.setInt('sharedPoints', finalPoints += 80);
      } else if (elapsedReaction < 400) {
        prefs.setInt('sharedPoints', finalPoints += 60);
      } else if (elapsedReaction < 500) {
        prefs.setInt('sharedPoints', finalPoints += 50);
      } else if (elapsedReaction < 600) {
        prefs.setInt('sharedPoints', finalPoints += 40);
      } else if (elapsedReaction < 700) {
        prefs.setInt('sharedPoints', finalPoints += 20);
      } else if (elapsedReaction < 800) {
        prefs.setInt('sharedPoints', finalPoints += 10);
      } else if (elapsedReaction < 900) {
        prefs.setInt('sharedPoints', finalPoints += 0);
      } else if (elapsedReaction > 900 && finalPoints > 5) {
        prefs.setInt('sharedPoints', finalPoints -= 5);
      } else {
        prefs.setInt('sharedPoints', finalPoints -= 0);
      }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.currentName;

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
              builder: (context) => Quiz(name: _name),
            ),
          );
        });
      });
    }, shakeThresholdGravity: 1.5);
    timer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
      setState(() {
        elapsedReaction = stopWatchReaction.elapsed.inMilliseconds;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Container(
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
      )
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
