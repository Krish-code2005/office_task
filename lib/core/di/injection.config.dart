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
import 'package:office_task/core/services/local_notification_service.dart'
    as _i1003;
import 'package:office_task/core/services/push_notification_service.dart'
    as _i1045;
import 'package:office_task/features/auth/data/auth_repository.dart' as _i57;
import 'package:office_task/features/auth/presentation/cubit/auth_cubit.dart'
    as _i427;
import 'package:office_task/features/product/data/product_repository.dart'
    as _i645;
import 'package:office_task/features/product/presentation/cubit/product_detail_cubit.dart'
    as _i502;
import 'package:office_task/features/product/presentation/cubit/product_list_cubit.dart'
    as _i664;

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
    gh.lazySingleton<_i1003.LocalNotificationService>(
      () => _i1003.LocalNotificationService(),
    );
    gh.lazySingleton<_i1045.PushNotificationService>(
      () =>
          _i1045.PushNotificationService(gh<_i1003.LocalNotificationService>()),
    );
    gh.lazySingleton<_i184.DioClient>(
      () => _i184.DioClient(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i57.AuthRepository>(
      () => _i57.AuthRepository(gh<_i184.DioClient>()),
    );
    gh.lazySingleton<_i645.ProductRepository>(
      () => _i645.ProductRepository(gh<_i184.DioClient>()),
    );
    gh.factory<_i427.AuthCubit>(
      () => _i427.AuthCubit(
        gh<_i57.AuthRepository>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i502.ProductDetailCubit>(
      () => _i502.ProductDetailCubit(gh<_i645.ProductRepository>()),
    );
    gh.factory<_i664.ProductListCubit>(
      () => _i664.ProductListCubit(gh<_i645.ProductRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i417.RegisterModule {}
