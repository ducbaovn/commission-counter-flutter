import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/logger/app_logger.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/type/user_role.dart';
import 'package:enum_to_string/enum_to_string.dart';
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

  Future<APIResponse<List<User>>> getCustomer(
      String hostId, UserRole userRole) async {
    try {

      String hostType;
      UserRole roleType;

      switch (userRole) {
        case UserRole.ADMIN:
          hostType = 'adminId';
          roleType = UserRole.STORE_OWNER;
          break;

        case UserRole.STORE_OWNER:
          hostType = 'storeOwnerId';
          roleType = UserRole.AGENT;
          break;

        case UserRole.AGENT:
          hostType = 'agentId';
          roleType = UserRole.CUSTOMER;
          break;

        default:
          return APIResponse(
            isSuccess: false,
            message: 'Dose not support for ${EnumToString.parse(userRole)}',
          );
      }

      final userQuerySnapshot = await Firestore.instance
          .collection('users')
          .where(hostType, isEqualTo: hostId)
          .where('role', isEqualTo: EnumToString.parse(roleType))
          .getDocuments();

      List<User> users = userQuerySnapshot.documents
          .map((item) => User.fromJson(item.data))
          .toList();

      return APIResponse<List<User>>(data: users);
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(
        isSuccess: false,
        message: e.message,
      );
    }
  }
}
