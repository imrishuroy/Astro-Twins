class PasswordUtil {
  static String? checkPassword(String value) {
    RegExp numReg = RegExp(r'.*[0-9].*');
    RegExp letterReg = RegExp(r'.*[A-Za-z].*');

    String? displayText = 'Please enter a password';

    value = value.trim();
    if (value.isEmpty) {
      displayText = 'Please enter you password';
    } else if (value.length < 6) {
      displayText = 'Your password is too short';
    } else if (value.length < 8) {
      // _displayText = 'Your password is acceptable but not strong';
      displayText = 'Your password is not strong';
    } else {
      if (!letterReg.hasMatch(value) || !numReg.hasMatch(value)) {
        displayText =
            'Password should consist of characters\nwith a combination of letters,\nnumbers, and symbols';
        //(@, #, \$, %, etc.)';
        // 'Password should consist of at least six characters\nwith a combination of letters, numbers, and\nsymbols (@, #, \$, %, etc.)';
      } else {
        return null;
      }
    }
    return displayText;
  }
}
