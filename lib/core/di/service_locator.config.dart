// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:v2x/core/network/network_module.dart' as _i37;
import 'package:v2x/core/storage/secure_storage_user.dart' as _i10;
import 'package:v2x/core/storage/storage_module.dart' as _i38;
import 'package:v2x/core/utils/media_picker_helper.dart' as _i6;
import 'package:v2x/features/auth/data/di/auth_data_source_module.dart' as _i39;
import 'package:v2x/features/auth/data/remote/remote_auth_data_source.dart'
    as _i7;
import 'package:v2x/features/auth/data/repository/auth_repository_impl.dart'
    as _i18;
import 'package:v2x/features/auth/domain/repository/auth_repository.dart'
    as _i17;
import 'package:v2x/features/auth/domain/usecases/login/login_api_use_case.dart'
    as _i26;
import 'package:v2x/features/auth/domain/usecases/login/validate_login_use_case.dart'
    as _i12;
import 'package:v2x/features/auth/domain/usecases/register/register_api_use_case.dart'
    as _i29;
import 'package:v2x/features/auth/domain/usecases/register/validate_register_use_case.dart'
    as _i13;
import 'package:v2x/features/auth/domain/usecases/user/get_user_api_use_case.dart'
    as _i21;
import 'package:v2x/features/auth/presentation/login/login_view_model.dart'
    as _i27;
import 'package:v2x/features/auth/presentation/register/register_view_model.dart'
    as _i30;
import 'package:v2x/features/home/data/di/home_data_source_module.dart' as _i40;
import 'package:v2x/features/home/data/remote/remote_home_data_source.dart'
    as _i8;
import 'package:v2x/features/home/data/repository/home_repository_impl.dart'
    as _i25;
import 'package:v2x/features/home/domain/repository/home_repository.dart'
    as _i24;
import 'package:v2x/features/home/domain/usecases/get_area_list_use_case.dart'
    as _i34;
import 'package:v2x/features/home/domain/usecases/get_vehicles_area_use_case.dart'
    as _i35;
import 'package:v2x/features/home/presentation/home_view_model.dart' as _i36;
import 'package:v2x/features/main/presentation/main_view_model.dart' as _i5;
import 'package:v2x/features/splash/splash_view_model.dart' as _i31;
import 'package:v2x/features/vehicles/data/di/vehicles_data_source_module.dart'
    as _i41;
import 'package:v2x/features/vehicles/data/remote/remote_vehicles_data_source.dart'
    as _i9;
import 'package:v2x/features/vehicles/data/repository/vehicles_repository_impl.dart'
    as _i15;
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart'
    as _i14;
import 'package:v2x/features/vehicles/domain/usecases/add_vehicle_use_case.dart'
    as _i16;
import 'package:v2x/features/vehicles/domain/usecases/delete_vehicle_use_case.dart'
    as _i19;
import 'package:v2x/features/vehicles/domain/usecases/edit_vehicle_use_case.dart'
    as _i20;
import 'package:v2x/features/vehicles/domain/usecases/get_vehicle_makers_use_case.dart'
    as _i22;
import 'package:v2x/features/vehicles/domain/usecases/get_vehicles_use_case.dart'
    as _i23;
import 'package:v2x/features/vehicles/domain/usecases/validate_add_vehicle_use_case.dart'
    as _i11;
import 'package:v2x/features/vehicles/presentation/addeditvehicle/add_edit_vehicle_view_model.dart'
    as _i33;
import 'package:v2x/features/vehicles/presentation/lookup/lookup_list_viewmodel.dart'
    as _i28;
import 'package:v2x/features/vehicles/presentation/vehicles_list_view_model.dart'
    as _i32;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    final storageModule = _$StorageModule();
    final authDataSourceModule = _$AuthDataSourceModule();
    final homeDataSourceModule = _$HomeDataSourceModule();
    final vehiclesDataSourceModule = _$VehiclesDataSourceModule();
    gh.lazySingleton<_i3.Dio>(() => networkModule.dio());
    gh.lazySingleton<_i4.FlutterSecureStorage>(
        () => storageModule.secureStorage());
    gh.factory<_i5.MainViewModel>(() => _i5.MainViewModel());
    gh.lazySingleton<_i6.MediaPickerHelper>(() => _i6.MediaPickerHelper());
    gh.lazySingleton<_i7.RemoteAuthDataSource>(
        () => authDataSourceModule.apiService(gh<_i3.Dio>()));
    gh.lazySingleton<_i8.RemoteHomeDataSource>(
        () => homeDataSourceModule.apiService(gh<_i3.Dio>()));
    gh.lazySingleton<_i9.RemoteVehiclesDataSource>(
        () => vehiclesDataSourceModule.apiService(gh<_i3.Dio>()));
    gh.lazySingleton<_i10.SecureStorageService>(
        () => _i10.SecureStorageService());
    gh.factory<_i11.ValidateAddVehicleUseCase>(
        () => _i11.ValidateAddVehicleUseCase());
    gh.factory<_i12.ValidateLoginUseCase>(() => _i12.ValidateLoginUseCase());
    gh.factory<_i13.ValidateRegisterUseCase>(
        () => _i13.ValidateRegisterUseCase());
    gh.factory<_i14.VehiclesRepository>(
        () => _i15.VehiclesRepositoryImpl(gh<_i9.RemoteVehiclesDataSource>()));
    gh.factory<_i16.AddVehicleUseCase>(
        () => _i16.AddVehicleUseCase(gh<_i14.VehiclesRepository>()));
    gh.factory<_i17.AuthRepository>(
        () => _i18.AuthRepositoryImpl(gh<_i7.RemoteAuthDataSource>()));
    gh.factory<_i19.DeleteVehicleUseCase>(
        () => _i19.DeleteVehicleUseCase(gh<_i14.VehiclesRepository>()));
    gh.factory<_i20.EditVehicleUseCase>(
        () => _i20.EditVehicleUseCase(gh<_i14.VehiclesRepository>()));
    gh.factory<_i21.GetUserApiUseCase>(
        () => _i21.GetUserApiUseCase(gh<_i17.AuthRepository>()));
    gh.factory<_i22.GetVehicleMakersUseCase>(
        () => _i22.GetVehicleMakersUseCase(gh<_i14.VehiclesRepository>()));
    gh.factory<_i23.GetVehiclesUseCase>(
        () => _i23.GetVehiclesUseCase(gh<_i14.VehiclesRepository>()));
    gh.factory<_i24.HomeRepository>(
        () => _i25.HomeRepositoryImpl(gh<_i8.RemoteHomeDataSource>()));
    gh.factory<_i26.LoginApiUseCase>(
        () => _i26.LoginApiUseCase(gh<_i17.AuthRepository>()));
    gh.factory<_i27.LoginViewModel>(() => _i27.LoginViewModel(
          gh<_i12.ValidateLoginUseCase>(),
          gh<_i26.LoginApiUseCase>(),
        ));
    gh.factory<_i28.LookupListViewModel>(
        () => _i28.LookupListViewModel(gh<_i22.GetVehicleMakersUseCase>()));
    gh.factory<_i29.RegisterApiUseCase>(
        () => _i29.RegisterApiUseCase(gh<_i17.AuthRepository>()));
    gh.factory<_i30.RegisterViewModel>(() => _i30.RegisterViewModel(
          gh<_i13.ValidateRegisterUseCase>(),
          gh<_i29.RegisterApiUseCase>(),
        ));
    gh.factory<_i31.SplashViewModel>(
        () => _i31.SplashViewModel(gh<_i21.GetUserApiUseCase>()));
    gh.factory<_i32.VehiclesListViewModel>(() => _i32.VehiclesListViewModel(
          gh<_i23.GetVehiclesUseCase>(),
          gh<_i19.DeleteVehicleUseCase>(),
        ));
    gh.factory<_i33.AddEditVehicleViewModel>(() => _i33.AddEditVehicleViewModel(
          gh<_i16.AddVehicleUseCase>(),
          gh<_i11.ValidateAddVehicleUseCase>(),
          gh<_i20.EditVehicleUseCase>(),
        ));
    gh.factory<_i34.GetAreaListUseCase>(
        () => _i34.GetAreaListUseCase(gh<_i24.HomeRepository>()));
    gh.factory<_i35.GetVehiclesAreaUseCase>(
        () => _i35.GetVehiclesAreaUseCase(gh<_i24.HomeRepository>()));
    gh.factory<_i36.HomeViewModel>(() => _i36.HomeViewModel(
          gh<_i34.GetAreaListUseCase>(),
          gh<_i35.GetVehiclesAreaUseCase>(),
        ));
    return this;
  }
}

class _$NetworkModule extends _i37.NetworkModule {}

class _$StorageModule extends _i38.StorageModule {}

class _$AuthDataSourceModule extends _i39.AuthDataSourceModule {}

class _$HomeDataSourceModule extends _i40.HomeDataSourceModule {}

class _$VehiclesDataSourceModule extends _i41.VehiclesDataSourceModule {}
