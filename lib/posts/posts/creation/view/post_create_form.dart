import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:key_repository/key_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/navigation/navigation.dart';
import 'package:formz/formz.dart';
import 'package:school_notifier/posts/posts/posts.dart';

class PostCreateForm extends StatelessWidget {
  const PostCreateForm({Key? key}) : super(key: key);
  static const String routeName = '/post_creation';

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreationCubit, CreationState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Post Submission Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              const SizedBox(height: 8.0),
              _PostTitleInput(),
              const SizedBox(height: 8.0),
              _PostContentInput(),
              const SizedBox(height: 8.0),
              _PostFlairDescription(),
              const SizedBox(height: 8.0),
              _PostFlairRadio(),
              const SizedBox(height: 8.0),
              _PostCreateButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginInfomationText extends StatelessWidget {
  const _LoginInfomationText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text("Create a post", style: theme.textTheme.headline6);
  }
}

class _PostTitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreationCubit, CreationState, PostTitle>(
      selector: (state) {
        return state.postTitle;
      },
      builder: (context, state) {
        return TextField(
          key: const Key('postCreation_titleInput_textField'),
          onChanged: (title) =>
              context.read<CreationCubit>().postTitleChanged(title),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'title',
            helperText: '',
            errorText: state.invalid ? 'invalid title' : null,
          ),
        );
      },
    );
  }
}

class _PostContentInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreationCubit, CreationState, PostContent>(
      selector: (state) {
        return state.postContent;
      },
      builder: (context, state) {
        return TextField(
          key: const Key('postCreation_contentInput_textField'),
          onChanged: (content) =>
              context.read<CreationCubit>().postContentChanged(content),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            labelText: 'content',
            helperText: '',
            errorText: state.invalid ? 'invalid content' : null,
          ),
        );
      },
    );
  }
}

class _PostFlairDescription extends StatelessWidget {
  const _PostFlairDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('select a post flair from below',
              style: theme.textTheme.bodyText2)
        ],
      ),
    );
  }
}

class _PostFlairRadio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreationCubit, CreationState, PostFlairType>(
      selector: (state) {
        return state.postFlairType;
      },
      builder: (context, flair) {
        PostFlair? _flair = Post.longStringToPostFlair(flair.value);
        return Container(
          child: Column(
            children: <Widget>[
              RadioListTile<PostFlair>(
                title: const Text('General'),
                value: PostFlair.general,
                groupValue: _flair,
                onChanged: (PostFlair? value) {
                  context
                      .read<CreationCubit>()
                      .postFlairTypeChanged(value.toString());
                },
              ),
              RadioListTile<PostFlair>(
                title: const Text('Question'),
                value: PostFlair.question,
                groupValue: _flair,
                onChanged: (PostFlair? value) {
                  context
                      .read<CreationCubit>()
                      .postFlairTypeChanged(value.toString());
                },
              ),
              RadioListTile<PostFlair>(
                title: const Text('Concern'),
                value: PostFlair.concern,
                groupValue: _flair,
                onChanged: (PostFlair? value) {
                  context
                      .read<CreationCubit>()
                      .postFlairTypeChanged(value.toString());
                },
              ),
              RadioListTile<PostFlair>(
                title: const Text('Announcement'),
                value: PostFlair.announcement,
                groupValue: _flair,
                onChanged: (PostFlair? value) {
                  context
                      .read<CreationCubit>()
                      .postFlairTypeChanged(value.toString());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PostCreateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<CreationCubit, CreationState, FormzStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, status) {
        return status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: const Color(0xFFFFD600),
                ),
                onPressed: status.isValidated
                    ? () => context.read<CreationCubit>().postSubmitted()
                    : null,
                child: Text('CREATE POST', style: theme.textTheme.button),
              );
      },
    );
  }
}
