import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flux_interface/flux_interface.dart';

class FirebaseCloudFunctionServiceImpl extends FirebaseCloudFunctionService {
  final FirebaseFunctions _firebaseFunctions;

  FirebaseCloudFunctionServiceImpl({
    FirebaseApp? app,
  }) : _firebaseFunctions = app != null
            ? FirebaseFunctions.instanceFor(app: app)
            : FirebaseFunctions.instance;

  @override
  Future<dynamic> callFunction(String functionName, dynamic data) async {
    var callable = _firebaseFunctions.httpsCallable(
      functionName,
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 300),
      ),
    );

    final result = await callable.call(data);
    return result.data;
  }
}
