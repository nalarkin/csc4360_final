import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_notifier/messages/message.dart';
import 'package:school_notifier/profile/profile.dart';
import 'package:school_notifier/widgets/loading_indicator.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/posts/posts.dart';
import 'package:users_repository/users_repository.dart';

class CommentBuilder extends StatelessWidget {
  const CommentBuilder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String _uid = context.watch<AuthenticationRepository>().currentUser.id;
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state.status == CommentStatus.initial) {
          return LoadingIndicator();
        } else if (state.status == CommentStatus.success ||
            state.status == CommentStatus.first) {
          // final _comments = state.comments;
          // final String _postTitle =
          //     context.read<CommentBloc>().state.post.title;
          // final Post _post = context.read<CommentBloc>().state.post;

          return Stack(
            children: [
              if (state.status == CommentStatus.first) _EmptyCommentsMessage(),
              CustomScrollView(slivers: [
                _PostList(),
                if (state.status == CommentStatus.success) _CommentList(),
                _SpaceBufforForKeyboard()
              ]),
              _BuildNewCommentInputContainer(),
            ],
          );
        }
        // else if (state.status == CommentStatus.first) {
        //   return Container(
        //     child: Stack(children: [
        //       Container(
        //         alignment: Alignment.center,
        //         child: Text('be the first to add a comment'),
        //       ),
        //       _BuildNewCommentInputContainer(),
        //     ]),
        //   );
        // }
        return Container();
      },
    );
  }
}

class _EmptyCommentsMessage extends StatelessWidget {
  const _EmptyCommentsMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      child: Text(
        'no comments',
        style: theme.textTheme.caption,
      ),
    );
  }
}

class _CommentList extends StatelessWidget {
  const _CommentList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _comments = context.watch<CommentBloc>().state.comments;
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return _CommentTile(comment: _comments[index]);
      },
      childCount: _comments.length,
    ));
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({Key? key, required this.comment}) : super(key: key);
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String uid = context.watch<ProfileBloc>().state.user.id;
    final votingStatus = getVotingStatusFromComment(comment, uid);
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 0.5))),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color: Colors.grey.shade300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 39.0,
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text('${comment.voteCount}'),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_up,
                            color: votingStatus == VotingStatus.upVoted
                                ? Colors.red
                                : Colors.black,
                          ),
                          onPressed: () {
                            context
                                .read<CommentBloc>()
                                .add(CommentUpvote(comment, uid, votingStatus));
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: votingStatus == VotingStatus.downVoted
                                ? Colors.blue
                                : Colors.black,
                          ),
                          onPressed: () {
                            context.read<CommentBloc>().add(
                                CommentDownvote(comment, uid, votingStatus));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          comment.content,
                          softWrap: true,
                          style: theme.textTheme.bodyText1
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            comment.authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyText1
                                ?.copyWith(color: theme.hintColor),
                          ),
                          Text(
                            '  ${formatDateEventTime(comment.timestamp)}',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyText1?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Column _buildCommentTile(context, Comment comment, String _uid) {
  final theme = Theme.of(context);
  return Column(
    crossAxisAlignment: comment.authorId == _uid
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start,
    children: [
      GestureDetector(
          onTap: () {},
          child: Container(
            child: Text(comment.content),
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          formatDateString(comment.timestamp, DateTime.now()),
          style: theme.textTheme.subtitle1
              ?.copyWith(color: Colors.grey, fontSize: 10),
        ),
      ),
    ],
  );
}

class _BuildNewCommentInputContainer extends StatelessWidget {
  _BuildNewCommentInputContainer({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // constraints: BoxConstraints.expand(height: 100),

      // alignment: Alignment.bottomCenter,
      // color: theme.backgroundColor,
      // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        children: [
          Expanded(child: Container()),
          Container(
            color: theme.canvasColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    color: theme.canvasColor,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: TextField(
                      controller: _controller,
                    ),
                  ),
                ),
                Container(
                    // color: theme.backgroundColor,
                    child: IconButton(
                        onPressed: () {
                          if (_controller.text.trim().isEmpty) return null;
                          FirestoreUser _currUser =
                              context.read<ProfileBloc>().state.user;
                          Comment _comment = Comment(
                            relatedPost:
                                context.read<CommentBloc>().state.post.id,
                            authorId: _currUser.id,
                            authorName:
                                '${_currUser.firstName} ${_currUser.lastName}',
                            content: _controller.text.trim(),
                            timestamp: DateTime.now(),
                          );
                          context
                              .read<CommentBloc>()
                              .add(CommentSentText(_comment));

                          _controller.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30,
                          color: theme.accentColor,
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Post> posts = [context.watch<CommentBloc>().state.post];
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return _PostTile(post: posts[index]);
      },
      childCount: posts.length,
    ));
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String uid = context.watch<ProfileBloc>().state.user.id;
    final votingStatus = getVotingStatusFromPost(post, uid);
    return Container(
      decoration: BoxDecoration(boxShadow: kElevationToShadow[6]),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color: Colors.grey.shade300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 39,
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text('${post.voteCount}'),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_up,
                            color: votingStatus == VotingStatus.upVoted
                                ? Colors.red
                                : Colors.black,
                          ),
                          onPressed: () {
                            context
                                .read<PostBloc>()
                                .add(PostUpvote(post, uid, votingStatus));
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: votingStatus == VotingStatus.downVoted
                                ? Colors.blue
                                : Colors.black,
                          ),
                          onPressed: () {
                            context
                                .read<PostBloc>()
                                .add(PostDownvote(post, uid, votingStatus));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              post.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyText2
                                  ?.copyWith(color: Colors.black),
                            ),
                          ),
                          // Expanded(
                          //   child: Container(),
                          // ),
                          Container(
                            child: Row(
                              children: [
                                Text('${post.commentCount}'),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.chat_outlined,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          post.content,
                          softWrap: true,
                          style: theme.textTheme.bodyText1
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(children: [
                        Text(
                          'flair: ${Post.postFlairToString(post.flair)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyText1
                              ?.copyWith(color: theme.hintColor),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          post.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyText1
                              ?.copyWith(color: theme.hintColor),
                        ),
                        Text(
                          '  ${formatDateEventTime(post.timestamp)}',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyText1?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpaceBufforForKeyboard extends StatelessWidget {
  const _SpaceBufforForKeyboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
          height: 100,
        );
      },
      childCount: 1,
    ));
  }
}

// class _EmptyCommentsMessage extends StatelessWidget {
//   const _EmptyCommentsMessage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//         delegate: SliverChildBuilderDelegate(
//       (BuildContext context, int index) {
//         return Container(
//           height: 100,
//         );
//       },
//       childCount: 1,
//     ));
//   }
// }
