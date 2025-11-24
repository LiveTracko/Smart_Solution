String getErrorMessage(dynamic e) {
  if (e is String) return e;

  if (e.toString().contains("SocketException")) {
    return "No Internet connection. Please check your network.";
  }

  if (e.toString().contains("TimeoutException")) {
    return "Server taking too long to respond.";
  }

  if (e.toString().contains("401")) {
    return "Unauthorized! Please login again.";
  }

  if (e.toString().contains("500")) {
    return "Server error. Please try later.";
  }

  return "Something went wrong. Please try again.";
}
