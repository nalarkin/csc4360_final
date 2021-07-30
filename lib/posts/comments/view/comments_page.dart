import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/app/app.dart';
import 'package:school_notifier/home/home.dart';
import 'package:school_notifier/authentication/authentication.dart';
import 'package:school_notifier/login/login.dart';
import 'package:school_notifier/posts/comments/view/comments_builder.dart';
import 'package:school_notifier/posts/posts.dart';
import 'package:school_notifier/navigation/navigation.dart';
import 'package:school_notifier/profile/profile.dart';
import 'package:users_repository/users_repository.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({Key? key, required this.post}) : super(key: key);
  static const String routeName = '/comments';
  // static Page page() => const MaterialPage<void>(child: CommentPage());
  final Post post;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final post = ModalRoute.of(context)!.settings.arguments as Post;
    // print('MESSAGE PAGE SCREEN: $post');
    return Scaffold(
        appBar: AppBar(
          title: Text('${post.title}'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                key: const Key('post_logout_iconButton'),
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (Route<dynamic> route) => false);
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested());
                })
          ],
        ),
        body: Container(
          // padding: EdgeInsets.all(8),
          child: BlocProvider(
            create: (_) => CommentBloc(
              context.read<PostRepository>(),
              post,
              context.read<AuthenticationRepository>().currentUser.id,
            ),
            child: CommentBuilder(),
          ),
        ));
  }
}
