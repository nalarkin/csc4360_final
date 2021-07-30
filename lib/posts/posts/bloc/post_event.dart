part of 'post_bloc.dart';


abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class PostUpvote extends PostEvent {
  const PostUpvote(this.post, this.uid, this.voteStatus);
  final Post post;
  final String uid;
  final VotingStatus voteStatus;

  @override
  List<Object> get props => [post];
}

class PostDownvote extends PostEvent {
  const PostDownvote(this.post, this.uid, this.voteStatus);
  final Post post;
  final String uid;
  final VotingStatus voteStatus;

  @override
  List<Object> get props => [post];
}

class PostLoaded extends PostEvent {
  const PostLoaded(this.posts);
  final List<Post> posts;
  // final String uid;

  @override
  List<Object> get props => [posts];
}

class PostCreated extends PostEvent {
  const PostCreated(this.post);
  final Post post;
  // final String uid;

  @override
  List<Object> get props => [post];
}
