import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/posts/posts.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc(this._postRepository, this.post, this._viewerUid)
      : super(CommentState.initial(post)) {
    _commentSubscription = _postRepository
        .streamAllComments(post.id)
        .listen(_mapCommentStreamToState);
    _postSubscription =
        _postRepository.streamSinglePost(post.id).listen(_mapPostStreamToState);
  }

  final PostRepository _postRepository;
  final Post post;
  late StreamSubscription _commentSubscription;
  late StreamSubscription _postSubscription;
  final String _viewerUid;

  void _mapCommentStreamToState(List<Comment> comments) {
    add(CommentLoaded(comments: comments, post: state.post));
  }

  void _mapPostStreamToState(Post post) {
    // add(CommentLoaded(comments: state.comments, post: post));
    add(CommentUpdateHeader(post));
  }

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    if (event is CommentLoaded) {
      yield _mapCommentLoadedToState(event);
    } else if (event is CommentSentText) {
      _mapCommentSent(event);
    } else if (event is CommentUpvote) {
      _mapCommentUpvote(event);
    } else if (event is CommentDownvote) {
      _mapCommentDownvote(event);
    } else if (event is CommentUpdateHeader) {
      yield _mapCommentUpdateHeaderToState(event);
    }
    // else if (event is CommentStartFirstConversation) {
    // unawaited(_mapFirstComment(event));
    // }
  }

  CommentState _mapCommentUpdateHeaderToState(CommentUpdateHeader event) {
    return state.copyWith(post: event.post);

    // if (event.comments.length > 0) {
    //   return CommentState.success(event.comments, state.post);
    // } else {
    //   return CommentState.first(state.post);
    // }
    // return _mapCommentLoadedToState(state.copyWith(post: event.post));
  }

  CommentState _mapCommentLoadedToState(CommentLoaded event) {
    print('new wave of comments loaded');
    print(event.toString());
    if (event.comments.length > 0) {
      return CommentState.success(event.comments, state.post);
    } else {
      return CommentState.first(state.post);
    }
  }

  void _mapCommentDownvote(CommentDownvote event) async {
    if (event.voteStatus == VotingStatus.upVoted) {
      await _postRepository.downvoteComment(event.post, event.uid, -2);
    } else if (event.voteStatus == VotingStatus.neutral) {
      await _postRepository.downvoteComment(event.post, event.uid, -1);
    } else if (event.voteStatus == VotingStatus.downVoted) {
      await _postRepository.removeVoteOnComment(event.post, event.uid, 1);
    }
  }

  void _mapCommentUpvote(CommentUpvote event) async {
    if (event.voteStatus == VotingStatus.downVoted) {
      await _postRepository.upvoteComment(event.post, event.uid, 2);
    } else if (event.voteStatus == VotingStatus.neutral) {
      await _postRepository.upvoteComment(event.post, event.uid, 1);
    } else if (event.voteStatus == VotingStatus.upVoted) {
      await _postRepository.removeVoteOnComment(event.post, event.uid, -1);
    }
    // await _postRepository.upvotePost(event.post, event.uid);
  }

  Future<void> _mapCommentSent(CommentSentText event) async {
    // final content = event.content.trim();

    // final Comment _newComment = Comment(
    //   authorId: _viewerUid,

    //   content: content,
    //   timestamp: DateTime.now(),
    // );
    await _postRepository.addNewComment(event.comment);
  }

  // Future<void> _mapFirstComment(CommentStartFirstConversation event) async {
  //   final content = event.content.trim();
  //   final Comment _newComment = Comment(
  //     idFrom: _viewerUid,
  //     idTo: _otherParticipant,
  //     commentId: _comment.id,
  //     content: content,
  //     timestamp: DateTime.now(),
  //   );

  //   final newConversation = _comment.copyWith(lastComment: _newComment);
  //   await _postRepository.startNewConversation(newConversation);
  // }

  @override
  Future<void> close() {
    _commentSubscription.cancel();
    _postSubscription.cancel();
    return super.close();
  }
}
