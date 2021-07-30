import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:post_repository/post_repository.dart';
import 'package:school_notifier/posts/posts.dart';
import 'package:users_repository/users_repository.dart';

part 'creation_state.dart';

class CreationCubit extends Cubit<CreationState> {
  CreationCubit(
    this._postRepository,
    this._user,
    this._postBloc,
  ) : super(const CreationState());

  final PostRepository _postRepository;
  final PostBloc _postBloc;
  final FirestoreUser _user;

  void postTitleChanged(String value) {
    final postTitle = PostTitle.dirty(value);
    emit(state.copyWith(
      postTitle: postTitle,
      status: Formz.validate([
        postTitle,
        state.postContent,
        state.postFlairType,
      ]),
    ));
  }

  void postContentChanged(String value) {
    final postContent = PostContent.dirty(value);
    emit(state.copyWith(
      postContent: postContent,
      status: Formz.validate([
        state.postTitle,
        postContent,
        state.postFlairType,
      ]),
    ));
  }

  void postFlairTypeChanged(String value) {
    final postFlairType = PostFlairType.dirty(value);
    emit(state.copyWith(
      postFlairType: postFlairType,
      status: Formz.validate([
        state.postTitle,
        state.postContent,
        postFlairType,
      ]),
    ));
  }

  void postSubmitted() {
    Post newPost = Post(
      authorId: _user.id,
      authorName: '${_user.firstName} ${_user.lastName}',
      title: state.postTitle.value.trim(),
      content: state.postContent.value.trim(),
      flair: Post.longStringToPostFlair(state.postFlairType.value) ??
          PostFlair.general,
      timestamp: DateTime.now(),
    );
    // print('created new post $newPost');

    _postBloc.add(PostCreated(newPost));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
