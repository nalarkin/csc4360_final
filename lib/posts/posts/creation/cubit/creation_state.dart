part of 'creation_cubit.dart';

class CreationState extends Equatable {
  const CreationState({
    this.postTitle = const PostTitle.pure(),
    this.postContent = const PostContent.pure(),
    this.postFlairType = const PostFlairType.pure(),
    this.status = FormzStatus.pure,
  });

  final PostTitle postTitle;
  final PostContent postContent;
  final PostFlairType postFlairType;
  final FormzStatus status;

  @override
  List<Object> get props => [
        postTitle,
        postContent,
        status,
        postFlairType,
      ];

  CreationState copyWith({
    PostTitle? postTitle,
    PostContent? postContent,
    FormzStatus? status,
    PostFlairType? postFlairType,

  }) {
    return CreationState(
      postTitle: postTitle ?? this.postTitle,
      postContent: postContent ?? this.postContent,
      status: status ?? this.status,
      postFlairType: postFlairType ?? this.postFlairType,

    );
  }
}
