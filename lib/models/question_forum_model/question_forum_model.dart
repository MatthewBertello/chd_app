// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:heart_safe/main.dart';
import 'question.dart';
import 'reply.dart';

/*
Name: Matthew Steffens
Date: 5/13/2024
Description: This is the model for the questions and replies. It pulls from the database and also inserts into the database.
Every method in here does one thing or another with questions and replies.
Bugs: None I currently know of
Reflection: This model has been quite the project, but it is cool seeing it all work together
*/

class QuestionForumModel extends ChangeNotifier {
  final List<Question> questionsList = []; // the list of questions to be displayed
  final List<Question> myQuestionsList = []; // list of questions you posted
  final List<String> likedQuestionsList = [];// list of current users liked questions
  final List<String> likedRepliesList = []; // list of current users liked replies
  bool loaded = false; // shows if the list is loaded or not

  // loads the list of questions from the database
  void loadQuestionList() async { 
    loaded = false;
    questionsList.clear();
    try{
      // get the question list from database
      var response = await supabaseModel.supabase! 
        .from('forum_questions')
        .select('*')
        .order('datetime', ascending: false);
      for (int i = 0; i < response.length; i++) {
        questionsList.add(Question(response[i]['question'], response [i]['question_id'], response[i]['user_id'],response[i]['datetime'],/* response[i]['user_name']*/));
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

  // loads the list newest to oldest
  void sortQuestionByNewest() {
    loaded = false;
    questionsList.sort((b, a) => a.date.compareTo(b.date));
    loaded = true;
    notifyListeners();
  }
  
  // loads the list in oldest to newest
  void sortQuestionsByOldest() {
    loaded = false;
    questionsList.sort((a, b) => a.date.compareTo(b.date));
    loaded = true;
    notifyListeners();
  }

  // loads list by most popular
  void sortQuestionsByMostPopular(){
    loaded = false;
    questionsList.sort((b, a) => a.numLikes.compareTo(b.numLikes));
    loaded = true;
    notifyListeners();
  }

  // loads list by least popular
  void sortQuestionsByLeastPopular(){
    loaded = false;
    questionsList.sort((a, b) => a.numLikes.compareTo(b.numLikes));
    loaded = true;
    notifyListeners();
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
        notifyListeners();
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

  // loads all of the current user's question's into list
  void getMyQuestions() async {
    try {  
      loaded = false;
      myQuestionsList.clear();
      var response = await supabaseModel.supabase!
      .from('forum_questions')
      .select('*')
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id);

      for (int i = 0; i < response.length; i++){
        myQuestionsList.add(Question(response[i]['question'], response [i]['question_id'], response[i]['user_id'],response[i]['datetime']));
      }

      // load number of likes for each question
      for (int i = 0; i < myQuestionsList.length; i++){
        var likesResponse = await supabaseModel.supabase!
          .from('forum_question_likes')
          .select()
          .eq('question_id', myQuestionsList[i].questionID)
          .count();
        myQuestionsList[i].numLikes = likesResponse.count;
      }    

      loaded = true;
      notifyListeners();  
    }
    catch(e){
      print(e);
    }
  }

  // adds a like to a reply
  void likeReply(int questionIndex, int replyIndex) async {
    try{
      await supabaseModel.supabase! 
        .from('forum_reply_likes')
        .insert([{ 
          'reply_id': questionsList[questionIndex].replies[replyIndex].replyID,
          'user_id': supabaseModel.supabase!.auth.currentUser!.id, 
          },
        ]);
    }
    catch (e){
      print(e);
    }
  }

  // unlikes a reply
  void unlikeReply(int questionIndex, int replyIndex) async {
    try{
      await supabaseModel.supabase! 
        .from('forum_reply_likes')
        .delete()
        .eq('reply_id', questionsList[questionIndex].replies[replyIndex].replyID)
        .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id);
      
      likedRepliesList.removeWhere((element) => element == questionsList[questionIndex].replies[replyIndex].replyID);
    }
    catch (e){
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
    //loadQuestionList();
    try{
      var response = await supabaseModel.supabase!
        .from('forum_replies')
        .select('*')
        .eq('question_id', questionsList[questionIndex].getQuestionID())
        .order('datetime', ascending: true);
      for (int i = 0; i < response.length; i++) {
        questionsList[questionIndex].addReply(Reply(response[i]['reply'], response [i]['reply_id'], response[i]['user_id'], response[i]['datetime']));
      }

      // pulls the number of likes from the database for each question
      for (int i = 0; i < questionsList[questionIndex].replies.length; i++){
        var likesResponse = await supabaseModel.supabase!
          .from('forum_reply_likes')
          .select()
          .eq('reply_id', questionsList[questionIndex].replies[i].replyID)
          .count();
        questionsList[questionIndex].replies[i].numLikes = likesResponse.count;
      }
      // if user has account then retrieve questions they have liked
      if (supabaseModel.supabase!.auth.currentUser?.id != null) { 
        response = await supabaseModel.supabase!
          .from('forum_reply_likes')
          .select('reply_id')
          .eq('user_id' , supabaseModel.supabase!.auth.currentUser!.id);

        for (int i = 0; i < response.length; i++){
          likedRepliesList.add(response[i]['reply_id']);
        }
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

  // edits a user's reply
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

   // loads the list newest to oldest
  void sortRepliesByNewest(int questionIndex) {
    loaded = false;
    questionsList[questionIndex].replies.sort((b, a) => a.date.compareTo(b.date));
    loaded = true;
    notifyListeners();
  }
  
  // loads the list in oldest to newest
  void sortRepliesByOldest(int questionIndex) {
    loaded = false;
    questionsList[questionIndex].replies.sort((a, b) => a.date.compareTo(b.date));
    loaded = true;
    notifyListeners();
  }

  // loads list by most popular
  void sortRepliesByMostPopular(int questionIndex){
    loaded = false;
    questionsList[questionIndex].replies.sort((b, a) => a.numLikes.compareTo(b.numLikes));
    loaded = true;
    notifyListeners();
  }

  // loads list by least popular
  void sortRepliesByLeastPopular(int questionIndex){
    loaded = false;
    questionsList[questionIndex].replies.sort((a, b) => a.numLikes.compareTo(b.numLikes));
    loaded = true;
    notifyListeners();
  }

  // clears the lists after a logout
  void reset() {
    likedQuestionsList.clear();
    likedRepliesList.clear();
  }

} // end of the model