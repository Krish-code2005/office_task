// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:office_task/core/di/register_module.dart' as _i417;
import 'package:office_task/core/network/dio_client.dart' as _i184;
import 'package:office_task/features/auth/data/auth_repository.dart' as _i57;
import 'package:office_task/features/auth/presentation/cubit/auth_cubit.dart'
    as _i427;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i184.DioClient>(
      () => _i184.DioClient(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i57.AuthRepository>(
      () => _i57.AuthRepository(gh<_i184.DioClient>()),
    );
    gh.factory<_i427.AuthCubit>(
      () => _i427.AuthCubit(
        gh<_i57.AuthRepository>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i417.RegisterModule {}
