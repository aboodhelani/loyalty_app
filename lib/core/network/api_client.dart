import 'package:dio/dio.dart';

import 'error/exceptions.dart';

class ApiClient {
  final Dio _dio;

  /// Client for public endpoints such as `/auth/*` and the explore listing.
  /// It does not force a logout on 401, so browsing without an account keeps
  /// working when a stale token is around.
  final Dio? _publicDio;

  ApiClient(this._dio, [this._publicDio]);

  Dio _clientFor(bool skipAuth) => skipAuth ? (_publicDio ?? _dio) : _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    return _request(
      () => _clientFor(skipAuth).get(path, queryParameters: queryParameters),
    );
  }

  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    return _requestList(
      () => _clientFor(skipAuth).get(path, queryParameters: queryParameters),
    );
  }

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    return _request(
      () => _clientFor(skipAuth).post(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    return _request(
      () => _clientFor(skipAuth).put(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    return _request(() => _clientFor(skipAuth).patch(path, data: data, queryParameters: queryParameters));
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    return _request(
      () => _clientFor(skipAuth).delete(path, data: data, queryParameters: queryParameters),
    );
  }

  /// Unwraps a paginated `{ items, total, page, pageSize }` response.
  Future<List<dynamic>> getItems(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    final json = await get(path, queryParameters: queryParameters, skipAuth: skipAuth);
    final items = json['items'];
    return items is List ? items : <dynamic>[];
  }

  Future<Map<String, dynamic>> _request(
    Future<Response> Function() requestFn,
  ) async {
    return _guard(() async {
      final response = await requestFn();
      final data = response.data;
      // 204 No Content, or an empty body on a 2xx, is a success with nothing
      // to parse.
      if (data == null || (data is String && data.trim().isEmpty)) {
        return <String, dynamic>{};
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      throw ServerException('Invalid response format', response.statusCode);
    }, 'Request failed');
  }

  Future<List<dynamic>> _requestList(
    Future<Response> Function() requestFn,
  ) async {
    return _guard(() async {
      final response = await requestFn();
      final data = response.data;
      if (data == null || (data is String && data.trim().isEmpty)) {
        return <dynamic>[];
      }
      if (data is List) {
        return data;
      }
      throw ServerException('Invalid response format', response.statusCode);
    }, 'Request failed');
  }

  /// Runs [fn], normalising Dio errors into the app's exception types.
  Future<T> _guard<T>(Future<T> Function() fn, String fallback) async {
    try {
      return await fn();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw CancelTokenException(
          handleDioError(e, 'Request cancelled'),
          e.response?.statusCode,
        );
      }
      final body = e.response?.data;
      throw ServerException(
        handleDioError(e, fallback),
        e.response?.statusCode,
        code: body is Map ? body['code']?.toString() : null,
        details: body is Map ? body['details'] : null,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}

String handleDioError(DioException error, String fallback) {
  if (error.response?.data is Map) {
    final data = error.response!.data as Map;
    if (data['message'] != null) return data['message'].toString();
    if (data['msg'] != null) return data['msg'].toString();
    if (data['error'] != null) return data['error'].toString();
  }
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timeout';
    case DioExceptionType.badResponse:
      return 'Server error (${error.response?.statusCode})';
    case DioExceptionType.cancel:
      return 'Request cancelled';
    case DioExceptionType.connectionError:
      return 'No internet connection';
    default:
      return error.message ?? fallback;
  }
}
