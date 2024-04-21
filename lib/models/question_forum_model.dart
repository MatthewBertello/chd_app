import 'package:flutter/material.dart';
import 'package:chd_app/main.dart';

class QuestionForumModel extends ChangeNotifier {
  final List<Question> questionsList = []; // the list of questions to be displayed

  // loads the list of questions from the database
  void loadQuestionList() async { 
    questionsList.clear();
    try{
      var response = await supabase.from('forum_questions').select('*');
      for (int i = 0; i < response.length; i++) {
        questionsList.add(Question(response[i]['question'], response [i]['question_id']));
      }
      notifyListeners();
    }
    catch (e){
      print(e);
    }
  }
  
  // adds a question to the list
  void addQuestion(String newQuestion) async { 
    try{
      await supabase 
        .from('forum_questions')
        .insert([{ 
          'question': newQuestion,
          'user_id': supabase.auth.currentUser!.id, 
          },
        ]);
        loadQuestionList();
    }
    catch (e){
      print(e);
    }
  }

  // deletes a question from the list if the user id matches
  void deleteQuestion(int questionIndex) async { 
    try {  
      var response = await supabase.from('forum_questions').select('question').eq('question_id', questionsList[questionIndex].getQuestionID()).eq('user_id', supabase.auth.currentUser!.id);
      if (response.isNotEmpty) {
        await supabase.from('forum_questions').delete().eq('question_id', questionsList[questionIndex].getQuestionID());
        loadQuestionList();
      }
    }
    catch(e){
      print(e);
    }
  }

  // adds a reply to the question at a given index
  void addReply(int questionIndex, String newReply) async { 
    try{
      await supabase 
        .from('forum_replies')
        .insert([{ 
          'reply': newReply,
          'user_id': supabase.auth.currentUser!.id,
          'question_id' : questionsList[questionIndex].getQuestionID() 
          },
        ]);
        loadReplyList(questionIndex);
    }
    catch (e){
      print(e);
    }
  }

  // loads the replies to a question from the database
  void loadReplyList(int questionIndex) async { 
    questionsList[questionIndex].clearReplies();
    try{
      var response = await supabase.from('forum_replies').select('*').eq('question_id', questionsList[questionIndex].getQuestionID());
      for (int i = 0; i < response.length; i++) {
        questionsList[questionIndex].addReply(Reply(response[i]['reply'], response [i]['reply_id']));
      }
      notifyListeners();
    }
    catch (e){
      print(e);
    }
  } 

  // deletes a reply from the database
  void deleteReply(int questionIndex, int replyIndex) async {
    try{  
      var response = await supabase.from('forum_replies').select('reply_id').eq('reply_id', questionsList[questionIndex].replies[replyIndex].getReplyID()).eq("user_id", supabase.auth.currentUser!.id);
      if (response.isNotEmpty) {
        await supabase.from('forum_replies').delete().eq('reply_id', questionsList[questionIndex].replies[replyIndex].getReplyID());
        loadReplyList(questionIndex);
      }
    }
    catch(e){
      print(e);
    }
  } 

} // end of the model

// class to form the backbone of the questions
class Question {
  String question = ""; // the question
  List<Reply> replies = []; // the list of replies
  String questionID = "NULL";

  Question(String newQuestion, String newID){ // constructor for question
    question = newQuestion;
    questionID = newID;
    replies = [];
  }

  void addReply(Reply newReply) { // adds a reply to the replies list
    replies.add(newReply);
  }

  void editQuestion(newQuestion){ // edits a question, might need later
    question = newQuestion;
  }

  String getQuestion() { // retrieves the question
    return question;
  }

  List<Reply> getReplies() { // gets the whole list of replies
    return replies;
  }

  String getQuestionID() { // retrieve questionID
    return questionID;
  }

  void setQuestionID(String newID) { // set the questionID
    questionID = newID;
  }

  void clearReplies() { // clears the all the replies from a question in app
    replies.clear();
  }

} // end of Question class

// a class for replies to a question
class Reply{
  String reply = "";
  String replyID = "NULL";

  Reply(String newReply, String newID){ // constructor for reply
    reply = newReply;
    replyID = newID;
  }

  void setReplyID(String newID){ // sets the id for a reply
    replyID = newID;
  }

  String getReplyID() { // returns a reply's id
    return replyID;
  }

  void setReply(String newReply) { // sets the reply
    reply = newReply;
  }

  String getReply(){ // retrieve the reply
    return reply;
  }

  void editReply(String editedReply){ // edit reply might be needed later
    reply = editedReply;
  }

} // end of Reply class