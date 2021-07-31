import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_repository/message_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/messages/message.dart';
import 'package:school_notifier/posts/posts.dart';
import 'package:school_notifier/profile/profile.dart';
import 'package:school_notifier/widgets/loading_indicator.dart';
import 'package:school_notifier/messages/message.dart';

class PostBuilder extends StatelessWidget {
  const PostBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state.status == PostStatus.initial) {
          return LoadingIndicator();
        } else if (state.status == PostStatus.success && state.posts.isEmpty) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: Center(child: const Text('there are no posts')),
          );
        } else if (state.status == PostStatus.success) {
          final _posts = state.posts;
          // print("conversations $_posts");
          // print("length of conversations = ${_posts.length}");
          final _viewerUid =
              context.read<AuthenticationRepository>().currentUser.id;
          return ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return _PostTile(post: _posts[index]);
            },
          );
        }
        return Container();
      },
    );
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
    final _bloc = context.watch<PostBloc>();
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider.value(
                value: _bloc, child: CommentPage(post: post));
          }));
        },
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyText2
                                  ?.copyWith(color: Colors.black),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text('${post.commentCount}'),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.chat_bubble_outline,
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
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
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
                          '  ${formatDateString(post.timestamp, DateTime.now())}',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyText1
                              ?.copyWith(color: theme.hintColor),
                        )
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
