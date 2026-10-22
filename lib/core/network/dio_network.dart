import 'package:dio/dio.dart';

import '../../features/auth/data/data_sources/local/auth_shared_prefs.dart';
import '../helper/helper.dart';
import '../utils/app_events.dart';
import '../utils/constant/network_constant.dart';
import '../utils/injections.dart';
import '../utils/log/app_logger.dart';
import 'api_client.dart';
import 'logger_interceptor.dart';

class DioNetwork {
  static late Dio appAPI;
  static late Dio retryAPI;
  static late ApiClient apiClient;

  /// Bare client for `/auth/refresh`, so a refresh never re-enters the auth
  /// interceptor.
  static late Dio _refreshAPI;

  /// One refresh in flight at a time; concurrent 401s wait for it.
  static Future<_RefreshResult>? _refreshing;

  static const _retriedKey = 'auth_retried';

  static void initDio() {
    appAPI = Dio(baseOptions(apiBaseUrl));
    appAPI.interceptors.add(loggerInterceptor());
    appAPI.interceptors.add(authInterceptor());

    retryAPI = Dio(baseOptions(apiBaseUrl));
    retryAPI.interceptors.add(loggerInterceptor());
    retryAPI.interceptors.add(unauthInterceptor());

    _refreshAPI = Dio(baseOptions(apiBaseUrl));

    apiClient = ApiClient(appAPI, retryAPI);
  }

  static LoggerInterceptor loggerInterceptor() {
    return LoggerInterceptor(
      logger,
      request: true,
      requestBody: true,
      error: true,
      responseBody: true,
      responseHeader: false,
      requestHeader: false,
    );
  }

  static InterceptorsWrapper authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final headers = Helper.getHeaders();
        options.headers.addAll(headers);
        return handler.next(options);
      },
      onError: (error, handler) async {
        final options = error.requestOptions;
        final sentToken = options.headers.containsKey('Authorization');
        if (error.response?.statusCode != 401 ||
            !sentToken ||
            options.path.startsWith('/auth/') ||
            options.extra[_retriedKey] == true) {
          return handler.next(error);
        }

        // Access tokens live 15 minutes: refresh once, then replay the request.
        final refresh = await _refreshTokens();
        if (refresh == _RefreshResult.refreshed) {
          try {
            options.extra[_retriedKey] = true;
            options.headers.addAll(Helper.getHeaders());
            return handler.resolve(await appAPI.fetch(options));
          } on DioException catch (e) {
            return handler.next(e);
          }
        }

        // Offline or server hiccup: keep the session and surface the error;
        // the next request will try again.
        if (refresh == _RefreshResult.unavailable) return handler.next(error);

        await _handleUnauthorized();
        // Discovery works signed out: replay it as a guest instead of failing.
        if (_isPublicPath(options.path)) {
          try {
            options.extra[_retriedKey] = true;
            options.headers.remove('Authorization');
            return handler.resolve(await appAPI.fetch(options));
          } on DioException catch (e) {
            return handler.next(e);
          }
        }
        return handler.next(error);
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
    );
  }

  /// Public endpoints. Guests browse the map before signing up (C1).
  static bool _isPublicPath(String path) {
    return path.startsWith('/categories') || path.startsWith('/businesses') || path.startsWith('/program-templates');
  }

  static InterceptorsWrapper unauthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Deliberately no Authorization header — a stale token on a public
        // endpoint would turn an anonymous read into a 401.
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      },
      onError: (error, handler) async {
        return handler.next(error);
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
    );
  }

  static Future<_RefreshResult> _refreshTokens() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  static Future<_RefreshResult> _doRefresh() async {
    final prefs = sl<AuthSharedPrefs>();
    final sent = prefs.getRefreshToken();
    if (sent == null) return _RefreshResult.rejected;
    try {
      final response = await _refreshAPI.post(authRefreshPath, data: {'refreshToken': sent});
      final data = response.data;
      if (data is! Map || data['accessToken'] == null || data['refreshToken'] == null) {
        return _RefreshResult.unavailable;
      }
      await prefs.setTokens(access: data['accessToken'].toString(), refresh: data['refreshToken'].toString());
      return _RefreshResult.refreshed;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        // Refresh tokens are single-use. If another refresh already rotated
        // the pair (a race across requests), use that instead of signing out.
        final current = prefs.getRefreshToken();
        if (current != null && current != sent) return _RefreshResult.refreshed;
        return _RefreshResult.rejected;
      }
      return _RefreshResult.unavailable;
    } catch (_) {
      return _RefreshResult.unavailable;
    }
  }

  static Future<void> _handleUnauthorized() async {
    try {
      await sl<AuthSharedPrefs>().clearSession();
    } catch (_) {
      // GetIt may not be ready yet
    }
    // Signed-out users fall back to the guest customer app, not a login wall:
    // sign-in is asked for on the next Pay or Scan.
    AppEvents.notifySessionExpired();
  }

  static BaseOptions baseOptions(String url) {
    return BaseOptions(
      baseUrl: url,
      // The dev API on Render can cold-start; give it time on the first call.
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      validateStatus: (s) => s != null && s >= 200 && s < 300,
      responseType: ResponseType.json,
    );
  }
}

enum _RefreshResult {
  refreshed,

  /// The server rejected the refresh token: the session is over.
  rejected,

  /// Network or server trouble: keep the session and try again later.
  unavailable,
}
