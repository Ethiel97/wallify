class ErrorMessageMapper {
  static String mapErrorToUserFriendlyMessage(String errorMessage) {
    final lowerCaseError = errorMessage.toLowerCase();

    // Network errors
    if (lowerCaseError.contains('network') ||
        lowerCaseError.contains('connection') ||
        lowerCaseError.contains('timeout')) {
      return 'Network error. Please check your connection and try again.';
    }

    // Auth errors
    if (lowerCaseError.contains('already taken') ||
        lowerCaseError.contains('already exists') ||
        lowerCaseError.contains('conflict')) {
      return 'Email or username already taken.';
    }

    if (lowerCaseError.contains('invalid credentials') ||
        lowerCaseError.contains('wrong password') ||
        lowerCaseError.contains('user not found')) {
      return 'Invalid email or password.';
    }

    if (lowerCaseError.contains('weak password')) {
      return 'Password is too weak. Please choose a stronger password.';
    }

    if (lowerCaseError.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }

    if (lowerCaseError.contains('user disabled')) {
      return 'This account has been disabled. Please contact support.';
    }

    if (lowerCaseError.contains('too many requests')) {
      return 'Too many attempts. Please try again later.';
    }

    // Server errors
    if (lowerCaseError.contains('server') || lowerCaseError.contains('500')) {
      return 'Server error. Please try again later.';
    }

    if (lowerCaseError.contains('forbidden') ||
        lowerCaseError.contains('403')) {
      return 'Access denied.';
    }

    // Default fallback
    return 'An unexpected error occurred. Please try again.';
  }
}
