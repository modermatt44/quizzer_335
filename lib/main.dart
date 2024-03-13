import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzer_335/quiz.dart';
import 'package:vibration/vibration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quizzer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Quizzer'),
        routes: {
          '/quiz': (context) => const Quiz(name: ''),
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  var _name = '';
  late AnimationController _controller;
  late Animation _animation;
  Color _borderColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 15.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _startQuiz() async {
    if (_name.isEmpty) {
      _controller.forward().then((_) => _controller.reverse());
      setState(() {
        _borderColor = Colors.red;
      });
      return;
    }
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    } else {
      HapticFeedback.heavyImpact();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Quiz(name: _name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/v859-katie-11.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo-color.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.translate(
                        offset: Offset(_animation.value, 0),
                        child: TextField(
                          maxLength: 20,
                          onChanged: (text) {
                            setState(() {
                              _name = text;
                              _borderColor = Colors.black;
                              if (_controller.status == AnimationStatus.completed ||
                                  _controller.status == AnimationStatus.forward) {
                                _controller.reverse();
                              }
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide(color: _borderColor)),
                            labelText: 'Enter your name',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _startQuiz();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text('Enter Quizzer!'),
                  ),
                ],
              ),
            ),
          )
        )
    );
  }
}
