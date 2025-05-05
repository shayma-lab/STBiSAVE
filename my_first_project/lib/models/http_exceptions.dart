import 'dart:io';

class CustomHttpException implements Exception {
  final String message;
  CustomHttpException(this.message);

  @override
  String toString() {
    return message;
  }
}

Future<T> handleErrors<T>(Future<T> Function() operation) async {
  try {
    return await operation();
  } on SocketException {
    throw CustomHttpException("Impossible d'accéder à Internet!");
  } on FormatException {
    throw CustomHttpException(
        "Une erreur est survenue lors du traitement des données.");
  } on StateError {
    throw CustomHttpException("Une erreur est survenue");
  } catch (exception) {
    throw CustomHttpException(exception.toString());
  }
}
