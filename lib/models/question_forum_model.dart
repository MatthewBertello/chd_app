import 'package:flutter/material.dart';
import 'package:chd_app/main.dart';

class QuestionForumModel extends ChangeNotifier {
  final List<Question> questionsList = []; // the list of questions to be displayed
  final List<String> likedQuestionsList = [];// list of current users liked questions
  bool loaded = false; // shows if the list is loaded or not

  // loads the list of questions from the database
  void loadQuestionList() async { 
    loaded = false;
    questionsList.clear();
    try{
      // get the question list from database
      var response = await supabaseModel.supabase! 
        .from('forum_questions')
        .select('*');
      for (int i = 0; i < response.length; i++) {
        questionsList.add(Question(response[i]['question'], response [i]['question_id'], response[i]['user_id']));
      }
      // pulls the number of likes from the database for each question
      for (int i = 0; i < questionsList.length; i++){
        var likesResponse = await supabaseModel.supabase!
          .from('forum_question_likes')
          .select()
          .eq('question_id', questionsList[i].questionID)
          .count();
        questionsList[i].numLikes = likesResponse.count;
      }
      // if user has account then retrieve questions they have liked
      if (supabaseModel.supabase!.auth.currentUser?.id != null) { 
        response = await supabaseModel.supabase!
          .from('forum_question_likes')
          .select('question_id')
          .eq('user_id' , supabaseModel.supabase!.auth.currentUser!.id);

        for (int i = 0; i < response.length; i++){
          likedQuestionsList.add(response[i]['question_id']);
        }
      }
      
      loaded = true;
      notifyListeners();
    }
    catch (e){
      print(e);
    }
  }

  // likes the question and adds to database
  void likeQuestion(int questionIndex) async {
    try{
      await supabaseModel.supabase! 
        .from('forum_question_likes')
        .insert([{ 
          'question_id': questionsList[questionIndex].questionID,
          'user_id': supabaseModel.supabase!.auth.currentUser!.id, 
          },
        ]);
    }
    catch (e){
      print(e);
    }
  }

  // gets rid of the like in the database
  void unlikeQuestion(int questionIndex) async {
    try{
      await supabaseModel.supabase! 
        .from('forum_question_likes')
        .delete()
        .eq('question_id', questionsList[questionIndex].questionID)
        .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id);
      
      likedQuestionsList.removeWhere((element) => element == questionsList[questionIndex].questionID);
    }
    catch (e){
      print(e);
    }
  }
  
  // adds a question to the list
  void addQuestion(String newQuestion) async { 
    try{
      await supabaseModel.supabase! 
        .from('forum_questions')
        .insert([{ 
          'question': newQuestion,
          'user_id': supabaseModel.supabase!.auth.currentUser!.id, 
          },
        ]);
        //loadQuestionList();
    }
    catch (e){
      print(e);
    }
  }

  // deletes a question from the list if the user id matches
  void deleteQuestion(int questionIndex) async { 
    try {  
      var response = await supabaseModel.supabase!
      .from('forum_questions')
      .select('question')
      .eq('question_id', questionsList[questionIndex].getQuestionID())
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id);
      if (response.isNotEmpty) {
        await supabaseModel.supabase!
          .from('forum_questions')
          .delete()
          .eq('question_id', questionsList[questionIndex].getQuestionID());
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
      await supabaseModel.supabase! 
        .from('forum_replies')
        .insert([{ 
          'reply': newReply,
          'user_id': supabaseModel.supabase!.auth.currentUser!.id,
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
    loaded = false;
    questionsList[questionIndex].clearReplies();
    try{
      var response = await supabaseModel.supabase!
        .from('forum_replies')
        .select('*')
        .eq('question_id', questionsList[questionIndex].getQuestionID())
        .order('datetime', ascending: true);
      for (int i = 0; i < response.length; i++) {
        questionsList[questionIndex].addReply(Reply(response[i]['reply'], response [i]['reply_id'], response[i]['user_id']));
      }
      loaded = true;
      notifyListeners();
    }
    catch (e){
      print(e);
    }
  } 

  // deletes a reply from the database
  void deleteReply(int questionIndex, int replyIndex) async {
    try{  
      var response = await supabaseModel.supabase!
        .from('forum_replies')
        .select('reply_id')
        .eq('reply_id', questionsList[questionIndex].replies[replyIndex].getReplyID())
        .eq("user_id", supabaseModel.supabase!.auth.currentUser!.id);
      if (response.isNotEmpty) {
        await supabaseModel.supabase!
          .from('forum_replies')
          .delete().eq('reply_id', questionsList[questionIndex].replies[replyIndex].getReplyID());
        loadReplyList(questionIndex);
      }
    }
    catch(e){
      print(e);
    }
  } 

  void editReply(int questionIndex, int replyIndex, String newReply) async {
    try {
      await supabaseModel.supabase!
        .from('forum_replies')
        .update({ 'reply': newReply })
        .eq('reply_id', questionsList[questionIndex].replies[replyIndex].getReplyID());
      questionsList[questionIndex].replies[replyIndex].setReply(newReply);
      notifyListeners();
      loadReplyList(questionIndex);
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
  String questionID = "NULL"; // uuid for each question
  String userWhoPosted = ""; // user_id of the person who posted the question
  int numLikes = 0;

  Question(String newQuestion, String newID, String newUser){ // constructor for question
    question = newQuestion;
    questionID = newID;
    userWhoPosted = newUser;
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

  String getUserWhoPosted() { // get the user's id
    return userWhoPosted;
  }

  void setUserWhoPosted(String newUser){ // set the user's id
    userWhoPosted = newUser;
  }

  void clearReplies() { // clears the all the replies from a question in app
    replies.clear();
  }

  void setNumLikes(int newNumLikes){ // sets number of likes for each question
    numLikes = newNumLikes;
  }

} // end of Question class

// a class for replies to a question
class Reply{
  String reply = "";
  String replyID = "NULL";
  String userWhoPosted = "";

  Reply(String newReply, String newID, String newUser){ // constructor for reply
    reply = newReply;
    replyID = newID;
    userWhoPosted = newUser;
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

  void setUserWhoPosted(String newUser){ // sets the id of the user
    userWhoPosted = newUser;
  }

  String getUserWhoPosted() { // returns the id of the person who posted it
    return userWhoPosted;
  }

  void editReply(String editedReply){ // edit reply might be needed later
    reply = editedReply;
  }

} // end of Reply class