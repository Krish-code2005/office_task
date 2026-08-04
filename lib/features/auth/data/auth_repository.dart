import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:office_task/core/error/dio_error_mapper.dart';
import 'package:office_task/core/network/dio_client.dart';
import 'package:office_task/features/auth/domain/model/user.dart';


@lazySingleton
class AuthRepository {
  final DioClient dioClient;

  AuthRepository(this.dioClient);


  Future<User> login(String username, String password) async{
    
    try{
      final reponse = await dioClient.dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      return User.fromJson(reponse.data);
    } on DioException catch (e){
      throw mapDioExceptionToFailure(e);
    }
  }
Future<User> getCurrentUser() async {
    try {
      final response = await dioClient.dio.get('/auth/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }

  Future<void> logout() async {
   
  }
}