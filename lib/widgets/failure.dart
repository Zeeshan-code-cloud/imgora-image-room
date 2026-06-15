class Failure {
  String? errorMessage;
  String? code;

  Failure({this.errorMessage, this.code});

  @override
  String toString() => 'Failure(errorMessage: $errorMessage, code: $code)';

}
