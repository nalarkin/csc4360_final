import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

class PostEntity extends Equatable {
  const PostEntity(
      {required this.id,
      required this.authorId,
      required this.authorName,
      required this.title,
      required this.content,
      required this.voteCount,
      required this.commentCount,
      required this.upVoters,
      required this.downVoters,
      required this.timestamp,
      required this.flair,
      });

  final String id;
  final String authorId;
  final String authorName;
  final int voteCount;
  final int commentCount;
  final List<dynamic> upVoters;
  final List<dynamic> downVoters;
  final String title;
  final String content;
  final DateTime timestamp;
  final String flair;

  PostEntity copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? title,
    String? content,
    int? voteCount,
    int? commentCount,  
     List<dynamic>? upVoters,
   List<dynamic>? downVoters,
    DateTime? timestamp,
    String? flair,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      content: content ?? this.content,
      voteCount: voteCount ?? this.voteCount,
      commentCount: commentCount ?? this.commentCount,
      upVoters: upVoters ?? this.upVoters,
      downVoters: downVoters ?? this.downVoters,
      timestamp: timestamp ?? this.timestamp,
      flair: flair ?? this.flair,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'title': title,
      'voteCount': voteCount,
      'commentCount': commentCount,
      'downVoters': downVoters,
      'upVoters': upVoters,
      'content': content,
      'timestamp': timestamp,
      'flair': flair,
    };
  }

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'title': title,
      'voteCount': voteCount,
      'commentCount': commentCount,
      'downVoters': downVoters,
      'upVoters': upVoters,
      'content': content,
      'timestamp': timestamp,
      'flair': flair,
    };
  }

  static PostEntity fromJson(Map<String, Object?> json) {
    return PostEntity(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      voteCount: json['voteCount'] as int,
      commentCount: json['commentCount'] as int,
      downVoters: json['downVoters'] as List<dynamic>,
      upVoters: json['upVoters'] as List<dynamic>,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      flair: json['flair'] as String,

    );
  }

  static PostEntity fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>?;
    if (data == null) throw Exception();
    return PostEntity(
      id: snap.id,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      title: data['title'] as String,
      content: data['content'] as String,
      voteCount: data['voteCount'] as int,
      commentCount: data['commentCount'] as int,
      downVoters: data['downVoters'] as List<dynamic>,
      upVoters: data['upVoters'] as List<dynamic>,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      flair: data['flair'] as String,
    );
  }

  @override
  String toString() {
    return 'PostEntity { convoId: $authorId, id: $id, authorName: ' 
    '$authorName, title: $title, voteCount: $voteCount commentCount: $commentCount, timestamp: '
    '$timestamp, flair: $flair, content: $content, upVoters: $upVoters, downVoters: $downVoters} ';
  }

  @override
  List<Object> get props => [id, authorName, title, voteCount, commentCount, timestamp, flair, content, downVoters, upVoters];
}
