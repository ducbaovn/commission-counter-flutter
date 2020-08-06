import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/remote/api_client.dart';

class BaseRepository {
  ApiClient apiClient = locator<ApiClient>();
}
