extension ExceptionCatcher on Function {
  void safeCall({void Function(Object error, StackTrace stackTrace)? onError}) {
    try {
      this();
    } catch (e, stackTrace) {
      print("Exception caught: $e");
      if (onError != null) {
        onError(e, stackTrace);
      } else {
        print("Stack trace: $stackTrace");
      }
    }
  }
}
