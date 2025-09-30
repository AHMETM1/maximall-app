import '../index.dart' show ServerConfig, ConfigType, Services;

abstract class BasePageRepository<T> {
  final service = Services();

  BasePageRepository() {
    initCursor();
  }

  Future<List<T>?> getData();

  dynamic cursor;

  bool hasNext = true;

  void refresh() {
    hasNext = true;
    cursor = null;
    initCursor();
  }

  /// Shopify and Notion, the cursor is String, the rest is int
  /// Shopify framework will return cursor
  /// The order framework will not and must to compute page number to call
  bool get isPlatformUseStringCursor => [
        ConfigType.shopify,
        ConfigType.notion,
      ].contains(ServerConfig().type);

  void initCursor() {
    if (isPlatformUseStringCursor == false) {
      cursor = 1;
    }
  }

  void updateCursor(dynamic newCursor) {
    final cursorIsInteger = cursor is int;

    if (cursorIsInteger) {
      cursor++;
      return;
    }
    cursor = newCursor;
  }

// T parseJson(Map<String, dynamic> json);

  Future<void> cancelCompleter() async {}
}
