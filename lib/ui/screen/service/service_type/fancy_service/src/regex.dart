class Regex {
  // https://stackoverflow.com/a/32686261/9449426
  static final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final pelak=RegExp(r'[A-Z][a-zA-Z][a-zA-Z0-9]{1,20}$');
}
