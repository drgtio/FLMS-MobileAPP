import 'package:injectable/injectable.dart';
import 'package:v2x/features/auth/data/remote/remote_auth_data_source.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/domain/repository/auth_repository.dart';
import 'package:v2x/features/auth/domain/utils/constant_auth.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource remoteAuthDataSource;

  AuthRepositoryImpl(this.remoteAuthDataSource);

  @override
  Future<UserEntity?> register(
    String phoneNumber,
    String firstName,
    String lastName,
    String email,
    String password,
    String userName,
  ) async {
    final response = await remoteAuthDataSource.register({
      ConstantAuth.phoneNumber: phoneNumber,
      ConstantAuth.firstName: firstName,
      ConstantAuth.lastName: lastName,
      ConstantAuth.email: email,
      ConstantAuth.password: password,
      ConstantAuth.userName: userName,
    });

    return response.data?.toEntity();
  }

  @override
  Future<UserEntity?> login(String userName, String password) async {
    final response = await remoteAuthDataSource.login({
      ConstantAuth.userName: userName,
      ConstantAuth.password: password,
    });

    return response.data?.toEntity();
  }

  @override
  Future<UserEntity?> getUser() async {
    final response = await remoteAuthDataSource.getUser();
    return response.data?.toEntity();
  }
}
