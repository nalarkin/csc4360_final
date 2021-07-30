part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  const PostState._({required this.status, this.posts = const <Post>[]});
  final List<Post> posts;
  final PostStatus status;

  const PostState.initial() : this._(status: PostStatus.initial);
  const PostState.success(posts) : this._(status: PostStatus.success, posts: posts);
  const PostState.failure() : this._(status: PostStatus.failure);

  @override
  List<Object> get props => [status, posts];
}
