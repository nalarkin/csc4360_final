import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/app/app.dart';
import 'package:school_notifier/calendar/view/calendar_page.dart';
import 'package:school_notifier/event_repository_test/event_page.dart';
import 'package:school_notifier/home/home.dart';
import 'package:school_notifier/authentication/authentication.dart';
import 'package:school_notifier/key_stuff/key_page.dart';
import 'package:school_notifier/login/login.dart';
import 'package:school_notifier/messages/conversations/view/conversation_debug.dart';
import 'package:school_notifier/messages/message.dart';
import 'package:school_notifier/navigation/navigation.dart';
import 'package:school_notifier/posts/posts.dart';
import 'package:school_notifier/posts/posts/view/post_builder.dart';
import 'package:school_notifier/profile/profile.dart';
import 'package:school_notifier/subscriptions/subscriptions.dart';
import 'package:school_notifier/subscriptions/view/add_subscription_page.dart';
import 'package:school_notifier/widgets/drawer.dart';
import 'package:users_repository/users_repository.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);
  static const String routeName = '/posts';
  static Page page() => const MaterialPage<void>(child: PostPage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    FirestoreUser currUser = context.watch<ProfileBloc>().state.user;
    return Scaffold(
      drawer: customDrawer(context),
      appBar: AppBar(
        title: const Text(' Post'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              tooltip: 'create new post',
              key: const Key('postPage_createPost_iconButton'),
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, PostCreatePage.routeName);
              })
        ],
      ),
      body: BlocProvider(
        create: (context) => PostBloc(context.read<PostRepository>()),
        child: Container(
            // padding: EdgeInsets.all(8),
            child: PostBuilder()),
      ),
    );
  }
}
