class Question {
  final String category;
  final String id;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String questionText;

  Question({
    required this.category,
    required this.id,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.questionText,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      category: json['category'] as String,
      id: json['id'] as String,
      correctAnswer: json['correctAnswer'] as String,
      incorrectAnswers: (json['incorrectAnswers'] as List<dynamic>)
          .cast<String>(),
      questionText: json['question']['text'] as String,
    );
  }
}