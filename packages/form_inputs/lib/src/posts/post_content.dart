import 'package:formz/formz.dart';

enum PostContentValidationError { invalid }

class PostContent extends FormzInput<String, PostContentValidationError> {
  const PostContent.pure() : super.pure('');
  const PostContent.dirty([String value = '']) : super.dirty(value);

  // static final _postContentRegExp = RegExp(r'^(?=.{1,200}$).*$');

  @override
  PostContentValidationError? validator(String? value) {
    if (value == null) return PostContentValidationError.invalid;
    return value.length > 1 && value.length < 300
        ? null
        : PostContentValidationError.invalid;
  }
}
