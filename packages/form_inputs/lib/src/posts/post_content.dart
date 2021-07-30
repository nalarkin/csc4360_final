import 'package:formz/formz.dart';

enum PostContentValidationError { invalid }

class PostContent extends FormzInput<String, PostContentValidationError> {
  const PostContent.pure() : super.pure('');
  const PostContent.dirty([String value = '']) : super.dirty(value);

  static final _postContentRegExp = RegExp(r'^(?=.{1,40}$).*$');

  @override
  PostContentValidationError? validator(String? value) {
    return _postContentRegExp.hasMatch(value ?? '')
        ? null
        : PostContentValidationError.invalid;
  }
}
