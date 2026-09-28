import 'dart:io';

/// One selectable value in a numbered list.
class MenuOption<T> {
  final String label;
  final T value;
  const MenuOption(this.label, this.value);
}

/// One entry of a looping menu.
class MenuAction {
  final String label;
  final Future<void> Function() run;
  const MenuAction(this.label, this.run);
}

/// Small helper for validated console input. Every method keeps asking
/// until the user types something valid.
class Input {
  static String _readLine() {
    final line = stdin.readLineSync();
    if (line == null) {
      // stdin closed (Ctrl+D / end of piped input).
      print("\nInput closed. Goodbye!");
      exit(0);
    }
    return line.trim();
  }

  /// Non-empty text.
  static String text(String prompt, {int minLength = 1}) {
    while (true) {
      stdout.write("$prompt: ");
      final value = _readLine();
      if (value.length >= minLength) return value;
      print("  Please enter at least $minLength character(s).");
    }
  }

  /// Text that may be left empty.
  static String optional(String prompt) {
    stdout.write("$prompt: ");
    return _readLine();
  }

  static int integer(String prompt, {int? min, int? max}) {
    while (true) {
      stdout.write("$prompt: ");
      final value = int.tryParse(_readLine());
      if (value == null) {
        print("  Please enter a whole number.");
        continue;
      }
      if (min != null && value < min) {
        print("  Must be at least $min.");
        continue;
      }
      if (max != null && value > max) {
        print("  Must be at most $max.");
        continue;
      }
      return value;
    }
  }

  static double number(String prompt, {double? min, double? max}) {
    while (true) {
      stdout.write("$prompt: ");
      final value = double.tryParse(_readLine());
      if (value == null) {
        print("  Please enter a number.");
        continue;
      }
      if (min != null && value < min) {
        print("  Must be at least $min.");
        continue;
      }
      if (max != null && value > max) {
        print("  Must be at most $max.");
        continue;
      }
      return value;
    }
  }

  static bool yesNo(String prompt) {
    while (true) {
      stdout.write("$prompt (y/n): ");
      final value = _readLine().toLowerCase();
      if (value == "y" || value == "yes") return true;
      if (value == "n" || value == "no") return false;
      print("  Please type y or n.");
    }
  }

  /// Shows a numbered list and returns the value the user picked.
  static T pick<T>(String title, List<MenuOption<T>> options) {
    if (options.isEmpty) {
      throw StateError("pick() called with no options");
    }
    print("$title:");
    for (var i = 0; i < options.length; i++) {
      print("  ${i + 1}. ${options[i].label}");
    }
    final choice = integer("Choose", min: 1, max: options.length);
    return options[choice - 1].value;
  }

  /// Repeats a menu until the user chooses 0.
  static Future<void> runMenu(
    String title,
    List<MenuAction> actions, {
    String exitLabel = "Exit",
  }) async {
    while (true) {
      print("\n=== $title ===");
      for (var i = 0; i < actions.length; i++) {
        print("  ${i + 1}. ${actions[i].label}");
      }
      print("  0. $exitLabel");
      final choice = integer("Choose", min: 0, max: actions.length);
      if (choice == 0) return;
      print("");
      await actions[choice - 1].run();
    }
  }
}
