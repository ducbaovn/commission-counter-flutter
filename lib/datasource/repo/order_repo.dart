import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_repo.dart';
import 'package:commission_counter/datasource/local/local_database.dart';
import 'package:commission_counter/datasource/local/model/commission_model.dart';
import 'package:commission_counter/datasource/local/model/order_model.dart';
import 'package:commission_counter/schema/commission.dart';
import 'package:commission_counter/schema/order.dart';

class OrderRepo extends BaseRepository {
  Future<APIResponse<Order>> createOrUpdateOrder({
    Order order,
    List<Commission> commissions,
  }) {
    return order.id == null
        ? apiClient.orderService.createOrder(
            order: order,
            commissions: commissions,
          )
        : apiClient.orderService.updateOrder(
            order: order,
            commissions: commissions,
          );
  }

  Future<APIResponse> updateOrder({
    Order order,
    List<Commission> commissions,
  }) {
    return apiClient.orderService.updateOrder(
      order: order,
      commissions: commissions,
    );
  }

  Future<List<Order>> getAllOrderByStoreId(String storeId) async {
    List<OrderModel> orderModelList =
        await DBProvider.db.getAllOrderByStoreId(storeId);
    return orderModelList.map((item) => item.toOrder).toList();
  }

  Future<List<Commission>> getCommissionByOrderId(String orderId) async {
    List<CommissionModel> orderModelList =
        await DBProvider.db.getCommissionsByOrderId(orderId);
    return orderModelList.map((item) => item.toCommission).toList();
  }

  Future<APIResponse<double>> getReport({
    DateTime startTime,
    DateTime endTime,
    String adminId,
    String storeOwnerId,
    String agentId,
    String customerId,
  }) async {
    return await apiClient.orderService.getReport(
      startTime: startTime,
      endTime: endTime,
      adminId: adminId,
      storeOwnerId: storeOwnerId,
      agentId: agentId,
      customerId: customerId,
    );
  }
}
