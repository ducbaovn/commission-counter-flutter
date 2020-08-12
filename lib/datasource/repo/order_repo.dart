import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_repo.dart';
import 'package:commission_counter/schema/commission.dart';
import 'package:commission_counter/schema/order.dart';

class OrderRepo extends BaseRepository {
  Future<APIResponse> submitOrder({
    Order order,
    List<Commission> commissions,
  }) {
    return apiClient.orderService.submitNewOrder(
      order: order,
      commissions: commissions,
    );
  }
}
