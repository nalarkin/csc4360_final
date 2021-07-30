import 'package:post_repository/post_repository.dart';
enum VotingStatus { neutral, upVoted, downVoted }

VotingStatus getVotingStatusFromPost(Post post, String uid) {
  if (post.upVoters.contains(uid)) {
    return VotingStatus.upVoted;
  } else if (post.downVoters.contains(uid)) {
    return VotingStatus.downVoted;
  }
  return VotingStatus.neutral;
}
VotingStatus getVotingStatusFromComment(Comment post, String uid) {
  if (post.upVoters.contains(uid)) {
    return VotingStatus.upVoted;
  } else if (post.downVoters.contains(uid)) {
    return VotingStatus.downVoted;
  }
  return VotingStatus.neutral;
}
