/// List of supported chat providers
enum ChatProviders {
  chatGPT,
  zohoSalesiq;

  @override
  String toString() {
    return name;
  }

  static ChatProviders? fromString(String? name) {
    try {
      return ChatProviders.values.byName('$name');
    } catch (e) {
      return null;
    }
  }
}
