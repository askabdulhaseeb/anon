class CustomExceptions {
  fromObject(dynamic e) {}

  static String auth(dynamic e) {
    final String code = e.code;
    switch (code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
      case 'account-exists-with-different-credential':
      case 'email-already-in-use':
        return 'Email already used. Go to login page.';
      case 'ERROR_WRONG_PASSWORD':
      case 'wrong-password':
      case 'Error 17009':
        return 'Wrong email/password combination.';
      case 'ERROR_USER_NOT_FOUND':
      case 'user-not-found':
      case 'Error 17011':
        return 'No user found with this email.';
      case 'ERROR_USER_DISABLED':
      case 'user-disabled':
        return 'User disabled.';
      case 'ERROR_TOO_MANY_REQUESTS':
      case 'operation-not-allowed':
        return 'Too many requests to log into this account.';
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return 'Server error, please try again later.';
      case 'ERROR_INVALID_EMAIL':
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'Error 17020':
        return 'Network Error';
      default:
        return 'Login failed.';
    }
  }

  static String storage(dynamic e) {
    final String code = e.code;
    switch (code) {
      case 'storage/unknown':
      case 'storage/object-not-found':
      case 'storage/bucket-not-found':
      case 'storage/project-not-found':
      case 'storage/no-default-bucket':
        return 'Invalid address';
      case 'storage/quota-exceeded':
      case 'storage/retry-limit-exceeded':
        return 'Too many request';
      case 'storage/unauthenticated':
      case 'storage/unauthorized':
        return 'Can have access';
      case 'storage/invalid-checksum':
        return 'Unknow File Type';
      case 'storage/canceled':
        return 'Request canceled';
      case 'storage/invalid-event-name':
        return 'Invalid Event';
      case 'storage/invalid-url':
      case 'storage/storage/invalid-argument':
        return 'Invalid URL';
      case 'storage/cannot-slice-blob':
        return 'File not available anymore';
      case 'storage/server-file-wrong-size':
        return 'Large file size';
      default:
        return 'Facing some issue';
    }
  }
}
