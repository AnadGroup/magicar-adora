enum Flavor {
  MAGICAR,
  ADORA,
}

class F {
  static Flavor appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.MAGICAR:
        return 'Magicar';
      case Flavor.ADORA:
        return 'Adora';
      default:
        return 'title';
    }
  }

}
