extension SetToggle<T> on Set<T> {
  /// Toggles whether [element] is an element of this set.
  ///
  /// If [element] is not currently a member, it is added, and this method returns `true`.
  /// If [element] is currently a member, it is removed, and this method returns `false`.
  bool toggle(T element) => !remove(element) && add(element);
}
