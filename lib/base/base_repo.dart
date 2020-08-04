import 'package:casino/base/di/locator.dart';
import 'package:casino/datasource/remote/api_client.dart';

class BaseRepository {
  ApiClient apiClient = locator<ApiClient>();
}
