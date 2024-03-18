# Class Diagram

## Quiz Class
- Variables:
    - `name` (public, final, String)
    - `points` (public, final, int)
- Methods:
    - `fetchQuestions` (public, Future<List<Question>>, parameters: selectedCategories (List<String>), selectedDifficulties (List<String>))
    - `createState` (public, State<Quiz>, no parameters)

## _QuizPageState Class
- Variables:
    - `futureQuestions` (private, late, Future<List<Question>>)
    - `answers` (private, late, List<String>)
    - `selectedAnswer` (private, String)
    - `_selectedCategories` (private, List<String>)
    - `_selectedDifficulties` (private, List<String>)
    - `_points` (private, int)
- Methods:
    - `checkSelectedAnswer` (private, void, parameters: selectedAnswer (String), correctAnswer (String))
    - `initState` (public, void, no parameters)
    - `build` (public, Widget, parameter: context (BuildContext))

## SettingsDialog Class
- Variables:
    - `selectedCategories` (public, final, List<String>)
    - `selectedDifficulties` (public, final, List<String>)
    - `onCategoriesChanged` (public, final, ValueChanged<List<String>>)
    - `onDifficultiesChanged` (public, final, ValueChanged<List<String>>)
- Methods:
    - `createState` (public, State<SettingsDialog>, no parameters)

## _SettingsDialogState Class
- Variables:
    - `_selectedCategories` (private, List<String>)
    - `_selectedDifficulties` (private, List<String>)
    - `_categories` (private, final, List<String>)
    - `_difficulties` (private, final, List<String>)
- Methods:
    - `initState` (public, void, no parameters)
    - `build` (public, Widget, parameter: context (BuildContext))

## ReactionPage Class
- Variables:
    - `currentPoints` (public, final, int)
    - `currentName` (public, final, String)
- Methods:
    - `createState` (public, State<ReactionPage>, no parameters)

## _ReactionPageState Class
- Variables:
    - `elapsedReaction` (private, int)
    - `stopWatchReaction` (private, Stopwatch)
    - `timer` (private, Timer?)
    - `detector` (private, late, ShakeDetector)
    - `_points` (private, int)
    - `_name` (private, String)
- Methods:
    - `calculatePoints` (private, void, no parameters)
    - `initState` (public, void, no parameters)
    - `build` (public, Widget, parameter: context (BuildContext))
    - `dispose` (public, void, no parameters)