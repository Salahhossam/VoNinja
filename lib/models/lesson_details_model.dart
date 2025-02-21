class LessonDetails {
  final String lessonId;
  final String title;
  final int order;
  final String levelId;

   List<Vocabulary> ?vocabularies;
   List<Question> ?questions;

  LessonDetails({
    required this.lessonId,
    required this.title,
    required this.order,
    required this.levelId,
    this.vocabularies,
    this.questions,
  });

  factory LessonDetails.fromJson(Map<String, dynamic> json) {
    return LessonDetails(
      lessonId: json['id'] ?? '',
      title: json['title'] ?? '',
      order: json['order'] ?? 0,
      levelId: json['levelId'] ?? '',
      vocabularies: (json['vocabularies'] as List?)
              ?.map((vocab) => Vocabulary.fromJson(vocab))
              .toList() ??
          [],
      questions: (json['questions'] as List?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'title': title,
      'order': order,
      'levelId': levelId,
      'vocabularies': vocabularies?.map((v) => v.toJson()).toList(),
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
  }
}

class Vocabulary {
  final String vocabId;
  final String word;
  final String translation;
  final String statement;
  final String statementTranslation;
  String ?imageUrl;

  Vocabulary({
    required this.vocabId,
    required this.word,
    required this.translation,
    required this.statement,
    required this.statementTranslation,
    this.imageUrl,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      vocabId: json['id'] ?? '',
      word: json['word'] ?? '',
      translation: json['translated_word'] ?? '',
      statement: json['statement_example'] ?? '',
      statementTranslation: json['translated_statement_example'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vocabId': vocabId,
      'word': word,
      'translation': translation,
      'statement': statement,
      'statementTranslation': statementTranslation,
      'imageUrl': imageUrl,
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
      questionId: json['id'] ?? '',
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
