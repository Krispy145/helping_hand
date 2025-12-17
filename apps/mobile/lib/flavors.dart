enum Flavor {
  dev,
  stg,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Helping Hand (Dev)';
      case Flavor.stg:
        return 'Helping Hand (Stg)';
      case Flavor.prod:
        return 'Helping Hand';
    }
  }

}
