
import 'package:intl/intl.dart';

class TranslationText {
  String  userName() =>
      Intl.message(
        "Username",
        name: "userName",
        args: []
      );

}
