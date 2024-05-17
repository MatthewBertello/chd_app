import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/screens/question_forum_screen/edit_reply_screen.dart';
import 'package:flutter/material.dart';
import 'package:heart_safe/models/question_forum_model/question_forum_model.dart';
import 'package:heart_safe/main.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/*
Name: Matthew Steffens
Date: 5/13/2024
Description: This page shows all of the questions in the forum. From there you can sort, add new questions, or see your own questions
Bugs: None I currently know of
Reflection: This was fairly easy to implement, since I did it after figuring out how to make the question list view screen,
however it took a bunch of time to do.
*/

class QuestionReplies extends StatefulWidget {
  const QuestionReplies(
      {super.key,
      required this.questionForumModel,
      required this.questionIndex});

  final QuestionForumModel questionForumModel; // model
  final int questionIndex; // index of the question in the list

  @override
  State<QuestionReplies> createState() => QuestionRepliesState();
}

class QuestionRepliesState extends State<QuestionReplies> {
  TextEditingController replyController =
      TextEditingController(); // controller for the reply text box
  bool isLiked = false; // whether a comment is liked by you or not
  bool isNull =
      true; // so it doesn't show which choice there is by the sort button
  String? author;

  List<String> sortChoices = [
    'Newest',
    'Oldest',
    'Most Popular',
    'Least Popular'
  ]; // choices for sorting
  String selectedSortChoice = 'Newest'; // the default choice

  void sortBy(String? choice) {
    // sorts the questions based off some choices in the dropdown
    switch (choice) {
      case 'Newest':
        {
          setState(() {
            widget.questionForumModel.sortRepliesByNewest(widget.questionIndex);
          });
        }
        break;
      case 'Oldest':
        {
          setState(() {
            widget.questionForumModel.sortRepliesByOldest(widget.questionIndex);
          });
        }
        break;
      case 'Most Popular':
        {
          setState(() {
            widget.questionForumModel
                .sortRepliesByMostPopular(widget.questionIndex);
          });
        }
        break;
      case 'Least Popular':
        {
          setState(() {
            widget.questionForumModel
                .sortRepliesByLeastPopular(widget.questionIndex);
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
            context: context,
            title: const Text("Replies"),
            actions: [
              DropdownButton(
                iconDisabledColor:
                    Theme.of(context).colorScheme.primaryContainer,
                iconEnabledColor:
                    Theme.of(context).colorScheme.primaryContainer,
                value: (isNull) ? null : selectedSortChoice,
                underline: Container(),
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                icon: const Icon(Icons.sort_rounded),
                items: sortChoices.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    sortBy(newValue);
                  });
                },
              )
            ]),
        body: (widget.questionForumModel.loaded)
            ? replyListView()
            : loadingAnimationWidget(context));
  }

  // the list view of replies
  Padding replyListView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              widget.questionForumModel.questionsList[widget.questionIndex]
                  .getQuestion(),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          const Divider(height: 15.0, thickness: 2.0, color: Colors.black),
          Expanded(
              child: ListView.separated(
                  // builder shows all the replies of the question
                  itemCount: widget.questionForumModel
                      .questionsList[widget.questionIndex].replies.length,
                  itemBuilder: (context, index) {
                    return (supabaseModel.supabase!.auth.currentUser?.id ==
                            widget
                                .questionForumModel
                                .questionsList[widget.questionIndex]
                                .replies[index]
                                .getUserWhoPosted())
                        ? currentUserReply(widget.questionIndex, index)
                        : notCurrUserReply(widget.questionIndex, index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                        color: Colors.transparent, height: 5.0);
                  })),
          newReplyRow() // where the user can post a new reply
        ],
      ),
    );
  }

  // loading animation while the replies load
  Stack loadingAnimationWidget(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(color: Colors.black.withOpacity(0.3), dismissible: false),
        Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).colorScheme.primary, size: 50))
      ],
    );
  }

  // the user who posted the question is currently logged in
  ListTile currentUserReply(int questionIndex, int replyIndex) {
    var futureAuthor = widget.questionForumModel
        .questionsList[questionIndex]
        .replies[replyIndex]
        .getAuthor();
    futureAuthor.then((value) {
      if (author != value) {
        setState(() {
          author = value;
        });
      }
    });
    isLiked = widget.questionForumModel.likedRepliesList.contains(widget
        .questionForumModel
        .questionsList[questionIndex]
        .replies[replyIndex]
        .replyID);
    return ListTile(
      title: Text(widget.questionForumModel.questionsList[widget.questionIndex]
          .replies[replyIndex]
          .getReply()),
      subtitle: (author ==
              'NULL')
          ? Text(
              "Anonymous ● ${widget.questionForumModel.questionsList[questionIndex].replies[replyIndex].date.toString().substring(0, 10)}")
          : Text(
              "${author} ● ${widget.questionForumModel.questionsList[questionIndex].replies[replyIndex].date.toString().substring(0, 10)}"), // prints the author just hardcoded for now
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        likeButton(questionIndex, replyIndex),
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditReply(
                        questionForumModel: widget.questionForumModel,
                        reply: widget.questionForumModel
                            .questionsList[questionIndex].replies[replyIndex]
                            .getReply(),
                        questionIndex: questionIndex,
                        replyIndex: replyIndex,
                      )));
            },
            icon: const Icon(Icons.edit)),
        IconButton(
            onPressed: () {
              _deleteReplyVerification(questionIndex, replyIndex);
            },
            icon: const Icon(Icons.delete))
      ]),
    );
  }

  // the user who posted the question is not currently logged in
  ListTile notCurrUserReply(int questionIndex, int replyIndex) {
    isLiked = widget.questionForumModel.likedRepliesList.contains(widget
        .questionForumModel
        .questionsList[questionIndex]
        .replies[replyIndex]
        .replyID);
    return ListTile(
        title: Text(widget.questionForumModel
            .questionsList[widget.questionIndex].replies[replyIndex]
            .getReply()),
        subtitle: (author ==
                null)
            ? Text(
                "Anonymous ● ${widget.questionForumModel.questionsList[questionIndex].replies[replyIndex].date.toString().substring(0, 10)}")
            : Text(
                "${author} ● ${widget.questionForumModel.questionsList[questionIndex].replies[replyIndex].date.toString().substring(0, 10)}"), // prints the author just hardcoded for now
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        trailing: likeButton(questionIndex, replyIndex));
  }

  // where the user can type a reply
  Row newReplyRow() {
    return Row(
        // where the user can make a reply
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: (supabaseModel.supabase!.auth.currentUser?.id != null)
                  ? hasAccountReplyTextField()
                  : noAccountReplyTextField()),
          const SizedBox(width: 8.0),
          ElevatedButton.icon(
              onPressed: () {
                (supabaseModel.supabase!.auth.currentUser?.id != null)
                    ? _addReply()
                    : _showNoAccountWarning();
              },
              icon: const Icon(Icons.add),
              label: const Text("Reply"),
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))))
        ]);
  }

  // allows user to type in the textfield if they have an account
  TextField hasAccountReplyTextField() {
    return TextField(
        controller: replyController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        inputFormatters: [LengthLimitingTextInputFormatter(250)],
        decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(10),
            hintText: "(Reply)"));
  }

  // disallows user from user textfield with no account, and shows the warning
  GestureDetector noAccountReplyTextField() {
    return GestureDetector(
      onTap: _showNoAccountWarning,
      child: const TextField(
          enabled: false,
          decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              hintText: "(Reply)")),
    );
  }

  SizedBox likeButton(int questionIndex, int replyIndex) {
    return SizedBox(
      width: 50.0,
      child: LikeButton(
          animationDuration: const Duration(milliseconds: 0),
          circleColor: const CircleColor(
              start: Colors.transparent, end: Colors.transparent),
          bubblesColor: const BubblesColor(
              dotPrimaryColor: Colors.transparent,
              dotSecondaryColor: Colors.transparent,
              dotThirdColor: Colors.transparent,
              dotLastColor: Colors.transparent),
          bubblesSize: 0,
          likeCount: widget.questionForumModel.questionsList[questionIndex]
              .replies[replyIndex].numLikes,
          isLiked: isLiked,
          onTap: (bool isLiked) {
            if (supabaseModel.supabase!.auth.currentUser?.id == null) {
              _showNoAccountWarning();
              return Future.value(isLiked);
            } else {
              this.isLiked = !isLiked;
              (isLiked)
                  ? widget.questionForumModel
                      .unlikeReply(questionIndex, replyIndex)
                  : widget.questionForumModel
                      .likeReply(questionIndex, replyIndex);
            }
            return Future.value(!isLiked);
          }),
    );
  }

  // adds a reply to the question
  void _addReply() {
    // adds a reply to the question
    if (replyController.text != "") {
      widget.questionForumModel
          .addReply(widget.questionIndex, replyController.text);
      replyController.text = "";
    }
  }

  // alerts the user that an account is necesarry to post a reply
  Future<void> _showNoAccountWarning() async {
    replyController.text = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text("You must have an account to post a reply."),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  // gives the user a chance to verify they want to delete their reply
  Future<void> _deleteReplyVerification(
      int questionIndex, int replyIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text("Are you sure you want to delete your reply?"),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                widget.questionForumModel
                    .deleteReply(questionIndex, replyIndex);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
