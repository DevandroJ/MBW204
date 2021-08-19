class CustomException implements Exception {
  final dynamic cause;
  CustomException([this.cause]);

  String toString() {
    Object cause = this.cause;
    if (cause == null) return "CustomException";
    return cause;
  }
}
class NullException implements Exception {
  final dynamic cause;
  NullException([this.cause]);

  String toString() {
    Object cause = this.cause;
    if (cause == null) return "CustomException";
    return cause;
  }
}
class ConnectionTimeoutException implements Exception {
  final dynamic cause;
  ConnectionTimeoutException([this.cause]);

  String toString() {
    Object cause = this.cause;
    if (cause == null) return "ConnectionTimeoutException";
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