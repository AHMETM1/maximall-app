// ignore_for_file: one_member_abstracts
import '../entities/flux_firebase_option.dart';

abstract class FirebaseCoreService {
  Future<dynamic> initializeApp({FluxFirebaseOption? option, String? name});
}
