class TaskDetails {
  final String? taskId;
  final String? title;
  final double? order;
  final int? numberOfQuestion;
  TaskDetails({
    required this.taskId,
    required this.title,
    required this.order,
    this.numberOfQuestion,
  });

  factory TaskDetails.fromJson(Map<String, dynamic> json) {
    return TaskDetails(
      taskId: json['id'] ?? '',
      title: json['title'] ?? '',
      order: (json['order'] as num?)?.toDouble() ?? 0.0,
      numberOfQuestion: (json['numQuestions'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'title': title,
      'lesson_order': order,
    };
  }
}

class Question {
  final String questionId;
  final String content;
  final List<String> choices;
  final String correctAnswer;
  String ?imageUrl;

  Question({
    required this.questionId,
    required this.content,
    required this.choices,
    required this.correctAnswer,
    this.imageUrl,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'] ?? '',
      content: json['content'] ?? '',
      choices: List<String>.from(json['choices'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'content': content,
      'choices': choices,
      'correctAnswer': correctAnswer,
      'imageUrl': imageUrl,
    };
  }
}