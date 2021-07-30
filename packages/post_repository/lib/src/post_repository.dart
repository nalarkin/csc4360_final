import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:post_repository/post_repository.dart';

class PostRepository {
  final _postCollection = FirebaseFirestore.instance
      .collection('exampleSchool')
      .doc('posts')
      .collection('posts');
  final _commentCollection = FirebaseFirestore.instance
      .collection('exampleSchool')
      .doc('posts')
      .collection('comments');

  Future<void> addNewPost(Post post) async {
    final docRef = _postCollection.doc();
    Post postWithNewId = post.copyWith(id: docRef.id);
    docRef.set(postWithNewId.toEntity().toDocument());
  }

  Future<void> addNewComment(Comment comment) async {
    assert(comment.relatedPost.isNotEmpty);
    // WriteBatch batch = FirebaseFirestore.instance.batch();
    final docRef = _commentCollection.doc();
    Comment commentWithNewId = comment.copyWith(id: docRef.id);
    docRef.set(commentWithNewId.toEntity().toDocument());
  }

  Future<void> incrementPostCommentCounter(String postId) async {
    assert(postId.isNotEmpty);

    final docRef = _postCollection.doc(postId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docSnap = await transaction.get(docRef);
      if (!docSnap.exists) {
        throw Exception('Post does not Exist');
      }
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
      final commentCount = data['commentCount'] + 1;
      transaction.update(docRef, {'commentCount': commentCount});
    });
  }

  Future<void> deletePost(Post post) async {
    assert(post.id.isNotEmpty);

    final docRef = await _postCollection.doc(post.id).get();
    if (docRef.exists) {
      _postCollection.doc(post.id).delete();
    }
  }

  Future<void> deleteComment(Comment comment) async {
    assert(comment.id.isNotEmpty);

    final docRef = await _commentCollection.doc(comment.id).get();
    if (docRef.exists) {
      _commentCollection.doc(comment.id).delete();
    }
  }

  Future<void> upvotePost(Post post, String uid, delta) async {
    assert(post.id.isNotEmpty);
    assert(delta <= 2);

    final docRef = _postCollection.doc(post.id);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(docRef, {'voteCount': FieldValue.increment(delta)});
    batch.update(docRef, {
      'upVoters': FieldValue.arrayUnion([uid])
    });
    batch.update(docRef, {
      'downVoters': FieldValue.arrayRemove([uid])
    });
    batch.commit();
  }

  Future<void> upvoteComment(Comment comment, String uid, delta) async {
    assert(comment.id.isNotEmpty);
    assert(delta <= 2);

    final docRef = _commentCollection.doc(comment.id);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(docRef, {'voteCount': FieldValue.increment(delta)});
    batch.update(docRef, {
      'upVoters': FieldValue.arrayUnion([uid])
    });
    batch.update(docRef, {
      'downVoters': FieldValue.arrayRemove([uid])
    });
    batch.commit();
  }

  Future<void> downvotePost(Post post, String uid, int delta) async {
    assert(post.id.isNotEmpty);
    assert(delta <= 2);

    final docRef = _postCollection.doc(post.id);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(docRef, {'voteCount': FieldValue.increment(delta)});
    batch.update(docRef, {
      'downVoters': FieldValue.arrayUnion([uid])
    });
    batch.update(docRef, {
      'upVoters': FieldValue.arrayRemove([uid])
    });
    batch.commit();
  }

  Future<void> downvoteComment(Comment comment, String uid, int delta) async {
    assert(comment.id.isNotEmpty);
    assert(delta <= 2);

    final docRef = _commentCollection.doc(comment.id);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(docRef, {'voteCount': FieldValue.increment(delta)});
    batch.update(docRef, {
      'downVoters': FieldValue.arrayUnion([uid])
    });
    batch.update(docRef, {
      'upVoters': FieldValue.arrayRemove([uid])
    });
    batch.commit();
  }

  Future<void> removeVoteOnPost(Post post, String uid, int delta) async {
    assert(post.id.isNotEmpty);
    assert(delta <= 1);

    final docRef = _postCollection.doc(post.id);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(docRef, {'voteCount': FieldValue.increment(delta)});
    batch.update(docRef, {
      'downVoters': FieldValue.arrayRemove([uid])
    });
    batch.update(docRef, {
      'upVoters': FieldValue.arrayRemove([uid])
    });
    batch.commit();
  }

  Future<void> removeVoteOnComment(
      Comment comment, String uid, int delta) async {
    assert(comment.id.isNotEmpty);
    assert(delta <= 1);

    final docRef = _commentCollection.doc(comment.id);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(docRef, {'voteCount': FieldValue.increment(delta)});
    batch.update(docRef, {
      'downVoters': FieldValue.arrayRemove([uid])
    });
    batch.update(docRef, {
      'upVoters': FieldValue.arrayRemove([uid])
    });
    batch.commit();
  }

  Stream<List<Post>> streamAllPosts() {
    return _postCollection
        .orderBy('voteCount', descending: true)
        .snapshots()
        .map((QuerySnapshot queryResults) => queryResults.docs
            .map((DocumentSnapshot snap) =>
                Post.fromEntity(PostEntity.fromSnapshot(snap)))
            .toList());
  }

  Stream<Post> streamSinglePost(String id) {
    assert(id.isNotEmpty);
    return _postCollection.doc(id).snapshots().map((DocumentSnapshot snap) =>
        Post.fromEntity(PostEntity.fromSnapshot(snap)));
  }

  Stream<List<Comment>> streamAllComments(String postId) {
    assert(postId.isNotEmpty);
    return _commentCollection
        .orderBy('voteCount', descending: true)
        .where('relatedPost', isEqualTo: postId)
        .snapshots()
        .map((QuerySnapshot queryResults) => queryResults.docs
            .map((DocumentSnapshot snap) =>
                Comment.fromEntity(CommentEntity.fromSnapshot(snap)))
            .toList());
  }

  Future<void> updateCommentContent(Comment comment) async {
    assert(comment.id.isNotEmpty);
    await _postCollection.doc(comment.id).set(
        <String, String>{'content': comment.content}, SetOptions(merge: true));
  }

  Future<void> updatePostContent(Post post) async {
    assert(post.id.isNotEmpty);
    await _postCollection.doc(post.id).set(
        <String, String>{'content': post.content}, SetOptions(merge: true));
  }

  Future<void> updatePostTitle(Post post) async {
    assert(post.id.isNotEmpty);
    await _postCollection
        .doc(post.id)
        .set(<String, String>{'content': post.title}, SetOptions(merge: true));
  }
}
