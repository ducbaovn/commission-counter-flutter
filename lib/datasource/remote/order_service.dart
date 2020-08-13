import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/datasource/local/local_database.dart';
import 'package:commission_counter/datasource/local/model/commission_model.dart';
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

      String orderId = ordersDocRef.documentID;
      List<CommissionModel> commissionModels = [];

      commissions.forEach((commission) {
        commission.orderId = orderId;

        commissionModels.add(commission.toCommissionModel);

        batch.setData(commissionsDocRef, commission.toJson());
      });

      await batch.commit();

      await DBProvider.db.addNewOrder(
        order.toOrderModel..id = orderId,
        commissionModels,
      );

      return APIResponse(isSuccess: true);
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(isSuccess: false, message: e.message);
    }
  }

  Future<APIResponse> updateOrder({
    Order order,
    List<Commission> commissions,
  }) async {
    try {
      WriteBatch batch = Firestore.instance.batch();
      CollectionReference commissionsCollectionReference =
          Firestore.instance.collection('commissions');

      ///Set order.
      DocumentReference ordersDocRef =
          Firestore.instance.collection('orders').document(order.id);

      batch.updateData(ordersDocRef, order.toJson());

      ///Delete old commissions
      final deleteCommissionQuerySnapshot = await commissionsCollectionReference
          .where('order_id', isEqualTo: order.id)
          .getDocuments();

      deleteCommissionQuerySnapshot.documents.forEach((element) {
        batch.delete(element.reference);
      });

      ///Set new commissions
      DocumentReference commissionsDocRef =
          commissionsCollectionReference.document();

      List<CommissionModel> commissionModels = [];

      commissions.forEach((commission) {
        commission.orderId = order.id;

        commissionModels.add(commission.toCommissionModel);

        batch.setData(commissionsDocRef, commission.toJson());
      });

      await batch.commit();

      await DBProvider.db.updateOrder(
        order.toOrderModel..id = order.id,
        commissionModels,
      );

      return APIResponse(isSuccess: true);
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(isSuccess: false, message: e.message);
    }
  }
}
