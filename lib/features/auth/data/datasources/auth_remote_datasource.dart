import 'package:injectable/injectable.dart';
import 'package:wallinice/core/constants/constants.dart';
import 'package:wallinice/core/errors/errors.dart';
import 'package:wallinice/core/network/network.dart';
import 'package:wallinice/features/auth/auth.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? username,
  });

  Future<UserModel> fetchMe();

  Future<void> deleteAccount(String id);

  Future<void> resetPassword(String email);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._networkClient);

  final NetworkClient _networkClient;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _networkClient.post(
        '${ApiConstants.customApiUrl}auth/local',
        data: {
          'identifier': email,
          'password': password,
        },
      );

      if (response.containsKey('jwt') && response.containsKey('user')) {
        return response;
      } else {
        throw AuthException(
          (response['error']['message'] as String?) ?? 'Invalid credentials',
        );
      }
    } on ServerException catch (e) {
      throw AuthException(e.message ?? 'Login failed');
    } on NetworkException catch (e) {
      throw AuthException(e.message ?? 'Network error');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      final response = await _networkClient.post(
        '${ApiConstants.customApiUrl}auth/local/register',
        data: {
          'email': email,
          'password': password,
          if (username != null) 'username': username,
        },
      );

      if (response.containsKey('jwt') && response.containsKey('user')) {
        return response;
      } else {
        throw AuthException(
          (response['error']['message'] as String?) ?? 'Registration failed',
        );
      }
    } on ServerException catch (e) {
      if (e.message?.contains('409') ?? false) {
        throw const AuthException('Email or username already taken');
      }
      throw AuthException(e.message ?? 'Registration failed');
    } on NetworkException catch (e) {
      throw AuthException(e.message ?? 'Network error');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> fetchMe() async {
    try {
      final response =
          await _networkClient.get('${ApiConstants.customApiUrl}users/me');
      return UserModel.fromJson(response);
    } on ServerException catch (e) {
      throw AuthException(e.message ?? 'Failed to fetch user data');
    } on NetworkException catch (e) {
      throw AuthException(e.message ?? 'Network error');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    try {
      await _networkClient.delete('${ApiConstants.customApiUrl}users/$id');
    } on ServerException catch (e) {
      throw AuthException(e.message ?? 'Failed to delete account');
    } on NetworkException catch (e) {
      throw AuthException(e.message ?? 'Network error');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _networkClient.post(
        '${ApiConstants.customApiUrl}auth/forgot-password',
        data: {'email': email},
      );
    } on ServerException catch (e) {
      throw AuthException(e.message ?? 'Failed to send reset password email');
    } on NetworkException catch (e) {
      throw AuthException(e.message ?? 'Network error');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}
