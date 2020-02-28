import 'CieloError.dart';

class CieloException implements Exception {
  final List<CieloError> errors;
  final String message;

  CieloException(this.errors, this.message);

  @override
  String toString() {
    return 'CieloException{errors: $errors, message: $message}';
  }
}
