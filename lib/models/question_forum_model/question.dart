// ignore_for_file: prefer_typing_uninitialized_variables
// for the date, since I was unable to figure out what type the database returned for the datetime

import 'package:heart_safe/main.dart';
import 'package:heart_safe/models/supabase_model.dart';

import 'reply.dart';

/*
Name: Matthew Steffens
Date: 5/13/2024
Description: This is the class that makes up a question. It holds all the data of a question for the forum
Bugs: None I currently know of
Reflection: This was fairly easy to implement, and it seems to work fine
*/

// class to form the backbone of the questions
class Question {
  String question = ""; // the question
  List<Reply> replies = []; // the list of replies
  String questionID = "NULL"; // uuid for each question
  String userWhoPosted = ""; // user_id of the person who posted the question
  int numLikes = 0; // number of likes on a question
  String author = "NULL"; // who wrote the question
  var date; // date it was posted

  // constructor for question
  Question(String newQuestion, String newID, String newUser,
      var newDate /*String newAuthor*/) {
    question = newQuestion;
    questionID = newID;
    userWhoPosted = newUser;
    date = newDate;
    replies = [];
  }

  // adds a reply to the replies list
  void addReply(Reply newReply) {
    replies.add(newReply);
  }

  // edits a question, might need later
  void editQuestion(newQuestion) {
    question = newQuestion;
  }

  // retrieves the question
  String getQuestion() {
    return question;
  }

  // gets the whole list of replies
  List<Reply> getReplies() {
    return replies;
  }

  // retrieve questionID
  String getQuestionID() {
    return questionID;
  }

  // set the questionID
  void setQuestionID(String newID) {
    questionID = newID;
  }

  // get the user's id
  String getUserWhoPosted() {
    return userWhoPosted;
  }

  // set the user's id
  void setUserWhoPosted(String newUser) {
    userWhoPosted = newUser;
  }

  // clears the all the replies from a question in app
  void clearReplies() {
    replies.clear();
  }

  // sets number of likes for each question
  void setNumLikes(int newNumLikes) {
    numLikes = newNumLikes;
  }

  // retrieve who wrote the question
  Future<String> getAuthor() async {
    var userInfo = await supabaseModel.supabase!
        .from('user_info')
        .select()
        .eq('user_id', userWhoPosted);

    var username = userInfo[0]['user_name'];
    return username;
  }

  // sets the author of the question
  void setAuthor(String newAuthor) {
    author = newAuthor;
  }

  // // returns the date when it was posted
  // DateTime getDate() {
  //   return date;
  // }
} // end of Question class