import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallhevan/store/store.dart' show StorageManger;
import 'cookie.dart';

Dio dio = Dio(BaseOptions(baseUrl: Api.url));

class Api {
  static String url = 'https://wallhaven.cc';

  static CookieJar cookieJar = CookieJar();
}

Future<Dio> initDio() async {
  final prefs = await StorageManger.prefs;
  return initDio0(prefs);
}

Dio initDio1(SharedPreferences prefs) {
  return initDio0(prefs);
}

Dio initDio0(SharedPreferences prefs) {
  List<String> cookieStr = [];
  List<String> cookieKeys = [
    'XSRF-TOKEN',
    'wallhaven_session',
    'remember_web',
  ];
  // cookieStr.addAll(cookieKeys.map((key) => prefs.getString(key)));
  for (String key in cookieKeys) {
    String? cookie = prefs.getString(key);
    if (cookie != null) {
      cookieStr.add(cookie);
    }
  }
  if (cookieStr.isNotEmpty) {
    List<Cookie> cookieList =
        cookieStr.map((str) => Cookie.fromSetCookieValue(str)).toList();
    Api.cookieJar.saveFromResponse(Uri.parse(Api.url), cookieList);
  }
  // Api.cookieJar.loadForRequest(Uri.parse('https://wallhaven.cc/auth/login')).then((cookies) {
  //   if (cookies.isNotEmpty) {
  //     List<String> cs = [];
  //     cs.addAll(cookies.map((e) => e.name));
  //     print('prefs  ${cs.toString()}');
  //   }
  // });
  dio.interceptors.add(HCookieManager(Api.cookieJar));
  return dio;
}

Future<Response> getPictureAPI(Map<String, dynamic> params) {
  return dio.get(
    '/api/v1/search',
    queryParameters: params,
  );
}

Future<Response> getCollectionsAPI(Map<String, dynamic> params) {
  return dio.get(
    '/api/v1/collections',
    queryParameters: params,
  );
}

Future<Response> getFavoritesAPI(Map<String, dynamic> params, int id) async {
  return dio.get(
    '/api/v1/collections/${await StorageManger.getUserName()}/$id',
    queryParameters: params,
  );
}
