import 'package:casino/base/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<APIResponse<FirebaseUser>> login(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return APIResponse<FirebaseUser>(data: result.user);
    } catch (error) {
      return APIResponse(
        isSuccess: false,
        message: error.message,
      );
    }
  }

  Future<APIResponse> resetPasswordViaEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return APIResponse();
    } catch (error) {
      return APIResponse(
        isSuccess: false,
        message: error.message,
      );
    }
  }

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }

  Future<void> logOut() async {
    return await _auth.signOut();
  }
}
