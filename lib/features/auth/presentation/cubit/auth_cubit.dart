import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/auth_repository.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final FlutterSecureStorage secureStorage;

  AuthCubit(this.authRepository, this.secureStorage) : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(username, password);

      // Save tokens so future requests are authenticated and
      // relaunching the app can auto-login (SplashScreen checks this).
      if (user.accessToken != null) {
        await secureStorage.write(
          key: DioClient.accessTokenKey,
          value: user.accessToken!,
        );
      }

      emit(AuthAuthenticated(user));
    } catch (e) {
      if (e is Failure) {
        emit(AuthError(e.message));
      } else {
        emit(AuthError('Something went wrong. Please try again.'));
      }
    }
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (e) {
      if (e is Failure) {
        emit(AuthError(e.message));
      } else {
        emit(AuthError('Something went wrong. Please try again.'));
      }
    }
  }

  Future<void> logout() async {
    await secureStorage.delete(key: DioClient.accessTokenKey);
    emit(AuthInitial());
  }
}