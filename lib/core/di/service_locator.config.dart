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
import 'package:v2x/core/network/network_module.dart' as _i46;
import 'package:v2x/core/storage/secure_storage_user.dart' as _i11;
import 'package:v2x/core/storage/storage_module.dart' as _i47;
import 'package:v2x/core/utils/media_picker_helper.dart' as _i6;
import 'package:v2x/features/auth/data/di/auth_data_source_module.dart' as _i48;
import 'package:v2x/features/auth/data/remote/remote_auth_data_source.dart'
    as _i7;
import 'package:v2x/features/auth/data/repository/auth_repository_impl.dart'
    as _i20;
import 'package:v2x/features/auth/domain/repository/auth_repository.dart'
    as _i19;
import 'package:v2x/features/auth/domain/usecases/login/login_api_use_case.dart'
    as _i31;
import 'package:v2x/features/auth/domain/usecases/login/validate_login_use_case.dart'
    as _i14;
import 'package:v2x/features/auth/domain/usecases/register/register_api_use_case.dart'
    as _i34;
import 'package:v2x/features/auth/domain/usecases/register/validate_register_use_case.dart'
    as _i15;
import 'package:v2x/features/auth/domain/usecases/user/get_user_api_use_case.dart'
    as _i26;
import 'package:v2x/features/auth/presentation/login/login_view_model.dart'
    as _i32;
import 'package:v2x/features/auth/presentation/register/register_view_model.dart'
    as _i35;
import 'package:v2x/features/drivers/data/di/drivers_data_source_module.dart'
    as _i49;
import 'package:v2x/features/drivers/data/remote/remote_drivers_data_source.dart'
    as _i8;
import 'package:v2x/features/drivers/data/repository/drivers_repository_impl.dart'
    as _i23;
import 'package:v2x/features/drivers/domain/repository/drivers_repository.dart'
    as _i22;
import 'package:v2x/features/drivers/domain/usecases/add_driver_use_case.dart'
    as _i39;
import 'package:v2x/features/drivers/domain/usecases/get_drivers_use_case.dart'
    as _i25;
import 'package:v2x/features/drivers/domain/usecases/update_driver_use_case.dart'
    as _i37;
import 'package:v2x/features/drivers/domain/usecases/validate_add_driver_use_case.dart'
    as _i12;
import 'package:v2x/features/drivers/presentation/adddriver/add_driver_view_model.dart'
    as _i40;
import 'package:v2x/features/drivers/presentation/drivers_list_view_model.dart'
    as _i42;
import 'package:v2x/features/home/data/di/home_data_source_module.dart' as _i50;
import 'package:v2x/features/home/data/remote/remote_home_data_source.dart'
    as _i9;
import 'package:v2x/features/home/data/repository/home_repository_impl.dart'
    as _i30;
import 'package:v2x/features/home/domain/repository/home_repository.dart'
    as _i29;
import 'package:v2x/features/home/domain/usecases/get_area_list_use_case.dart'
    as _i43;
import 'package:v2x/features/home/domain/usecases/get_vehicles_area_use_case.dart'
    as _i44;
import 'package:v2x/features/home/presentation/home_view_model.dart' as _i45;
import 'package:v2x/features/main/presentation/main_view_model.dart' as _i5;
import 'package:v2x/features/splash/splash_view_model.dart' as _i36;
import 'package:v2x/features/vehicles/data/di/vehicles_data_source_module.dart'
    as _i51;
import 'package:v2x/features/vehicles/data/remote/remote_vehicles_data_source.dart'
    as _i10;
import 'package:v2x/features/vehicles/data/repository/vehicles_repository_impl.dart'
    as _i17;
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart'
    as _i16;
import 'package:v2x/features/vehicles/domain/usecases/add_vehicle_use_case.dart'
    as _i18;
import 'package:v2x/features/vehicles/domain/usecases/delete_vehicle_use_case.dart'
    as _i21;
import 'package:v2x/features/vehicles/domain/usecases/edit_vehicle_use_case.dart'
    as _i24;
import 'package:v2x/features/vehicles/domain/usecases/get_vehicle_makers_use_case.dart'
    as _i27;
import 'package:v2x/features/vehicles/domain/usecases/get_vehicles_use_case.dart'
    as _i28;
import 'package:v2x/features/vehicles/domain/usecases/validate_add_vehicle_use_case.dart'
    as _i13;
import 'package:v2x/features/vehicles/presentation/addeditvehicle/add_edit_vehicle_view_model.dart'
    as _i41;
import 'package:v2x/features/vehicles/presentation/lookup/lookup_list_viewmodel.dart'
    as _i33;
import 'package:v2x/features/vehicles/presentation/vehicles_list_view_model.dart'
    as _i38;

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
    final driversDataSourceModule = _$DriversDataSourceModule();
    final homeDataSourceModule = _$HomeDataSourceModule();
    final vehiclesDataSourceModule = _$VehiclesDataSourceModule();
    gh.lazySingleton<_i3.Dio>(() => networkModule.dio());
    gh.lazySingleton<_i4.FlutterSecureStorage>(
        () => storageModule.secureStorage());
    gh.factory<_i5.MainViewModel>(() => _i5.MainViewModel());
    gh.lazySingleton<_i6.MediaPickerHelper>(() => _i6.MediaPickerHelper());
    gh.lazySingleton<_i7.RemoteAuthDataSource>(
        () => authDataSourceModule.apiService(gh<_i3.Dio>()));
    gh.lazySingleton<_i8.RemoteDriversDataSource>(
        () => driversDataSourceModule.apiService(gh<_i3.Dio>()));
    gh.lazySingleton<_i9.RemoteHomeDataSource>(
        () => homeDataSourceModule.apiService(gh<_i3.Dio>()));
    gh.lazySingleton<_i10.RemoteVehiclesDataSource>(
        () => vehiclesDataSourceModule.apiService(gh<_i3.Dio>()));
    gh.lazySingleton<_i11.SecureStorageService>(
        () => _i11.SecureStorageService());
    gh.factory<_i12.ValidateAddDriverUseCase>(
        () => _i12.ValidateAddDriverUseCase());
    gh.factory<_i13.ValidateAddVehicleUseCase>(
        () => _i13.ValidateAddVehicleUseCase());
    gh.factory<_i14.ValidateLoginUseCase>(() => _i14.ValidateLoginUseCase());
    gh.factory<_i15.ValidateRegisterUseCase>(
        () => _i15.ValidateRegisterUseCase());
    gh.factory<_i16.VehiclesRepository>(
        () => _i17.VehiclesRepositoryImpl(gh<_i10.RemoteVehiclesDataSource>()));
    gh.factory<_i18.AddVehicleUseCase>(
        () => _i18.AddVehicleUseCase(gh<_i16.VehiclesRepository>()));
    gh.factory<_i19.AuthRepository>(
        () => _i20.AuthRepositoryImpl(gh<_i7.RemoteAuthDataSource>()));
    gh.factory<_i21.DeleteVehicleUseCase>(
        () => _i21.DeleteVehicleUseCase(gh<_i16.VehiclesRepository>()));
    gh.factory<_i22.DriversRepository>(
        () => _i23.DriversRepositoryImpl(gh<_i8.RemoteDriversDataSource>()));
    gh.factory<_i24.EditVehicleUseCase>(
        () => _i24.EditVehicleUseCase(gh<_i16.VehiclesRepository>()));
    gh.factory<_i25.GetDriversUseCase>(
        () => _i25.GetDriversUseCase(gh<_i22.DriversRepository>()));
    gh.factory<_i26.GetUserApiUseCase>(
        () => _i26.GetUserApiUseCase(gh<_i19.AuthRepository>()));
    gh.factory<_i27.GetVehicleMakersUseCase>(
        () => _i27.GetVehicleMakersUseCase(gh<_i16.VehiclesRepository>()));
    gh.factory<_i28.GetVehiclesUseCase>(
        () => _i28.GetVehiclesUseCase(gh<_i16.VehiclesRepository>()));
    gh.factory<_i29.HomeRepository>(
        () => _i30.HomeRepositoryImpl(gh<_i9.RemoteHomeDataSource>()));
    gh.factory<_i31.LoginApiUseCase>(
        () => _i31.LoginApiUseCase(gh<_i19.AuthRepository>()));
    gh.factory<_i32.LoginViewModel>(() => _i32.LoginViewModel(
          gh<_i14.ValidateLoginUseCase>(),
          gh<_i31.LoginApiUseCase>(),
        ));
    gh.factory<_i33.LookupListViewModel>(
        () => _i33.LookupListViewModel(gh<_i27.GetVehicleMakersUseCase>()));
    gh.factory<_i34.RegisterApiUseCase>(
        () => _i34.RegisterApiUseCase(gh<_i19.AuthRepository>()));
    gh.factory<_i35.RegisterViewModel>(() => _i35.RegisterViewModel(
          gh<_i15.ValidateRegisterUseCase>(),
          gh<_i34.RegisterApiUseCase>(),
        ));
    gh.factory<_i36.SplashViewModel>(
        () => _i36.SplashViewModel(gh<_i26.GetUserApiUseCase>()));
    gh.factory<_i37.UpdateDriverUseCase>(
        () => _i37.UpdateDriverUseCase(gh<_i22.DriversRepository>()));
    gh.factory<_i38.VehiclesListViewModel>(() => _i38.VehiclesListViewModel(
          gh<_i28.GetVehiclesUseCase>(),
          gh<_i21.DeleteVehicleUseCase>(),
        ));
    gh.factory<_i39.AddDriverUseCase>(
        () => _i39.AddDriverUseCase(gh<_i22.DriversRepository>()));
    gh.factory<_i40.AddDriverViewModel>(() => _i40.AddDriverViewModel(
          gh<_i39.AddDriverUseCase>(),
          gh<_i12.ValidateAddDriverUseCase>(),
          gh<_i37.UpdateDriverUseCase>(),
        ));
    gh.factory<_i41.AddEditVehicleViewModel>(() => _i41.AddEditVehicleViewModel(
          gh<_i18.AddVehicleUseCase>(),
          gh<_i13.ValidateAddVehicleUseCase>(),
          gh<_i24.EditVehicleUseCase>(),
        ));
    gh.factory<_i42.DriversListViewModel>(
        () => _i42.DriversListViewModel(gh<_i25.GetDriversUseCase>()));
    gh.factory<_i43.GetAreaListUseCase>(
        () => _i43.GetAreaListUseCase(gh<_i29.HomeRepository>()));
    gh.factory<_i44.GetVehiclesAreaUseCase>(
        () => _i44.GetVehiclesAreaUseCase(gh<_i29.HomeRepository>()));
    gh.factory<_i45.HomeViewModel>(() => _i45.HomeViewModel(
          gh<_i43.GetAreaListUseCase>(),
          gh<_i44.GetVehiclesAreaUseCase>(),
        ));
    return this;
  }
}

class _$NetworkModule extends _i46.NetworkModule {}

class _$StorageModule extends _i47.StorageModule {}

class _$AuthDataSourceModule extends _i48.AuthDataSourceModule {}

class _$DriversDataSourceModule extends _i49.DriversDataSourceModule {}

class _$HomeDataSourceModule extends _i50.HomeDataSourceModule {}

class _$VehiclesDataSourceModule extends _i51.VehiclesDataSourceModule {}
