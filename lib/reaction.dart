import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

class ReactionPage extends StatefulWidget {
  const ReactionPage({super.key});

  @override
  State<ReactionPage> createState() => _ReactionPageState();
}

class _ReactionPageState extends State<ReactionPage> {
  int elapsedReaction = 0;
  Stopwatch stopWatchReaction = Stopwatch();
  Timer? timer;
  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    stopWatchReaction.start();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        stopWatchReaction.stop();
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      });
    });
    timer = Timer.periodic(const Duration(microseconds: 1), (Timer t) {
      setState(() {
        elapsedReaction = stopWatchReaction.elapsed.inMilliseconds;
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
