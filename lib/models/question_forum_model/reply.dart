// a class for replies to a question
class Reply{
  String reply = "";
  String replyID = "NULL";
  String userWhoPosted = "";

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

} // end of Reply class