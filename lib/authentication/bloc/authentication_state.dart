part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  newTeacher,
  teacher,
  parent,
  newParent,
  logOutFailure,
}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    required this.status,
    this.user = User.empty,
  });

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);
  const AuthenticationState.logOutFailure()
      : this._(status: AuthenticationStatus.logOutFailure);

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
