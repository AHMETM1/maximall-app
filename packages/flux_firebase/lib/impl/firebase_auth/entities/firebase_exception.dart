import 'package:firebase_auth/firebase_auth.dart';
import 'package:flux_interface/flux_interface.dart';

extension FirebaseAuthExceptionExt on FirebaseAuthException {
  FirebaseErrorException toEntityApp() {
    return FirebaseErrorException(
      code: code,
      plugin: plugin,
      message: message,
      email: email,
      phoneNumber: phoneNumber,
      tenantId: tenantId,
    );
  }
}
