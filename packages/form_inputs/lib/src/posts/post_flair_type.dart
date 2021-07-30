import 'package:formz/formz.dart';

enum PostFlairTypeValidationError { invalid }

class PostFlairType extends FormzInput<String, PostFlairTypeValidationError> {
  const PostFlairType.pure() : super.pure('');
  const PostFlairType.dirty([String value = '']) : super.dirty(value);

  static final _postFlairTypeRegExp = RegExp(r'^(?=(PostFlair\.).*$).*$');

  @override
  PostFlairTypeValidationError? validator(String? value) {
    return _postFlairTypeRegExp.hasMatch(value ?? '')
        ? null
        : PostFlairTypeValidationError.invalid;
  }
}
