import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/logger/app_logger.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }

  Future<APIResponse<User>> getUserInfo(String userName) async {
    try {
      DocumentSnapshot documentSnapshot =
          await Firestore.instance.collection('users').document(userName).get();

      if (documentSnapshot.data == null) {
        return APIResponse(
          isSuccess: false,
          message: 'User not found',
        );
      }
      return APIResponse(
        isSuccess: true,
        data: User.fromJson(documentSnapshot.data),
      );
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(
        isSuccess: false,
        message: e.message,
      );
    }
  }
}
