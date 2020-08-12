import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_repo.dart';
import 'package:commission_counter/schema/store.dart';

class StoreRepo extends BaseRepository {
  Future<APIResponse<Store>> getStoreData(storeId) {
    return apiClient.storeService.getStoreData(storeId);
  }
}
