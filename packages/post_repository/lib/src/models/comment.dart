import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

class Comment extends Equatable {
  const Comment({
    this.id = '',
    this.authorId = '',
    this.authorName = '',
    this.content = '',
    this.voteCount = 0,
    this.commentCount = 0,
    this.upVoters = const [],
    this.downVoters = const [],
    required this.timestamp,
    this.relatedPost = '',
  });

  final String id;
  final String authorId;
  final String authorName;
  final int voteCount;
  final List<String> upVoters;
  final List<String> downVoters;
  final int commentCount;
  final String content;
  final DateTime timestamp;
  final String relatedPost;

  Comment copyWith({
    String? id,
    String? authorId,
    String? authorName,
    int? voteCount,
    int? commentCount,
    List<String>? upVoters,
    List<String>? downVoters,
    String? content,
    DateTime? timestamp,
    String? relatedPost,
  }) {
    return Comment(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      voteCount: voteCount ?? this.voteCount,
      commentCount: commentCount ?? this.commentCount,
      upVoters: upVoters ?? this.upVoters,
      downVoters: downVoters ?? this.downVoters,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      relatedPost: relatedPost ?? this.relatedPost,
    );
  }

  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      authorId: authorId,
      authorName: authorName,
      voteCount: voteCount,
      commentCount: commentCount,
      upVoters: upVoters,
      downVoters: downVoters,
      content: content,
      timestamp: timestamp,
      relatedPost: relatedPost,
    );
  }

  static Comment fromEntity(CommentEntity entity) {
    return Comment(
      id: entity.id,
      authorId: entity.authorId,
      authorName: entity.authorName,
      voteCount: entity.voteCount,
      commentCount: entity.commentCount,
      upVoters:
          entity.upVoters.length > 0 ? List<String>.from(entity.upVoters) : [],
      downVoters: entity.downVoters.length > 0
          ? List<String>.from(entity.downVoters)
          : [],
      content: entity.content,
      timestamp: entity.timestamp,
      relatedPost: entity.relatedPost,
    );
  }

  @override
  String toString() {
    return 'Comment {id: $id, authorId: $authorId, authorName: $authorName, voteCount: '
        '$voteCount,  commentCount: $commentCount content: $content, relatedPost: $relatedPost'
        ' upVoters: $upVoters, downVoters: $downVoters }';
  }

  @override
  List<Object> get props => [
        id,
        relatedPost,
        authorName,
        voteCount,
        commentCount,
        timestamp,
        content,
        upVoters,
        downVoters,
        authorId
      ];

  bool get isEmpty => this == Comment.empty;
  bool get isNotEmpty => this != Comment.empty;

  static final empty = Comment(
    timestamp: DateTime.fromMicrosecondsSinceEpoch(1626835721000),
  );
}
