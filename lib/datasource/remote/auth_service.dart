import 'package:commission_counter/schema/request/login_request.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/auth')
  Future<User> login(@Body() LoginRequest loginRequest);
}
