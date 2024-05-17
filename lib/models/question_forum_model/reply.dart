// ignore_for_file: prefer_typing_uninitialized_variables

/*
Name: Matthew Steffens
Date: 5/13/2024
Description: This is the class that makes up a reply. It holds all the information of the reply
Bugs: None I currently know of
Reflection: This was fairly easy to implement, and it seems to work fine
*/

// a class for replies to a question
class Reply{
  String reply = ""; // the reply the user posted
  String replyID = "NULL"; // the uuid of the reply
  String userWhoPosted = ""; // the id of the user who posted
  String author = "NULL"; // the username of the user who posted
  int numLikes = 0; // number of likes
  var date; // date when posted

  // constructor for reply
  Reply(String newReply, String newID, String newUser, var newDate){ 
    reply = newReply;
    replyID = newID;
    userWhoPosted = newUser;
    date = newDate;
  }

  // sets the id for a reply
  void setReplyID(String newID){ 
    replyID = newID;
  }

  // returns a reply's id
  String getReplyID() { 
    return replyID;
  }

  // sets the reply
  void setReply(String newReply) { 
    reply = newReply;
  }

  // retrieve the reply
  String getReply(){ 
    return reply;
  }

  // sets the id of the user
  void setUserWhoPosted(String newUser){ 
    userWhoPosted = newUser;
  }

  // returns the id of the person who posted it
  String getUserWhoPosted() { 
    return userWhoPosted;
  }

  // edit reply might be needed later
  void editReply(String editedReply){ 
    reply = editedReply;
  }

  // retrieves the author of the reply
  String getAuthor() {
    return author;
  }

  // sets the author of the reply
  void setAuthor(String newAuthor){
    author = newAuthor;
  }

} // end of Reply class