import 'package:formz/formz.dart';

enum PostTitleValidationError { invalid }

class PostTitle extends FormzInput<String, PostTitleValidationError> {
  const PostTitle.pure() : super.pure('');
  const PostTitle.dirty([String value = '']) : super.dirty(value);

  static final _postTitleRegExp = RegExp(r'^(?=.{1,16}$).*$');

  @override
  PostTitleValidationError? validator(String? value) {
    return _postTitleRegExp.hasMatch(value ?? '')
        ? null
        : PostTitleValidationError.invalid;
  }
}
