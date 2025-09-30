class ServerlessFirestoreService {
  Future<List<Map>> getCategories({
    int? parent,
    String? searchTerm,
    required String languageCode,
  }) async =>
      [];

  Future<List<Map>> getProducts({
    required String languageCode,
    String? categoryId,
    bool? featured,
    String? search,
  }) async =>
      [];

  Future<List<String>> getListIdsCategoryByProductId(String productId) async =>
      [];

  Future<Map?> getCategoryById(String categoryId) async => null;

  Future<Map?> getProduct(String id) async => null;

  Future<List<Map>> getOrdersByUserId(
    String userId, {
    String? orderStatus,
  }) async =>
      [];

  Future<void> createUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {}

  Future<Map?> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    return null;
  }

  Future<Map?> getUserById(String userId) async => {};

  Future<String?> createOrder(Map<String, dynamic> orderData) async {
    return null;
  }

  Future<Map?> getOrderById(String orderId) async {
    return null;
  }

  Future<Map?> updateOrder(
      String orderId, Map<String, dynamic> orderData) async {
    return null;
  }

  Future<void> deleteUser(String userId) async {}

  Future<List<Map>> getBooking(String userId) async => [];

  Future<bool> deleteOrder(String orderId) async => false;

  Future<List<Map>> getCoupons({String search = ''}) async => [];

  Future<List<Map>> getBrands({String? slug}) async => [];
  Future<Map?> getBrand({String? slug, String? id}) async => {};

  Future<List<Map>> getPaymentMethod() async => [];
  Future<List<Map>> getShippingMethods() async => [];
}
