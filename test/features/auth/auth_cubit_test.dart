import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:office_task/core/error/failure.dart';
import 'package:office_task/features/auth/data/auth_repository.dart';
import 'package:office_task/features/auth/domain/model/user.dart';
import 'package:office_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:office_task/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}


void main() {
  late MockAuthRepository mockAuthRepository;
  late MockFlutterSecureStorage mockSecureStorage;
  late AuthCubit authCubit;

  const fakeUser = User(
    id: 1,
    username: 'emilys',
    email: 'emily.johnson@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    accessToken: 'fake_token',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSecureStorage = MockFlutterSecureStorage();
    authCubit = AuthCubit(mockAuthRepository, mockSecureStorage);
  });

  tearDown(() {
    authCubit.close();
  });

blocTest<AuthCubit, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] when login succeeds',
  build: () {
    when(() => mockAuthRepository.login('emilys', 'emilyspass'))
        .thenAnswer((_) async => fakeUser);
    when(() => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenAnswer((_) async {});
    return authCubit;
  },
  act: (cubit) => cubit.login('emilys', 'emilyspass'),
  expect: () => [
    isA<AuthLoading>(),
    AuthAuthenticated(fakeUser),
  ],
);


blocTest<AuthCubit, AuthState>(
  'emits [AuthLoading, AuthError] when login fails with wrong credentials',
  build: () {
    when(() => mockAuthRepository.login('emilys', 'wrongpass'))
        .thenThrow(const ServerFailure('Invalid credentials'));
    return authCubit;
  },
  act: (cubit) => cubit.login('emilys', 'wrongpass'),
  expect: () => [
    isA<AuthLoading>(),
    const AuthError('Invalid credentials'),
  ],
);

}