// a class for replies to a question
class Reply{
  String reply = ""; // the reply the user posted
  String replyID = "NULL"; // the uuid of the reply
  String userWhoPosted = ""; // the id of the user who posted
  String author = "NULL"; // the username of the user who posted
  int numLikes = 0; // number of likes

  // constructor for reply
  Reply(String newReply, String newID, String newUser){ 
    reply = newReply;
    replyID = newID;
    userWhoPosted = newUser;
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