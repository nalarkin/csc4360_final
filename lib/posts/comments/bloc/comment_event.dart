part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class CommentStarted extends CommentEvent {}

class CommentSentText extends CommentEvent {
  const CommentSentText(this.comment) : super();
  final Comment comment;

  @override
  List<Object> get props => [comment];
}
// class CommentStartFirstConversation extends CommentEvent {
//   const CommentStartFirstConversation(this.content) : super ();
//  final String content;

//   @override
//   List<Object> get props => [content];
// }
class CommentLoaded extends CommentEvent {
  const CommentLoaded({required this.comments, this.post}) : super();
  final List<Comment> comments;
  final Post? post;
  @override
  List<Object> get props => [comments];
}

class CommentUpvote extends CommentEvent {
  const CommentUpvote(this.post, this.uid, this.voteStatus);
  final Comment post;
  final String uid;
  final VotingStatus voteStatus;

  @override
  List<Object> get props => [post];
}

class CommentDownvote extends CommentEvent {
  const CommentDownvote(this.post, this.uid, this.voteStatus);
  final Comment post;
  final String uid;
  final VotingStatus voteStatus;

  @override
  List<Object> get props => [post];
}

class CommentUpdateHeader extends CommentEvent {
  const CommentUpdateHeader(this.post);
  final Post post;

  @override
  List<Object> get props => [post];
}
