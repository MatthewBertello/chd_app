import 'package:flutter/material.dart';

class QuestionForumModel extends ChangeNotifier {
  final List<Question> questionsList = []; // the list of questions to be displayed

  void addQuestion(String newQuestion){ // adds a question to the list
    questionsList.add(Question(newQuestion));
    notifyListeners();
  }

  void addReply(int index, String newReply){ // adds a reply to the question at a given index
    questionsList[index].addReply(newReply);
    notifyListeners();
  }

}

// class to form the backbone of the questions
class Question {
  String question = ""; // the question
  List<String> replies = []; // the list of replies

  Question(String newQuestion){ // constructor for question
    question = newQuestion;
    replies = [];
  }

  void addReply(String newReply) { // adds a reply to the replies list
    replies.add(newReply);
  }

  void editQuestion(newQuestion){ // edits a question, might need later
    question = newQuestion;
  }

  String getQuestion() { // retrieves the question
    return question;
  }

  List<String> getReplies() { // gets the whole list of replies
    return replies;
  }

}