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
          message: 'User not found.',
        );
      }
      User user = User.fromJson(documentSnapshot.data);

      if (user.userRoleType != UserRole.CUSTOMER) {
        return APIResponse(
          isSuccess: false,
          message: 'Please input customer user.',
        );
      }
      return APIResponse(
        isSuccess: true,
        data: user,
      );
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(
        isSuccess: false,
        message: e.message,
      );
    }
  }

  Future<APIResponse<List<User>>> getUsers(
    UserRole userRole, {
    String adminId,
    String storeOwnerId,
    String agentId,
  }) async {
    try {
      CollectionReference userCollectionReference =
          Firestore.instance.collection('users');

      Query query = userCollectionReference.where(
        'role',
        isEqualTo: EnumToString.parse(userRole),
      );

      switch (userRole) {
        case UserRole.STORE_OWNER:
          query = query.where('adminId', isEqualTo: adminId);
          break;

        case UserRole.AGENT:
          query = query
              .where('adminId', isEqualTo: adminId)
              .where('storeOwnerId', isEqualTo: storeOwnerId);
          break;

        case UserRole.CUSTOMER:
          query = query
              .where('adminId', isEqualTo: adminId)
              .where('storeOwnerId', isEqualTo: storeOwnerId)
              .where('agentId', isEqualTo: agentId);
          break;
      }

      final userQuerySnapshot = await query.getDocuments();

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
