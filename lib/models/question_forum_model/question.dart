import 'reply.dart';

// class to form the backbone of the questions
class Question {
  String question = ""; // the question
  List<Reply> replies = []; // the list of replies
  String questionID = "NULL"; // uuid for each question
  String userWhoPosted = ""; // user_id of the person who posted the question
  int numLikes = 0;

  // constructor for question
  Question(String newQuestion, String newID, String newUser){ 
    question = newQuestion;
    questionID = newID;
    userWhoPosted = newUser;
    replies = [];
  }

  // adds a reply to the replies list
  void addReply(Reply newReply) { 
    replies.add(newReply);
  }

  // edits a question, might need later
  void editQuestion(newQuestion){ 
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
  void setUserWhoPosted(String newUser){ 
    userWhoPosted = newUser;
  }

  // clears the all the replies from a question in app
  void clearReplies() { 
    replies.clear();
  }

  // sets number of likes for each question
  void setNumLikes(int newNumLikes){ 
    numLikes = newNumLikes;
  }

} // end of Question class