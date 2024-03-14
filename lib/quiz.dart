import 'package:flutter/material.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  const SizedBox(
                    height: 100,
                  ),
                  const Text("Question", style: TextStyle(color: Colors.white, fontSize: 30)),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          null;
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(500, 50),
                        ),
                        child: const Text('Answer 1'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          null;
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(500, 50),
                        ),
                        child: const Text('Answer 2'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          null;
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(500, 50),
                        ),
                        child: const Text('Answer 3'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          null;
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(500, 50),
                        ),
                        child: const Text('Answer 4'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Skip'),
                  ),

                ],
              ),
            ),
          ),
            Positioned(
              top: 30,
              left: 20,
              child: IconButton(
                onPressed: () {  },
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
                name,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        )
    );
  }
}