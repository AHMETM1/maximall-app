extension ListStringExtension on List<String> {
  bool anyTheSame(String? item) {
    if (item == null || isEmpty) {
      return false;
    }

    return any((e) => e == item || e.contains(item) || item.contains(e));
  }
}
