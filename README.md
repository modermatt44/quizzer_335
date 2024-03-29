# Quizzer 335

![Logo](assets/images/logo_color.png)
AI generated Logo

Quizzer 335 is a trivia quiz application built with Flutter and Dart. The application fetches questions from an API and presents them to the user. The user can select an answer from the given options. Points are awarded for correct answers and deducted for incorrect ones.

## Features

- Fetches questions from an API
- Presents multiple choice questions to the user
- Awards points for correct answers
- Deducts points for incorrect answers
- Allows the user to skip questions
- Displays the user's current points
- Uses a reaction game to keep brain active

## Getting Started

To get a local copy up and running, follow these steps:

1. Clone the repository: `git clone https://github.com/modermatt44/quizzer-335.git`
2. Navigate into the cloned repository: `cd quizzer-335`
3. Install the required packages: `flutter pub get`
4. Run the application: `flutter run`

## Dependencies

- [http](https://pub.dev/packages/http) - A composable, multi-platform, Future-based API for HTTP requests
- [dropdown_search](https://pub.dev/packages/dropdown_search) - A flutter package for a dropdown with search feature
- [vibration](https://pub.dev/packages/vibration) - A Flutter plugin for vibration feedback
- [shake](https://pub.dev/packages/shake) - A Flutter plugin for detecting shake events
- [cupertino_icons](https://pub.dev/packages/cupertino_icons) - An asset containing Cupertino icons

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

## Testkonzept und Testprotokoll

Das Testkonzept und das Testprotokoll sind im Verzeichnis `testing` zu finden.

## Diagramme

Die Diagramme sind im Verzeichnis `diagrams` zu finden.

## Info zu linter

Der Linter wurde mithilfe von `flutter_linter` konfiguriert. Die Konfiguration ist im Verzeichnis `analysis_options.yaml` zu finden. Jedoch ist es per se nicht möglich eine rule zu aktivieren, welche verhindert, dass eine Methode länger als 30 Zeilen ist, oder, dass alle Variablen und Methoden in Englisch bennant werden. Auch gibt es keine rule um CamelCase zu erzwingen. Es wäre jedoch möglich eine eigene rule zu schreiben, welche dies erzwingt. Dies ist aber ziemlich komplex und würde den Rahmen dieses Projektes sprengen. 
Link zu docs für custom rules: [Custom Linter Rules](https://invertase.io/blog/custom-linter-rules)