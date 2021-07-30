import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/posts/posts.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc(this._postRepository) : super(PostState.initial()) {
    _postStream =
        _postRepository.streamAllPosts().listen(_mapPostStreamToEvent);
  }

  final PostRepository _postRepository;
  late StreamSubscription _postStream;

  void _mapPostStreamToEvent(List<Post> posts) {
    add(PostLoaded(posts));
  }

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is PostLoaded) {
      yield _mapPostLoadedToState(event);
    } else if (event is PostCreated) {
      _addCreatedPostToDatabase(event);
    } else if (event is PostUpvote) {
      _mapPostUpvote(event);
    } else if (event is PostDownvote) {
      _mapPostDownvote(event);
    } else {
      yield PostState.failure();
    }
  }

  PostState _mapPostLoadedToState(PostLoaded event) {
    return PostState.success(event.posts);
  }

  void _mapPostDownvote(PostDownvote event) async {
    if (event.voteStatus == VotingStatus.upVoted) {
      await _postRepository.downvotePost(event.post, event.uid, -2);
    } else if (event.voteStatus == VotingStatus.neutral) {
      await _postRepository.downvotePost(event.post, event.uid, -1);
    } else if (event.voteStatus == VotingStatus.downVoted) {
      await _postRepository.removeVoteOnPost(event.post, event.uid, 1);
    }
  }

  void _mapPostUpvote(PostUpvote event) async {
    if (event.voteStatus == VotingStatus.downVoted) {
      await _postRepository.upvotePost(event.post, event.uid, 2);
    } else if (event.voteStatus == VotingStatus.neutral) {
      await _postRepository.upvotePost(event.post, event.uid, 1);
    } else if (event.voteStatus == VotingStatus.upVoted) {
      await _postRepository.removeVoteOnPost(event.post, event.uid, -1);
    }
    // await _postRepository.upvotePost(event.post, event.uid);
  }

  Future<void> _addCreatedPostToDatabase(PostCreated event) async {
    await _postRepository.addNewPost(event.post);
  }

  @override
  Future<void> close() {
    _postStream.cancel();
    return super.close();
  }
}
