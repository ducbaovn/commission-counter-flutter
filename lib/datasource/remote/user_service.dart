import 'package:commission_counter/base/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }
}
