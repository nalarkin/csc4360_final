part of 'comment_bloc.dart';

enum CommentStatus { initial, success, failure, first }

class CommentState extends Equatable {
  const CommentState._(
      {required this.status,
      this.comments = const <Comment>[],
      required this.post});

  final CommentStatus status;
  final List<Comment> comments;
  final Post post;

  const CommentState.initial(post)
      : this._(status: CommentStatus.initial, post: post);
  const CommentState.success(comments, post)
      : this._(status: CommentStatus.success, comments: comments, post: post);
  const CommentState.failure(post)
      : this._(status: CommentStatus.failure, post: post);
  const CommentState.first(post)
      : this._(status: CommentStatus.first, post: post);

  CommentState copyWith(
      {CommentStatus? status, List<Comment>? comments, Post? post}) {
    return CommentState._(
        status: status ?? this.status,
        comments: comments ?? this.comments,
        post: post ?? this.post);
  }

  @override
  List<Object> get props => [status, comments, post];
}
