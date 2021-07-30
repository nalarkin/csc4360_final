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
import 'package:school_notifier/profile/profile.dart';
import 'package:school_notifier/subscriptions/subscriptions.dart';
import 'package:school_notifier/subscriptions/view/add_subscription_page.dart';
import 'package:school_notifier/widgets/drawer.dart';
import 'package:users_repository/users_repository.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({Key? key}) : super(key: key);
  static const String routeName = '/post_create';
  static Page page() => const MaterialPage<void>(child: PostCreatePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    FirestoreUser currUser = context.watch<ProfileBloc>().state.user;
    return Scaffold(
      drawer: customDrawer(context),
      appBar: AppBar(
        title: const Text('Create Post'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              key: const Key('homePage_logout_iconButton'),
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
      body: BlocProvider(
        create: (context) => PostBloc(context.read<PostRepository>()),
        child: Container(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(child: PostForm())),
      ),
    );
  }
}

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  // PostFlair flair = PostFlair.general;
  PostFlair? _flair = PostFlair.general;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('flair is $_flair');
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _TitleForm(controller: _titleController),
          const SizedBox(
            height: 20,
          ),
          _ContentForm(controller: _contentController),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: <Widget>[
              RadioListTile<PostFlair>(
                title: const Text('General'),
                value: PostFlair.general,
                groupValue: _flair,
                onChanged: (PostFlair? value) {
                  setState(() {
                    _flair = value;
                  });
                },
              ),
              RadioListTile<PostFlair>(
                title: const Text('Question'),
                value: PostFlair.question,
                groupValue: _flair,
                onChanged: (PostFlair? value) {
                  setState(() {
                    _flair = value;
                  });
                },
              ),
              RadioListTile<PostFlair>(
                title: const Text('Concern'),
                value: PostFlair.concern,
                groupValue: _flair,
                onChanged: (PostFlair? value) {
                  setState(() {
                    _flair = value;
                  });
                },
              ),
              RadioListTile<PostFlair>(
                title: const Text('Announcement'),
                value: PostFlair.announcement,
                groupValue: _flair,
                onChanged: (PostFlair? value) {
                  setState(() {
                    _flair = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          TextButton(
              onPressed: () {
                if (_contentController.text.trim().isEmpty ||
                    _titleController.text.trim().isEmpty) return null;
                FirestoreUser _currUser =
                    context.read<ProfileBloc>().state.user;
                Post newPost = Post(
                  authorId: _currUser.id,
                  authorName: '${_currUser.firstName} ${_currUser.lastName}',
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                  flair: _flair ?? PostFlair.general,
                  timestamp: DateTime.now(),
                );
                // print('created new post $newPost');

                context.read<PostBloc>().add(PostCreated(newPost));
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
              },
              child: Text('Submit Post'))
        ],
      ),
    );
  }
}

class _TitleForm extends StatefulWidget {
  const _TitleForm({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  __TitleFormState createState() => __TitleFormState();
}

class __TitleFormState extends State<_TitleForm> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
          labelText: 'post title',
          helperText: '',
          errorText: widget.controller.text.isEmpty ? 'title is empty' : null),
    );
  }
}

class _ContentForm extends StatefulWidget {
  const _ContentForm({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  __ContentFormState createState() => __ContentFormState();
}

class __ContentFormState extends State<_ContentForm> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (_) {
        setState(() {});
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'post content',
          helperText: '',
          errorText:
              widget.controller.text.isEmpty ? 'content is empty' : null),
    );
  }
}

// class _SubmitPostButton extends StatelessWidget {
//   const _SubmitPostButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         print(widget.)
//       },
//     child: Text('Print Post'));
//   }
// }


