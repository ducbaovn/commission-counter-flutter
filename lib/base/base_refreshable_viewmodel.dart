import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:commission_counter/base/base_viewmodel.dart';

class BaseRefreshAbleViewModel extends BaseViewModel {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
}
