import 'dart:async';
import 'dart:convert';

import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/utils/check_status_connection.dart';
import 'package:dio/dio.dart' as doi;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart' as uhttp;
import 'package:universal_platform/universal_platform.dart';
// import 'dart:html' as htp;

class ResponseUniversal {
  String responseBody;
  int statusCode;
  Map<String, String> headers;

  ResponseUniversal({this.responseBody, this.statusCode, this.headers});
}

class NetworkUtil {
  static StreamSubscription _connectionChangeStream;
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = NetworkUtil.internal();
  static bool hasInternet = true;
  String finalCookie = '';
  final httpClient = uhttp.HttpClient();
  NetworkUtil.internal();
  factory NetworkUtil() {
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);

    if (hasInternet) return _instance;
    return null;
  }

  static void connectionChanged(dynamic hasConnection) {
    hasInternet = hasConnection;
  }

  void _updateCookieViaDio(doi.Response response) {
    List<String> allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      cookie = allSetCookie;

      // var setCookies = allSetCookie.split(';');

      //var setCookies = allSetCookie.split(',');

      for (var setCookie in allSetCookie) {
        var setCookies = setCookie.split(';');
        for (var sc in setCookies) {
          if (sc.startsWith('ClientId') || sc.startsWith('Vision_AUTH')) {
            _setCookie(sc);
          } else {
            var cookies = setCookie.split(',');
            for (var cookie in cookies) {
              if (!cookie.startsWith('ClientId')) _setCookie(cookie);
            }
          }
        }
      }

      //headers['cookie'] = _generateCookieHeader();
    }
  }

  void _updateCookieList(uhttp.HttpClientResponse response) {
    List<String> allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      cookie = allSetCookie;

      // var setCookies = allSetCookie.split(';');

      //var setCookies = allSetCookie.split(',');

      for (var setCookie in allSetCookie) {
        var setCookies = setCookie.split(';');
        for (var sc in setCookies) {
          if (sc.startsWith('ClientId') || sc.startsWith('Vision_AUTH')) {
            _setCookie(sc);
          } else {
            var cookies = setCookie.split(',');
            for (var cookie in cookies) {
              if (!cookie.startsWith('ClientId')) _setCookie(cookie);
            }
          }
        }
      }

      //headers['cookie'] = _generateCookieHeader();
    }
  }

  void _updateCookie(ResponseUniversal response) {
    final allSetCookie = response.headers['set-cookie'];
    //String allSetCookie =hdrs
    if (allSetCookie != null) {
      cooki2 = allSetCookie.toString();

      var setCookies = allSetCookie.split(';');

      // var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        //var setCookies = setCookie.split(';');
        if (setCookie.startsWith('ClientId')) {
          _setCookie(setCookie);
        } else {
          var cookies = setCookie.split(',');
          for (var cookie in cookies) {
            //if(!cookie.startsWith('ClientId'))
            _setCookie(cookie);
          }
        }
      }

      //headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        this.cookies[key] = value;
      }
    }
  }

  Future<String> getToken() async {
    String vision_auth = await userRepository.getCookie();
    String v_clientId = await userRepository.getCookieClientId();
    token = vision_auth;
    clientId = v_clientId;
    //return vision_auth;
    /*if(token==null || token.isEmpty)
      return defaultAdminToken;*/
    return prefix_clientid + v_clientId + ";" + prefix_token + vision_auth;
  }

  String getCookie() {
    return prefix_clientid + clientId + ";" + prefix_token + token;
  }

  Future<ResponseUniversal> doFetch(Uri uri, String url,
      Map<String, String> headers, String metod, String bodyy) async {
    var response;
    final head = headers;
    bool isIos = UniversalPlatform.isIOS;
    bool isAndroid = UniversalPlatform.isAndroid;

    bool isWeb = UniversalPlatform.isWeb;

    if (isWeb != null && isWeb) {
      // var oReq1 = await htp.HttpRequest.request(url,
      //     method: metod == null ? "GET" : metod,
      //     withCredentials: true,
      //     sendData: (metod != null && metod == 'POST') ? bodyy : null,
      //     onProgress: (_) => null,
      //     //responseType: content,
      //     requestHeaders: head);
      //
      // String body = await oReq1.responseText.toString();
      // int statusCode = await oReq1.status;
      // var headers = await oReq1.responseHeaders;
      // var rs = await oReq1.response.toString();
      // ResponseUniversal responseUniversal= ResponseUniversal(
      //  responseBody: body, statusCode: statusCode, headers: headers);
      // return responseUniversal;
    } else {
      if (metod == null || metod == 'GET') {
        http.Response responsee =
            await http.get(uri == null ? url : uri, headers: head);
        ResponseUniversal responseUniversal = ResponseUniversal(
            responseBody: responsee.body,
            statusCode: responsee.statusCode,
            headers: responsee.headers);
        return responseUniversal;
      } else if (metod == 'POST') {
        http.Response responsee = await http.post(
          url,
          headers: head,
          body: bodyy,
        );
        ResponseUniversal responseUniversal = ResponseUniversal(
            responseBody: responsee.body,
            statusCode: responsee.statusCode,
            headers: responsee.headers);
        return responseUniversal;
      }
    }
  }

  String defaultAdminToken =
      'ClientId=UUUU,84132484-0f04-4989-a769-cfa68e43b3d1; ASP.NET_SessionId=xeepdbdibbhxqzrkbs3gyj0f; Vision_AUTH=9FDD19519F4B52490B657BD137E2F22218FE3267753DDEF25B9BA40F8C4D8290618665D5838EFF1E33EB24D9EF4137230EA13E25F37A04060290FC9DCD0B703B6B142666C3B5F89F2E8FA41F7CA6D7F6FFE4C0B6C45620AE0F30119F9E86F90C0F906CCB80E6BB0B950DF2C68DC5123DB3A57E7E697E03B46A9E8B1EC5D7578CB60C87773D51B3D5E1265BB40B01C96B9D2AFFFC0E85CAE429678992B29D03B61893C0FFC852BA6112DD6B09E8A39864C5A4AAFA45605133FF6CAB68D27DC056';

  final JsonDecoder _decoder = new JsonDecoder();
  final JsonEncoder _encoder = new JsonEncoder();

  static String content = "application/json; charset=UTF-8";
  static List<String> cookie = new List();
  String cooki2;
  static String token = "";
  static String clientId = "";
  static String expire = "";

  static String prefix_token = "Vision_AUTH=";
  static String prefix_clientid = "ClientId=";

  static Map<String, String> fheaders = Map();
  Map<String, String> cookies = {};

  UserRepository userRepository = UserRepository();

  Future<T> getUriWithCooki<T>(Uri uri, {Map<String, String> theaders}) async {
    ResponseUniversal response;

    // if (hasInternet) {
    if (theaders == null) {
      fheaders.putIfAbsent("Content-Type", () => content);
    }

    fheaders.putIfAbsent('Cookie',
        () => (token != null && token.isNotEmpty) ? getCookie() : getToken());

    if (fheaders.containsKey("content-type")) fheaders.remove("content-type");

    response = await doFetch(
        uri, '', theaders == null ? fheaders : theaders, 'GET', '');
    final String res = response.responseBody;
    final int statusCode = response.statusCode;
    final Map<String, String> headers = response.headers;
    // return http
    //     .get(uri, headers: theaders == null ? fheaders : theaders)
    //     .then((http.Response response) {
    //   final String res = response.body;
    //   final int statusCode = response.statusCode;
    //   final Map<String, String> headers = response.headers;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(res /*Translations.current.errorFetchData()*/);
    }

    return _decoder.convert(res);
    // });
    // } else {}
  }

  Future<T> getUri<T>(Uri uri, {Map<String, String> theaders}) async {
    ResponseUniversal response;
    if (theaders == null) {
      fheaders.putIfAbsent("Content-Type", () => content);
    }
    if (fheaders != null && fheaders.containsKey('Cookie'))
      fheaders.remove('Cookie');
    if (fheaders.containsKey("content-type")) fheaders.remove("content-type");

    //fheaders.putIfAbsent('Cookie', ()=>token.isNotEmpty ? getCookie() :  getToken());
    // return http
    //     .get(uri, headers: theaders == null ? fheaders : theaders)
    //     .then((http.Response response) {
    response = await doFetch(
        uri, '', theaders == null ? fheaders : theaders, 'GET', '');
    final String res = response.responseBody;
    final int statusCode = response.statusCode;
    final Map<String, String> headers = response.headers;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(res /*Translations.current.errorFetchData()*/);
    }

    if (headers["set-cookie"] != null && headers["set-cookie"].isNotEmpty) {
      _updateCookie(response);
      token = cookies['Vision_AUTH'];
      clientId = cookies['ClientId'];

      if (token != null && clientId != null) {
        userRepository.persistCookie(token, clientId);
      }
    }
    return _decoder.convert(res);
  }

  Future<T> getWithDio<T>(String url,
      {Map<String, String> theaders, Map<String, String> params}) async {
    // var response;
    doi.Response response;
    if (theaders == null) {
      theaders = Map();
    }
    //theaders.putIfAbsent("Access-Control-Allow-Origin", () => "*");
    doi.BaseOptions options = doi.BaseOptions(
        connectTimeout: 50000,
        //   receiveTimeout: 30000,
        contentType: "application/json; charset=UTF-8",
        responseType: doi.ResponseType.json);
    doi.Dio dio = doi.Dio(options);
    response = await dio.get(url,
        queryParameters: params,
        options: doi.Options(headers: theaders, method: 'GET'));

    final headers = response.headers;
    var res = await response.data;
    final int statusCode = await response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(Translations.current.errorFetchData());
    }
    // doi.Headers headers = await response.headers;
    if (headers["set-cookie"] != null && headers["set-cookie"].isNotEmpty) {
      _updateCookieViaDio(response);

      token = cookies['Vision_AUTH'];
      clientId = cookies['ClientId'];

      if (token != null && clientId != null) {
        await userRepository.persistCookie(token, clientId);
      }
    }
    return res;
  }

  Future<T> get<T>(String url,
      {Map<String, String> theaders, String body}) async {
    ResponseUniversal response;
    if (theaders == null) {
      fheaders.putIfAbsent("Content-Type", () => content);
      //fheaders.putIfAbsent("Accept", () => "*/*");
      //fheaders.putIfAbsent("Accept-Encoding", () => "gzip, deflate, br");
      //fheaders.putIfAbsent("Connection", () => "keep-alive");
      //fheaders.putIfAbsent("Access-Control-Allow-Origin", () => "*");
      //fheaders.putIfAbsent("Access-Control-Allow-Headers",
      // () => "Origin, X-Requested-With, Content-Type, Accept");
    } else {
      // theaders.putIfAbsent("Accept", () => "*/*");
      /* theaders.putIfAbsent("Accept-Encoding", () => "gzip, deflate, br");
      theaders.putIfAbsent("Connection", () => "keep-alive");
      theaders.putIfAbsent("Access-Control-Allow-Origin", () => "*");
      theaders.putIfAbsent("Access-Control-Allow-Headers",
          () => "Origin, X-Requested-With, Content-Type, Accept");*/
    }

    if (token == null || token.isEmpty) finalCookie = await getToken();
    if (fheaders.containsKey('Cookie')) {
      fheaders.update(
          'Cookie',
          (value) =>
              (token != null && token.isNotEmpty) ? getCookie() : finalCookie);
    } else {
      fheaders.putIfAbsent(
          'Cookie',
          () =>
              (token != null && token.isNotEmpty) ? getCookie() : finalCookie);
    }
    if (fheaders.containsKey("content-type")) fheaders.remove("content-type");

    response = await doFetch(
        null, url, theaders == null ? fheaders : theaders, 'GET', null);

    final String resBody = response.responseBody.toString();
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(response);
    }
    var headers = response.headers;
    if (headers["set-cookie"] != null && headers["set-cookie"].isNotEmpty) {
      _updateCookie(response);

      token = cookies['Vision_AUTH'];
      clientId = cookies['ClientId'];

      if (token != null && clientId != null) {
        await userRepository.persistCookie(token, clientId);
      }
    }
    return _decoder.convert(resBody);
  }

  Future<T> getWithNoToken<T>(String url,
      {Map<String, String> theaders, String body}) async {
    ResponseUniversal response;
    if (theaders == null) {
      // fheaders.putIfAbsent("Content-Type", () => content);
    }

    if (fheaders != null && fheaders.containsKey("Cookie")) {
      fheaders.remove("Cookie");
    }

    //fheaders.putIfAbsent('Cookie', ()=>(token!=null && token.isNotEmpty) ? getCookie() :  finalCookie);
    if (fheaders.containsKey('Cookie')) {
      fheaders.update(
          'Cookie',
          (value) =>
              (token != null && token.isNotEmpty) ? getCookie() : finalCookie);
    } else {
      fheaders.putIfAbsent(
          'Cookie',
          () =>
              (token != null && token.isNotEmpty) ? getCookie() : finalCookie);
    }
    if (fheaders.containsKey("content-type")) fheaders.remove("content-type");

    response = await doFetch(
        null, url, theaders == null ? fheaders : theaders, 'GET', '');
    final String res = response.responseBody;
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(res);
    }
    return _decoder.convert(res);
    //});
  }

  Future<T> post<T>(String url,
      {Map<String, String> headers,
      Map<String, dynamic> body,
      Encoding encoding}) async {
    ResponseUniversal response;
    fheaders.putIfAbsent("Content-Type", () => content);
    if (token == null || token.isEmpty) finalCookie = await getToken();

    if (fheaders.containsKey('Cookie')) {
      fheaders.update(
          'Cookie',
          (value) =>
              (token != null && token.isNotEmpty) ? getCookie() : finalCookie);
    } else {
      fheaders.putIfAbsent(
          'Cookie',
          () =>
              (token != null && token.isNotEmpty) ? getCookie() : finalCookie);
    }
    if (fheaders.containsKey("content-type")) fheaders.remove("content-type");

    response =
        await doFetch(null, url, fheaders, 'POST', _encoder.convert(body));
    final String res = response.responseBody.toString();
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(Translations.current.errorFetchData());
    }
    return _decoder.convert(res);
    //});
  }

  Future<T> postWithParams<T>(String url,
      {Map<String, String> headers,
      Map<String, String> body,
      Encoding encoding}) async {
    ResponseUniversal response;
    //fheaders.putIfAbsent("Content-Type", () => content);
    if (token == null || token.isEmpty) finalCookie = await getToken();

    // fheaders.putIfAbsent('Cookie', ()=>(token!=null && token.isNotEmpty) ? getCookie() : finalCookie);
    if (fheaders.containsKey('Cookie')) {
      fheaders.update(
          'Cookie',
          (value) =>
              (token != null && token.isNotEmpty) ? getCookie() : finalCookie);
    } else {
      fheaders.putIfAbsent(
          'Cookie',
          () =>
              (token != null && token.isNotEmpty) ? getCookie() : finalCookie);
    }
    if (fheaders.containsKey("content-type")) fheaders.remove("content-type");

    /* Response response;

    BaseOptions options =  BaseOptions(
      connectTimeout: 50000,
      receiveTimeout: 30000,
      contentType: "application/json; charset=utf-8",
    );*/
    /*  Dio dio =  Dio(options);
    response = await dio.post(url,
        queryParameters: body,
        options: Options(headers: fheaders, method: 'POST'));
    var res = response.data;
    final int statusCode = response.statusCode;
    //final Map<String,String> headers=response.headers;
    Headers headers = response.headers;*/
    /*  final request = bhttp.BrowserClient();
    final rs = await request
        .send(bhttp.Request('POST', url, headers: fheaders, body: body));
    final textContent = await rs.readAsString();*/

    // return http
    //     .post(url,
    //         body: _encoder.convert(body), headers: fheaders, encoding: encoding)
    //     .then((http.Response response) {
    response =
        await doFetch(null, url, fheaders, "POST", _encoder.convert(body));
    final String res = response.responseBody.toString();
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(Translations.current.errorFetchData());
    }
    return _decoder.convert(res);
    // });
  }

  Future<String> postForMap(String url,
      {Map<String, String> headers, dynamic mbody, Encoding encoding}) async {
    ResponseUniversal response;
    if (headers == null)
      fheaders.putIfAbsent("Content-Type", () => content);
    else {
      headers.forEach((k, v) {
        fheaders.putIfAbsent(k, () => v);
      });
    }
    if (fheaders.containsKey("content-type")) fheaders.remove("content-type");

    //headers.putIfAbsent("Content-Type",()=> content);
    /*final request = bhttp.BrowserClient();
    final rs = await request
        .send(bhttp.Request('POST', url, headers: fheaders, body: mbody));
    final textContent = await rs.readAsString();*/

    // return http
    //     .post(url, body: mbody, headers: fheaders, encoding: encoding)
    //     .then((http.Response response) {
    response = await doFetch(null, url, fheaders, 'POST', mbody);
    final String res = response.responseBody.toString();
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    return res;
    // });
  }

  Future<T> postNoCookie<T>(String url,
      {Map<String, String> headers,
      Map<String, dynamic> body,
      Encoding encoding}) async {
    ResponseUniversal response;
    fheaders.putIfAbsent("Content-Type", () => content);
    //fheaders.putIfAbsent('Cookie', ()=>token.isNotEmpty ? getCookie() : getToken());
    if (fheaders.containsKey('Cookie')) fheaders.remove('Cookie');
    if (fheaders.containsKey("content-type")) fheaders.remove("content-type");

    /* final request = await httpClient.postUrl(
      Uri.parse(url),
    );

    if (request is uhttp.BrowserHttpClientRequest) {
      request.credentialsMode = uhttp.BrowserHttpClientCredentialsMode.include;
    }
    // final response = await request.close();

    if (request is uhttp.BrowserHttpClientRequest) {
      request.responseType = uhttp.BrowserHttpClientResponseType.text;
    }

    fheaders.forEach((name, values) {
      request.headers.add(name, values);
    });

    final response = await request.close();
    response.listen((chunk) {});
*/
    /*final request = bhttp.BrowserClient();
    final rs = await request.send(bhttp.Request('POST', url, body: body));
    final textContent = await rs.readAsString();*/

    /* return http
        .post(url,
            body: _encoder.convert(body), headers: fheaders, encoding: encoding)
        .then((http.Response response) {*/
    /* final String res = textContent.toString();
    final int statusCode = await rs.statusCode;*/
    // return http
    //     .post(url,
    //         body: _encoder.convert(body), headers: fheaders, encoding: encoding)
    //     .then((http.Response response) {
    response =
        await doFetch(null, url, fheaders, "POST", _encoder.convert(body));
    final String res = response.responseBody.toString();
    final int statusCode = response.statusCode;
    final rheaders = response.headers;

    if (rheaders != null &&
        rheaders["set-cookie"] != null &&
        rheaders["set-cookie"].isNotEmpty) {
      _updateCookie(response);
      token = cookies['Vision_AUTH'];
      clientId = cookies['ClientId'];

      if (token != null && clientId != null) {
        userRepository.persistCookie(token, clientId);
      }
    }
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(Translations.current.errorFetchData());
    }
    return _decoder.convert(res);
    // });
  }
}
