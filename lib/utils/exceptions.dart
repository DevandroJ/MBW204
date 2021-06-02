class CustomException implements Exception {
  final dynamic cause;
  CustomException([this.cause]);

  String toString() {
    Object cause = this.cause;
    if (cause == null) return "CustomException";
    return cause;
  }
}
class ServerErrorException implements Exception {
  final dynamic cause;
  ServerErrorException(this.cause);

  String toString() {
    Object cause = this.cause;
    if(cause == null) return "ServerException";
    return cause;
  }
}