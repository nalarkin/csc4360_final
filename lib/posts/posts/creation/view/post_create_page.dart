import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/login/login.dart';
import 'package:school_notifier/posts/posts.dart';
import 'package:school_notifier/posts/posts/creation/view/post_create_form.dart';
import 'package:school_notifier/profile/profile.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({Key? key}) : super(key: key);

  static const routeName = '/post_create_page';
  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => CreationCubit(
            context.read<PostRepository>(),
            context.read<ProfileBloc>().state.user,
            context.read<PostBloc>(),
          ),
          child: const PostCreateForm(),
        ),
      ),
    );
  }
}
