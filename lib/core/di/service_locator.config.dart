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
import 'package:v2x/core/network/network_module.dart' as _i60;
import 'package:v2x/core/services/fcm/fcm_token_service.dart' as _i30;
import 'package:v2x/core/storage/secure_storage_user.dart' as _i12;
import 'package:v2x/core/storage/storage_module.dart' as _i61;
import 'package:v2x/core/utils/media_picker_helper.dart' as _i6;
import 'package:v2x/features/auth/data/di/auth_data_source_module.dart' as _i62;
import 'package:v2x/features/auth/data/remote/remote_auth_data_source.dart'
    as _i7;
import 'package:v2x/features/auth/data/repository/auth_repository_impl.dart'
    as _i23;
import 'package:v2x/features/auth/domain/repository/auth_repository.dart'
    as _i22;
import 'package:v2x/features/auth/domain/usecases/login/login_api_use_case.dart'
    as _i39;
import 'package:v2x/features/auth/domain/usecases/login/validate_login_use_case.dart'
    as _i15;
import 'package:v2x/features/auth/domain/usecases/register/register_api_use_case.dart'
    as _i44;
import 'package:v2x/features/auth/domain/usecases/register/validate_register_use_case.dart'
    as _i16;
import 'package:v2x/features/auth/domain/usecases/user/get_user_api_use_case.dart'
    as _i34;
import 'package:v2x/features/auth/presentation/login/login_view_model.dart'
    as _i40;
import 'package:v2x/features/auth/presentation/register/register_view_model.dart'
    as _i46;
import 'package:v2x/features/drivers/data/di/drivers_data_source_module.dart'
    as _i63;
import 'package:v2x/features/drivers/data/remote/remote_drivers_data_source.dart'
    as _i8;
import 'package:v2x/features/drivers/data/repository/drivers_repository_impl.dart'
    as _i28;
import 'package:v2x/features/drivers/domain/repository/drivers_repository.dart'
    as _i27;
import 'package:v2x/features/drivers/domain/usecases/add_driver_use_case.dart'
    as _i52;
import 'package:v2x/features/drivers/domain/usecases/get_drivers_use_case.dart'
    as _i33;
import 'package:v2x/features/drivers/domain/usecases/update_driver_use_case.dart'
    as _i49;
import 'package:v2x/features/drivers/domain/usecases/validate_add_driver_use_case.dart'
    as _i13;
import 'package:v2x/features/drivers/presentation/adddriver/add_driver_view_model.dart'
    as _i53;
import 'package:v2x/features/drivers/presentation/drivers_list_view_model.dart'
    as _i56;
import 'package:v2x/features/home/data/di/home_data_source_module.dart' as _i64;
import 'package:v2x/features/home/data/remote/remote_home_data_source.dart'
    as _i9;
import 'package:v2x/features/home/data/repository/home_repository_impl.dart'
    as _i38;
import 'package:v2x/features/home/domain/repository/home_repository.dart'
    as _i37;
import 'package:v2x/features/home/domain/usecases/get_area_list_use_case.dart'
    as _i57;
import 'package:v2x/features/home/domain/usecases/get_vehicles_area_use_case.dart'
    as _i58;
import 'package:v2x/features/home/presentation/home_view_model.dart' as _i59;
import 'package:v2x/features/main/presentation/main_view_model.dart' as _i5;
import 'package:v2x/features/notifications/data/di/notifications_data_source_module.dart'
    as _i65;
import 'package:v2x/features/notifications/data/remote/remote_notifications_data_source.dart'
    as _i10;
import 'package:v2x/features/notifications/data/repository/notifications_repository_impl.dart'
    as _i43;
import 'package:v2x/features/notifications/domain/repository/notifications_repository.dart'
    as _i42;
import 'package:v2x/features/notifications/domain/usecases/register_device_use_case.dart'
    as _i45;
import 'package:v2x/features/splash/splash_view_model.dart' as _i48;
import 'package:v2x/features/vehicles/data/di/vehicles_data_source_module.dart'
    as _i66;
import 'package:v2x/features/vehicles/data/remote/remote_vehicles_data_source.dart'
    as _i11;
import 'package:v2x/features/vehicles/data/repository/vehicles_repository_impl.dart'
    as _i18;
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart'
    as _i17;
import 'package:v2x/features/vehicles/domain/usecases/add_vehicle_use_case.dart'
    as _i19;
import 'package:v2x/features/vehicles/domain/usecases/assign_device_use_case.dart'
    as _i20;
import 'package:v2x/features/vehicles/domain/usecases/assign_vehicle_use_case.dart'
    as _i21;
import 'package:v2x/features/vehicles/domain/usecases/create_device_use_case.dart'
    as _i24;
import 'package:v2x/features/vehicles/domain/usecases/delete_device_use_case.dart'
    as _i25;
import 'package:v2x/features/vehicles/domain/usecases/delete_vehicle_use_case.dart'
    as _i26;
import 'package:v2x/features/vehicles/domain/usecases/edit_vehicle_use_case.dart'
    as _i29;
import 'package:v2x/features/vehicles/domain/usecases/get_device_by_serial_use_case.dart'
    as _i31;
import 'package:v2x/features/vehicles/domain/usecases/get_devices_use_case.dart'
    as _i32;
import 'package:v2x/features/vehicles/domain/usecases/get_vehicle_makers_use_case.dart'
    as _i35;
import 'package:v2x/features/vehicles/domain/usecases/get_vehicles_use_case.dart'
    as _i36;
import 'package:v2x/features/vehicles/domain/usecases/relay_control_use_case.dart'
    as _i47;
import 'package:v2x/features/vehicles/domain/usecases/validate_add_vehicle_use_case.dart'
    as _i14;
import 'package:v2x/features/vehicles/presentation/addeditvehicle/add_edit_vehicle_view_model.dart'
    as _i54;
import 'package:v2x/features/vehicles/presentation/assignment/assign_vehicle_view_model.dart'
    as _i55;
import 'package:v2x/features/vehicles/presentation/controller/vehicle_controller_view_model.dart'
    as _i50;
import 'package:v2x/features/vehicles/presentation/lookup/lookup_list_viewmodel.dart'
    as _i41;
import 'package:v2x/features/vehicles/presentation/vehicles_list_view_model.dart'
    as _i51;

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
    final notificationsDataSourceModule = _$NotificationsDataSourceModule();
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
    gh.lazySingleton<_i10.RemoteNotificationsDataSource>(() =>
        notificationsDataSourceModule.notificationsDataSource(gh<_i3.Dio>()));
    gh.lazySingleton<_i11.RemoteVehiclesDataSource>(
        () => vehiclesDataSourceModule.apiService(gh<_i3.Dio>()));
    gh.lazySingleton<_i12.SecureStorageService>(
        () => _i12.SecureStorageService());
    gh.factory<_i13.ValidateAddDriverUseCase>(
        () => _i13.ValidateAddDriverUseCase());
    gh.factory<_i14.ValidateAddVehicleUseCase>(
        () => _i14.ValidateAddVehicleUseCase());
    gh.factory<_i15.ValidateLoginUseCase>(() => _i15.ValidateLoginUseCase());
    gh.factory<_i16.ValidateRegisterUseCase>(
        () => _i16.ValidateRegisterUseCase());
    gh.factory<_i17.VehiclesRepository>(
        () => _i18.VehiclesRepositoryImpl(gh<_i11.RemoteVehiclesDataSource>()));
    gh.factory<_i19.AddVehicleUseCase>(
        () => _i19.AddVehicleUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i20.AssignDeviceUseCase>(
        () => _i20.AssignDeviceUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i21.AssignVehicleUseCase>(
        () => _i21.AssignVehicleUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i22.AuthRepository>(
        () => _i23.AuthRepositoryImpl(gh<_i7.RemoteAuthDataSource>()));
    gh.factory<_i24.CreateDeviceUseCase>(
        () => _i24.CreateDeviceUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i25.DeleteDeviceUseCase>(
        () => _i25.DeleteDeviceUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i26.DeleteVehicleUseCase>(
        () => _i26.DeleteVehicleUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i27.DriversRepository>(
        () => _i28.DriversRepositoryImpl(gh<_i8.RemoteDriversDataSource>()));
    gh.factory<_i29.EditVehicleUseCase>(
        () => _i29.EditVehicleUseCase(gh<_i17.VehiclesRepository>()));
    gh.lazySingleton<_i30.FcmTokenService>(
        () => _i30.FcmTokenService(gh<_i12.SecureStorageService>()));
    gh.factory<_i31.GetDeviceBySerialUseCase>(
        () => _i31.GetDeviceBySerialUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i32.GetDevicesUseCase>(
        () => _i32.GetDevicesUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i33.GetDriversUseCase>(
        () => _i33.GetDriversUseCase(gh<_i27.DriversRepository>()));
    gh.factory<_i34.GetUserApiUseCase>(
        () => _i34.GetUserApiUseCase(gh<_i22.AuthRepository>()));
    gh.factory<_i35.GetVehicleMakersUseCase>(
        () => _i35.GetVehicleMakersUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i36.GetVehiclesUseCase>(
        () => _i36.GetVehiclesUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i37.HomeRepository>(
        () => _i38.HomeRepositoryImpl(gh<_i9.RemoteHomeDataSource>()));
    gh.factory<_i39.LoginApiUseCase>(
        () => _i39.LoginApiUseCase(gh<_i22.AuthRepository>()));
    gh.factory<_i40.LoginViewModel>(() => _i40.LoginViewModel(
          gh<_i15.ValidateLoginUseCase>(),
          gh<_i39.LoginApiUseCase>(),
        ));
    gh.factory<_i41.LookupListViewModel>(
        () => _i41.LookupListViewModel(gh<_i35.GetVehicleMakersUseCase>()));
    gh.factory<_i42.NotificationsRepository>(() =>
        _i43.NotificationsRepositoryImpl(
            gh<_i10.RemoteNotificationsDataSource>()));
    gh.factory<_i44.RegisterApiUseCase>(
        () => _i44.RegisterApiUseCase(gh<_i22.AuthRepository>()));
    gh.factory<_i45.RegisterDeviceUseCase>(
        () => _i45.RegisterDeviceUseCase(gh<_i42.NotificationsRepository>()));
    gh.factory<_i46.RegisterViewModel>(() => _i46.RegisterViewModel(
          gh<_i16.ValidateRegisterUseCase>(),
          gh<_i44.RegisterApiUseCase>(),
        ));
    gh.factory<_i47.RelayControlUseCase>(
        () => _i47.RelayControlUseCase(gh<_i17.VehiclesRepository>()));
    gh.factory<_i48.SplashViewModel>(
        () => _i48.SplashViewModel(gh<_i34.GetUserApiUseCase>()));
    gh.factory<_i49.UpdateDriverUseCase>(
        () => _i49.UpdateDriverUseCase(gh<_i27.DriversRepository>()));
    gh.factory<_i50.VehicleControllerViewModel>(
        () => _i50.VehicleControllerViewModel(
              gh<_i31.GetDeviceBySerialUseCase>(),
              gh<_i32.GetDevicesUseCase>(),
              gh<_i20.AssignDeviceUseCase>(),
              gh<_i24.CreateDeviceUseCase>(),
              gh<_i25.DeleteDeviceUseCase>(),
              gh<_i47.RelayControlUseCase>(),
            ));
    gh.factory<_i51.VehiclesListViewModel>(() => _i51.VehiclesListViewModel(
          gh<_i36.GetVehiclesUseCase>(),
          gh<_i26.DeleteVehicleUseCase>(),
        ));
    gh.factory<_i52.AddDriverUseCase>(
        () => _i52.AddDriverUseCase(gh<_i27.DriversRepository>()));
    gh.factory<_i53.AddDriverViewModel>(() => _i53.AddDriverViewModel(
          gh<_i52.AddDriverUseCase>(),
          gh<_i13.ValidateAddDriverUseCase>(),
          gh<_i49.UpdateDriverUseCase>(),
        ));
    gh.factory<_i54.AddEditVehicleViewModel>(() => _i54.AddEditVehicleViewModel(
          gh<_i19.AddVehicleUseCase>(),
          gh<_i14.ValidateAddVehicleUseCase>(),
          gh<_i29.EditVehicleUseCase>(),
        ));
    gh.factory<_i55.AssignVehicleViewModel>(() => _i55.AssignVehicleViewModel(
          gh<_i21.AssignVehicleUseCase>(),
          gh<_i33.GetDriversUseCase>(),
        ));
    gh.factory<_i56.DriversListViewModel>(
        () => _i56.DriversListViewModel(gh<_i33.GetDriversUseCase>()));
    gh.factory<_i57.GetAreaListUseCase>(
        () => _i57.GetAreaListUseCase(gh<_i37.HomeRepository>()));
    gh.factory<_i58.GetVehiclesAreaUseCase>(
        () => _i58.GetVehiclesAreaUseCase(gh<_i37.HomeRepository>()));
    gh.factory<_i59.HomeViewModel>(() => _i59.HomeViewModel(
          gh<_i57.GetAreaListUseCase>(),
          gh<_i58.GetVehiclesAreaUseCase>(),
        ));
    return this;
  }
}

class _$NetworkModule extends _i60.NetworkModule {}

class _$StorageModule extends _i61.StorageModule {}

class _$AuthDataSourceModule extends _i62.AuthDataSourceModule {}

class _$DriversDataSourceModule extends _i63.DriversDataSourceModule {}

class _$HomeDataSourceModule extends _i64.HomeDataSourceModule {}

class _$NotificationsDataSourceModule
    extends _i65.NotificationsDataSourceModule {}

class _$VehiclesDataSourceModule extends _i66.VehiclesDataSourceModule {}
