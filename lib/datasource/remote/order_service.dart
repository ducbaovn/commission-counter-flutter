import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/datasource/local/local_database.dart';
import 'package:commission_counter/datasource/local/model/commission_model.dart';
import 'package:commission_counter/logger/app_logger.dart';
import 'package:commission_counter/schema/commission.dart';
import 'package:commission_counter/schema/order.dart';

class OrderService {
  Future<APIResponse<Order>> createOrder({
    Order order,
    List<Commission> commissions,
  }) async {
    try {
      WriteBatch batch = Firestore.instance.batch();

      ///Set order.
      DocumentReference ordersDocRef =
          Firestore.instance.collection('orders').document();
      String orderId = ordersDocRef.documentID;

      batch.setData(ordersDocRef, order.toJson());
      order.id = orderId;

      /// Set commissions
      List<CommissionModel> commissionModels = [];

      commissions.forEach((commission) {
        commission.orderId = orderId;

        DocumentReference commissionsDocRef =
            Firestore.instance.collection('commissions').document();
        batch.setData(commissionsDocRef, commission.toJson());

        commissionModels.add(
            commission.toCommissionModel..id = commissionsDocRef.documentID);
      });

      await batch.commit();

      await DBProvider.db.createOrder(
        order.toOrderModel..id = orderId,
        commissionModels,
      );

      return APIResponse(
        isSuccess: true,
        data: order,
      );
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(isSuccess: false, message: e.message);
    }
  }

  Future<APIResponse<Order>> updateOrder({
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
          .where('orderId', isEqualTo: order.id)
          .where('storeOwnerId', isEqualTo: order.storeOwnerId)
          .getDocuments();

      deleteCommissionQuerySnapshot.documents.forEach((element) {
        batch.delete(element.reference);
      });

      ///Set new commissions
      List<CommissionModel> commissionModels = [];

      commissions.forEach((commission) {
        commission.orderId = order.id;

        DocumentReference commissionsDocRef =
            commissionsCollectionReference.document();

        batch.setData(commissionsDocRef, commission.toJson());

        commissionModels.add(
            commission.toCommissionModel..id = commissionsDocRef.documentID);
      });

      await batch.commit();

      await DBProvider.db.updateOrder(
        order.toOrderModel..id = order.id,
        commissionModels,
      );

      return APIResponse(
        isSuccess: true,
        data: order,
      );
    } catch (e) {
      AppLogger.e(e);
      return APIResponse(isSuccess: false, message: e.message);
    }
  }
}
