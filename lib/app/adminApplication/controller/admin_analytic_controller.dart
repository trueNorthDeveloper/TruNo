import 'package:flutter/widgets.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_login_record.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/service/admin_analytic_service.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

class AdminAnalyticController extends ChangeNotifier {
  AdminAnalyticService _service = AdminAnalyticService();
//========================================================
//*LOGIN USER START.......................................
//========================================================
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  int _currentPage = 0;
  final _size = 10;
  bool _isLastPage = false;
  bool get isLastPage => _isLastPage;
  ApiError? error;
  List<AdminLoginRecord> _adminAllLoginRecord = [];
  List<AdminLoginRecord> get adminAllLoginRecord => _adminAllLoginRecord;
  Future<void> fatchadminAllLoginUser({bool onRefresh = false}) async {
    if (_isLogin || _isLastPage && !onRefresh) return;
    _isLogin = true;
    error = null;
    notifyListeners();
    try {
      //calling api for method..............
      final allLoginResponse =
          await _service.fatchAdminServiceAllLoginUser(_currentPage, _size);
      if (allLoginResponse.isSuccess && allLoginResponse.data != null) {
        final pageData = allLoginResponse.data!;
        if (pageData.content != null) {
          _adminAllLoginRecord.addAll(pageData.content!);
        }
        _isLastPage = pageData.last ?? true;
        _currentPage++;
      } else {
        error = allLoginResponse.error;
      }
    } catch (e) {
      error = ApiError.emptyResponse;
    } finally {
      _isLogin = false;
      notifyListeners();
    }
  }
  //======================================================
//*0 ALLL LOGIN USER END..................................
//========================================================
}
