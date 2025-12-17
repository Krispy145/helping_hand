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

  static String get apiBaseUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'http://localhost:3000';
      case Flavor.stg:
        return 'https://stg-api.helpinghand.com';
      case Flavor.prod:
        return 'https://api.helpinghand.com';
    }
  }

}
