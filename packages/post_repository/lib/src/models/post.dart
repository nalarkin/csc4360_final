import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

enum PostFlair { sports, question, concern, announcement, general }

class Post extends Equatable {
  const Post({
    this.id = '',
    this.authorId = '',
    this.authorName = '',
    this.title = '',
    this.content = '',
    this.voteCount = 0,
    this.commentCount = 0,
    this.upVoters = const [],
    this.downVoters = const [],
    required this.timestamp,
    this.flair = PostFlair.general,
  });

  final String id;
  final String authorId;
  final String authorName;
  final int voteCount;
  final int commentCount;
  final List<String> upVoters;
  final List<String> downVoters;
  final String title;
  final String content;
  final DateTime timestamp;
  final PostFlair flair;

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    int? voteCount,
    int? commentCount,
    List<String>? upVoters,
    List<String>? downVoters,
    String? title,
    String? content,
    DateTime? timestamp,
    PostFlair? flair,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      voteCount: voteCount ?? this.voteCount,
      commentCount: commentCount ?? this.commentCount,
      upVoters: upVoters ?? this.upVoters,
      downVoters: downVoters ?? this.downVoters,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      flair: flair ?? this.flair,
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      authorId: authorId,
      authorName: authorName,
      voteCount: voteCount,
      commentCount: commentCount,
      downVoters: downVoters,
      upVoters: upVoters,
      title: title,
      content: content,
      timestamp: timestamp,
      flair: postFlairToString(this.flair) ?? 'general',
    );
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      id: entity.id,
      authorId: entity.authorId,
      authorName: entity.authorName,
      voteCount: entity.voteCount,
      commentCount: entity.commentCount,
      upVoters: List.from(entity.upVoters),
      downVoters: List.from(entity.downVoters),
      title: entity.title,
      content: entity.content,
      timestamp: entity.timestamp,
      flair: stringToPostFlair(entity.flair) ?? PostFlair.general,
    );
  }

  @override
  String toString() {
    return 'Post {id: $id, authorId: $authorId, authorName: $authorName, voteCount: '
        '$voteCount,  commentCount: $commentCount title: $title, flair: $flair '
        ' content: $content, upVoters: $upVoters, downVoters: $downVoters }';
  }

  @override
  List<Object> get props => [
        id,
        flair,
        authorName,
        voteCount,
        commentCount,
        upVoters,
        downVoters,
        timestamp,
        title,
        authorId,
        content,
        flair
      ];

  bool get isEmpty => this == Post.empty;
  bool get isNotEmpty => this != Post.empty;

  static final empty = Post(
    timestamp: DateTime.fromMicrosecondsSinceEpoch(1626835721000),
  );

  static PostFlair? stringToPostFlair(String possibleFlair) {
    for (final role in PostFlair.values) {
      if (role.toString() == "PostFlair.$possibleFlair") {
        return role;
      }
    }
    return null;
  }
  static PostFlair? longStringToPostFlair(String possibleFlair) {
    for (final role in PostFlair.values) {
      if (role.toString() == "$possibleFlair") {
        return role;
      }
    }
    return null;
  }

  static String? postFlairToString(PostFlair? flair) {
    if (flair == null) return null;
    return flair.toString().split('.').last;
  }
}
