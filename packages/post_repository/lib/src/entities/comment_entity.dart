import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

class CommentEntity extends Equatable {
  const CommentEntity(
      {required this.id,
      required this.authorId,
      required this.authorName,
      required this.content,
      required this.voteCount,
      required this.commentCount,
      required this.upVoters,
      required this.downVoters,
      required this.timestamp,
      required this.relatedPost,
      });

  final String id;
  final String authorId;
  final String authorName;
  final int voteCount;
  final int commentCount;
  final List<dynamic> upVoters;
  final List<dynamic> downVoters;
  final String content;
  final DateTime timestamp;
  final String relatedPost;

  CommentEntity copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? content,
    int? voteCount,
    int? commentCount,
    List<dynamic>? downVoters,
    List<dynamic>? upVoters,
    DateTime? timestamp,
    String? relatedPost,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      voteCount: voteCount ?? this.voteCount,
      commentCount: commentCount ?? this.commentCount,
      downVoters: downVoters ?? this.downVoters,
      upVoters: upVoters ?? this.upVoters,
      timestamp: timestamp ?? this.timestamp,
      relatedPost: relatedPost ?? this.relatedPost,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'voteCount': voteCount,
      'commentCount': commentCount,
      'downVoters': downVoters,
      'upVoters': upVoters,
      'timestamp': timestamp,
      'relatedPost': relatedPost,
    };
  }

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'voteCount': voteCount,
      'commentCount': commentCount,
      'downVoters': downVoters,
      'upVoters': upVoters,
      'timestamp': timestamp,
      'relatedPost': relatedPost,
    };
  }

  static CommentEntity fromJson(Map<String, Object?> json) {
    return CommentEntity(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      voteCount: json['voteCount'] as int,
      commentCount: json['commentCount'] as int,
      upVoters: json['upVoters'] as List<dynamic>,
      downVoters: json['downVoters'] as List<dynamic>,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      relatedPost: json['relatedPost'] as String,

    );
  }

  static CommentEntity fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>?;
    if (data == null) throw Exception();
    return CommentEntity(
      id: snap.id,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      content: data['content'] as String,
      voteCount: data['voteCount'] as int,
      commentCount: data['commentCount'] as int,
            upVoters: data['upVoters'] as List<dynamic>,
      downVoters: data['downVoters'] as List<dynamic>,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      relatedPost: data['relatedPost'] as String,
    );
  }

  @override
  String toString() {
    return 'CommentEntity { convoId: $authorId, id: $id, authorName: ' 
    '$authorName, content: $content, voteCount: $voteCount commentCount: $commentCount, timestamp: '
    '$timestamp, relatedPost: $relatedPost, upVoters: $upVoters, downVoters: $downVoters } ';
  }

  @override
  List<Object> get props => [id, authorName, content, voteCount, commentCount, timestamp, relatedPost, downVoters, upVoters];
}
