import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/logger/app_logger.dart';
import 'package:commission_counter/schema/commission.dart';
import 'package:commission_counter/schema/order.dart';

class OrderService {
  Future<APIResponse> submitNewOrder({
    Order order,
    List<Commission> commissions,
  }) async {
    try {
      AppLogger.d(order.toJson().toString());

      WriteBatch batch = Firestore.instance.batch();

      ///Set order.
      DocumentReference ordersDocRef =
          Firestore.instance.collection('orders').document();

      batch.setData(ordersDocRef, order.toJson());

      /// Set commissions
      DocumentReference commissionsDocRef =
          Firestore.instance.collection('commissions').document();

      commissions.forEach((commission) {
        commission.orderId = ordersDocRef.documentID;
        batch.setData(commissionsDocRef, commission.toJson());
        AppLogger.d(commission.toJson().toString());
      });

      /// Commit all
      await batch.commit();

      return APIResponse(isSuccess: true);
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(isSuccess: false, message: e.message);
    }
  }
}
