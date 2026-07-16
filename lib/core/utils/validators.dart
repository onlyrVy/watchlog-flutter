/// Shared form validation logic. Kept out of widgets so pages only
/// deal with UI, not validation rules — and rules stay consistent
/// between, say, the register form and future "edit profile" form.
class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!pattern.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (value.trim().length < 3) return 'Username must be at least 3 characters';
    final pattern = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Only letters, numbers, and underscores allowed';
    }
    return null;
  }

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }
}
