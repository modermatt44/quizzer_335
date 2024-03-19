import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzer_335/quiz.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
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
      home: const HomePage(title: 'Quizzer'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String _name = '';
  late AnimationController _controller;
  late Animation _animation;
  Color _borderColor = Colors.black;

  late final SharedPreferences prefs;

  late int sharedPoints;
  late String sharedName;

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 15.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> loadSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      sharedPoints = prefs.getInt('sharedPoints') ?? 0;
      sharedName = prefs.getString('sharedName') ?? '';
    });
  }

  void newGame() {
    prefs.setInt('sharedPoints', 0);
    prefs.setString('sharedName', '');
    setState(() {
      sharedPoints = 0;
      sharedName = '';
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(title: 'Quizzer')));
  }

  Future<void> _startQuiz() async {
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
    prefs.setString('sharedName', _name);
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
      body: PopScope(
          canPop: false,
          child: Builder(builder: (context) {
            if (sharedName == '') {
              return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/v859_katie_11.jpg'),
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
                                image:
                                    AssetImage('assets/images/logo_color.png'),
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
                                      if (_controller.status ==
                                              AnimationStatus.completed ||
                                          _controller.status ==
                                              AnimationStatus.forward) {
                                        _controller.reverse();
                                      }
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: _borderColor)),
                                    labelText: 'Enter your name',
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
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
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey,
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
                  ));
            } else {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: PopScope(
                    canPop: false,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/v859_katie_11.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 100),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Quiz(name: sharedName)));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Continue as: ',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' $sharedName',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '?',
                                      ),
                                      const TextSpan(
                                        text: ' You have ',
                                      ),
                                      TextSpan(
                                        text: ' $sharedPoints ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' points!',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: newGame,
                                  child: const Text(
                                    'New Game!',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )),
              );
            }
          })),
    );
  }
}
