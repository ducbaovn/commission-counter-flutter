import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/logger/app_logger.dart';
import 'package:commission_counter/schema/store.dart';

class StoreService {
  Future<APIResponse<Store>> getStoreData(String storeId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await Firestore.instance.collection('stores').document(storeId).get();

      if (documentSnapshot.data == null) {
        return APIResponse(
          isSuccess: false,
          message: 'Store not found',
        );
      }
      return APIResponse(
        isSuccess: true,
        data: Store.fromJson(documentSnapshot.data),
      );
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(isSuccess: false, message: e.message);
    }
  }
}
