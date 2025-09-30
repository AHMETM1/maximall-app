extension MapExtension on Map {
  List<T>? tryGetValueList<T>(String key) {
    return this[key] is List<T> ? this[key] : null;
  }

  List<T> getValueList<T>(String key, {List<T> defaultValue = const []}) {
    return tryGetValueList<T>(key) ?? defaultValue;
  }
}
