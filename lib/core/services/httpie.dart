import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/file_helper.dart';

@injectable
class HttpieService {
  // String? accessToken;
  late Client client;
  final FirebaseAuth auth;
  static const defaultConnectionTimeoutBySecond = 5;

  HttpieService(this.auth) {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    httpClient.connectionTimeout =
        const Duration(seconds: defaultConnectionTimeoutBySecond);
    client = IOClient(httpClient);
  }

  // bool _retryWhenResponse(BaseResponse response) {
  //   return (response.statusCode >= 503 && response.statusCode < 600) ||
  //       _detectAndTriggerInvalidToken(response);
  // }

  // bool _retryWhenError(error, StackTrace stackTrace) {
  //   return error is SocketException || error is ClientException;
  // }

  // void _onRetry(BaseRequest request, BaseResponse response, int retryCount) {
  //   print('##RETRY: === ${request.url}');
  //   // re-config request header before retry
  //   request.headers['Authorization'] = 'Bearer $accessToken';
  // }

  // void setRefreshTokenCallBack(Function() refreshToken) {
  //   _refreshToken = refreshToken;
  // }

  void setProxy(String? proxy) {
    final overrides = HttpOverrides.current as HttpieOverrides?;
    if (overrides != null) {
      overrides.setProxy(proxy!);
    }
  }

  Future<HttpieResponse> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool? appendLanguageHeader,
    bool? appendAuthorizationToken,
  }) async {
    final finalHeaders = await _getHeadersWithConfig(
        headers: headers, appendAuthorizationToken: appendAuthorizationToken);

    final uri = Uri.parse(url);

    Response? response;
    try {
      response = await client.post(uri,
          headers: finalHeaders, body: body, encoding: encoding);
    } catch (error) {
      _handleRequestError(error);
    }

    return HttpieResponse(response!);
  }

  Future<HttpieResponse> put(String url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool? appendAuthorizationToken}) async {
    final finalHeaders = await _getHeadersWithConfig(
      headers: headers,
      appendAuthorizationToken: appendAuthorizationToken,
    );

    final uri = Uri.parse(url);

    late Response response;

    try {
      response = await client.put(uri,
          headers: finalHeaders, body: body, encoding: encoding);
    } catch (error) {
      _handleRequestError(error);
    }

    return HttpieResponse(response);
  }

  Future<HttpieResponse> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) async {
    final finalHeaders = await _getHeadersWithConfig(
        headers: headers, appendAuthorizationToken: appendAuthorizationToken);

    final uri = Uri.parse(url);

    late Response response;

    try {
      response = await client.patch(uri,
          headers: finalHeaders, body: body, encoding: encoding);
    } catch (error) {
      _handleRequestError(error);
    }

    return HttpieResponse(response);
  }

  Future<HttpieResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) async {
    final finalHeaders = await _getHeadersWithConfig(
        headers: headers, appendAuthorizationToken: appendAuthorizationToken);

    final uri = Uri.parse(url);

    late Response response;

    try {
      response = await client.delete(uri, headers: finalHeaders);
    } catch (error) {
      _handleRequestError(error);
    }

    return HttpieResponse(response);
  }

  Future<HttpieResponse> deleteParam(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool? appendAuthorizationToken,
  }) async {
    final finalHeaders = await _getHeadersWithConfig(
        headers: headers, appendAuthorizationToken: appendAuthorizationToken);

    if (queryParameters != null && queryParameters.keys.isNotEmpty) {
      // ignore: parameter_assignments
      url += _makeQueryString(queryParameters);
    }

    late Response response;
    final uri = Uri.parse(url);
    try {
      response = await client.delete(uri, headers: finalHeaders);
    } catch (error) {
      _handleRequestError(error);
    }

    return HttpieResponse(response);
  }

  Future<HttpieResponse> postJSON(
    String url, {
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) {
    final String jsonBody = json.encode(body);

    final Map<String, String> jsonHeaders = _getJsonHeaders();

    jsonHeaders.addAll(headers);

    return post(
      url,
      headers: jsonHeaders,
      body: jsonBody,
      encoding: encoding,
      appendAuthorizationToken: appendAuthorizationToken,
    );
  }

  Future<HttpieResponse> putJSON(
    String url, {
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) {
    final String jsonBody = json.encode(body);

    final Map<String, String> jsonHeaders = _getJsonHeaders();

    jsonHeaders.addAll(headers);

    return put(url,
        headers: jsonHeaders,
        body: jsonBody,
        encoding: encoding,
        appendAuthorizationToken: appendAuthorizationToken);
  }

  Future<HttpieResponse> patchJSON(
    String url, {
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) {
    final String jsonBody = json.encode(body);

    final Map<String, String> jsonHeaders = _getJsonHeaders();

    jsonHeaders.addAll(headers);

    return patch(url,
        headers: jsonHeaders,
        body: jsonBody,
        encoding: encoding,
        appendAuthorizationToken: appendAuthorizationToken);
  }

  Future<HttpieResponse> get(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      bool? appendLanguageHeader,
      bool? appendAuthorizationToken}) async {
    final finalHeaders = await _getHeadersWithConfig(
        headers: headers, appendAuthorizationToken: appendAuthorizationToken);

    if (queryParameters != null && queryParameters.keys.isNotEmpty) {
      // ignore: parameter_assignments
      url += _makeQueryString(queryParameters);
    }

    final uri = Uri.parse(url);

    late Response response;

    try {
      response = await client.get(uri, headers: finalHeaders);
    } catch (error) {
      _handleRequestError(error);
    }

    return HttpieResponse(response);
  }

  Future<HttpieResponse> getWithHeader(
      String url, Map<String, String>? header) async {
    late Response response;
    final uri = Uri.parse(url);
    try {
      response = await client.get(uri, headers: header);
    } catch (error) {
      _handleRequestError(error);
    }

    return HttpieResponse(response);
  }

  Future<HttpieStreamedResponse> postMultiform(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) {
    return _multipartRequest(url,
        method: 'POST',
        headers: headers,
        body: body,
        encoding: encoding,
        appendAuthorizationToken: appendAuthorizationToken);
  }

  Future<HttpieStreamedResponse> deleteMultiform(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) {
    return _multipartRequest(url,
        method: 'DELETE',
        headers: headers,
        body: body,
        encoding: encoding,
        appendAuthorizationToken: appendAuthorizationToken);
  }

  Future<HttpieStreamedResponse> patchMultiform(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) {
    return _multipartRequest(url,
        method: 'PATCH',
        headers: headers,
        body: body,
        encoding: encoding,
        appendAuthorizationToken: appendAuthorizationToken);
  }

  Future<HttpieStreamedResponse> putMultiform(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Encoding? encoding,
    bool? appendAuthorizationToken,
  }) {
    return _multipartRequest(url,
        method: 'PUT',
        headers: headers,
        body: body,
        encoding: encoding,
        appendAuthorizationToken: appendAuthorizationToken);
  }

  Future<HttpieStreamedResponse> _multipartRequest(String url,
      {Map<String, String>? headers,
      required String method,
      Map<String, dynamic>? body = const {},
      Encoding? encoding,
      bool? appendAuthorizationToken}) async {
    final request = http.MultipartRequest(method, Uri.parse(url));

    final finalHeaders = await _getHeadersWithConfig(
      headers: headers,
      appendAuthorizationToken: appendAuthorizationToken,
    );

    finalHeaders['Content-type'] = "multipart/form-data;charset=utf-8";
    request.headers.addAll(finalHeaders);

    final List<Future> fileFields = [];

    final List<String> bodyKeys = body!.keys.toList();

    for (final String key in bodyKeys) {
      final dynamic value = body[key];
      if (value is String || value is bool || value is int) {
        request.fields[key] = value.toString();
      } else if (value is List) {
        if (value.isNotEmpty && value[0] is File) {
          for (final dynamic file in value) {
            final fileFuture = _convertToMultipartFile(key, file as File);
            fileFields.add(fileFuture);
          }
        } else {
          request.fields[key] =
              value.map((item) => item.toString()).toList().join(',');
        }
      } else if (value is File) {
        final fileFuture = _convertToMultipartFile(key, value);
        fileFields.add(fileFuture);
      } else {
        throw const HttpieArgumentsError('Unsupported multiform value type');
      }
    }

    final files = await Future.wait(fileFields);
    for (final file in files) {
      request.files.add(file as MultipartFile);
    }

    late StreamedResponse response;

    try {
      response = await client.send(request);
    } catch (error) {
      _handleRequestError(error);
    }

    return HttpieStreamedResponse(response);
  }

  // Using for putting file to MinIO service
  Future<Response> putBinary(String url, File file) async {
    final uri = Uri.parse(url);
    final String mimeType = await FileHelper.getFileMimeType(file);
    final headers = {
      'Content-Type': mimeType,
      'Content-Length': file.lengthSync().toString(),
      'Connection': 'keep-alive',
    };
    return client.put(uri, headers: headers, body: file.readAsBytesSync());
  }

  Future<MultipartFile> _convertToMultipartFile(String key, File value) async {
    return http.MultipartFile.fromPath(key, value.path);
  }

  Future<Map<String, String>> _getHeadersWithConfig({
    Map<String, String>? headers,
    bool? appendAuthorizationToken,
  }) async {
    final Map<String, String> finalHeaders = Map.from(headers ??= const {});

    if (appendAuthorizationToken ??= true) {
      final String? accessKey = await _getIdToken();
      finalHeaders['Authorization'] = 'Bearer ${accessKey ?? ""}';
    }

    return finalHeaders;
  }

  void _handleRequestError(error) {
    if (error is SocketException) {
      final int errorCode = error.osError!.errorCode;
      if (errorCode == 61 ||
          errorCode == 60 ||
          errorCode == 111 ||
          // Network is unreachable
          errorCode == 101 ||
          errorCode == 104 ||
          errorCode == 51 ||
          errorCode == 8 ||
          errorCode == 113 ||
          errorCode == 7 ||
          errorCode == 64) {
        // Connection refused.
        throw HttpieConnectionRefusedError(error);
      }
    }

    throw error as Object;
  }

  Map<String, String> _getJsonHeaders() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }

  String _makeQueryString(Map<String, dynamic> queryParameters) {
    String queryString = '?';
    queryParameters.forEach((key, value) {
      if (value != null) {
        queryString += '${'$key='}${_stringifyQueryStringValue(value)}&';
      }
    });
    return queryString;
  }

  String _stringifyQueryStringValue(dynamic value) {
    if (value is String) return value;
    if (value is bool || value is int || value is double) {
      return value.toString();
    }
    if (value is List) {
      return value
          .map((valueItem) => _stringifyQueryStringValue(valueItem))
          .join(',');
    }
    throw 'Unsupported query string value';
  }

  Future<String>? _getIdToken() {
    return auth.currentUser?.getIdToken();
  }
}

abstract class HttpieBaseResponse<T extends http.BaseResponse> {
  final T _httpResponse;

  HttpieBaseResponse(this._httpResponse);

  bool isInternalServerError() {
    return _httpResponse.statusCode == HttpStatus.internalServerError;
  }

  bool isBadRequest() {
    return _httpResponse.statusCode == HttpStatus.badRequest;
  }

  bool isOk() {
    return _httpResponse.statusCode == HttpStatus.ok;
  }

  bool isUnauthorized() {
    return _httpResponse.statusCode == HttpStatus.unauthorized;
  }

  bool isForbidden() {
    return _httpResponse.statusCode == HttpStatus.forbidden;
  }

  bool isAccepted() {
    return _httpResponse.statusCode == HttpStatus.accepted;
  }

  bool isNotAcceptable() {
    return _httpResponse.statusCode == HttpStatus.notAcceptable;
  }

  bool isCreated() {
    return _httpResponse.statusCode == HttpStatus.created;
  }

  bool isNotFound() {
    return _httpResponse.statusCode == HttpStatus.notFound;
  }

  bool isConflict() {
    return _httpResponse.statusCode == HttpStatus.conflict;
  }

  int get statusCode => _httpResponse.statusCode;
}

class HttpieResponse extends HttpieBaseResponse<http.Response> {
  HttpieResponse(Response _httpResponse) : super(_httpResponse);

  String get body {
    return utf8.decode(_httpResponse.bodyBytes);
  }

  Map<String, dynamic> parseJsonBody() {
    return json.decode(body) as Map<String, dynamic>;
  }

  http.Response get httpResponse => _httpResponse;
}

class HttpieStreamedResponse extends HttpieBaseResponse<http.StreamedResponse> {
  HttpieStreamedResponse(StreamedResponse _httpResponse) : super(_httpResponse);

  Future<String> readAsString() {
    final completer = Completer<String>();
    final contents = StringBuffer();
    _httpResponse.stream.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () {
      completer.complete(contents.toString());
    });
    return completer.future;
  }
}

class HttpieRequestError<T extends HttpieBaseResponse> implements Exception {
  static String convertStatusCodeToHumanReadableMessage(
    int statusCode,
  ) {
    String readableMessage;

    if (statusCode == HttpStatus.notFound) {
      readableMessage = 'Not found';
    } else if (statusCode == HttpStatus.forbidden) {
      readableMessage = 'You are not allowed to do this';
    } else if (statusCode == HttpStatus.badRequest) {
      readableMessage = 'Bad request';
    } else if (statusCode == HttpStatus.internalServerError) {
      readableMessage =
          "We're experiencing server errors. Please try again later.";
    } else if (statusCode == HttpStatus.serviceUnavailable ||
        statusCode == HttpStatus.serviceUnavailable) {
      readableMessage =
          "We're experiencing server errors. Please try again later.";
    } else {
      readableMessage = 'Server error';
    }

    return readableMessage;
  }

  final T response;

  const HttpieRequestError(this.response);

  @override
  String toString() {
    final String statusCode = response.statusCode.toString();
    String stringifiedError = 'HttpieRequestError:$statusCode';

    if (response is HttpieResponse) {
      final castedResponse = response as HttpieResponse;
      stringifiedError = '$stringifiedError | ${castedResponse.body}';
    }

    return stringifiedError;
  }

  Future<String> body() async {
    late String body;

    if (response is HttpieResponse) {
      final HttpieResponse castedResponse = response as HttpieResponse;
      body = castedResponse.body;
    } else if (response is HttpieStreamedResponse) {
      final HttpieStreamedResponse castedResponse =
          response as HttpieStreamedResponse;
      body = await castedResponse.readAsString();
    }
    return body;
  }

  Future<String?> toHumanReadableMessage() async {
    final String errorBody = await body();

    try {
      final dynamic parsedError = json.decode(errorBody);
      if (parsedError is Map) {
        if (parsedError.isNotEmpty) {
          if (parsedError.containsKey('detail')) {
            return parsedError['detail'] as String?;
          } else if (parsedError.containsKey('message')) {
            return parsedError['message'] as String?;
          } else {
            final dynamic mapFirstValue = parsedError.values.toList().first;
            final dynamic value =
                mapFirstValue is List ? mapFirstValue[0] : null;
            if (value != null && value is String) {
              return value;
            } else {
              return convertStatusCodeToHumanReadableMessage(
                  response.statusCode);
            }
          }
        } else {
          return convertStatusCodeToHumanReadableMessage(response.statusCode);
        }
      } else if (parsedError is List && parsedError.isNotEmpty) {
        return parsedError.first as String;
      }
    } catch (error) {
      return convertStatusCodeToHumanReadableMessage(response.statusCode);
    }
  }
}

class HttpieArgumentsError implements Exception {
  final String msg;

  const HttpieArgumentsError(this.msg);

  @override
  String toString() => 'HttpieArgumentsError: $msg';
}

class HttpieConnectionRefusedError implements Exception {
  final SocketException socketException;

  const HttpieConnectionRefusedError(this.socketException);

  @override
  String toString() {
    final String address = socketException.address.toString();
    final String port = socketException.port.toString();
    return 'HttpieConnectionRefusedError: Connection refused on $address and port $port';
  }

  String toHumanReadableMessage() {
    return 'No internet connection.';
  }
}

// These overrides are used by the standard dart:http/HttpClient to change how
// it behaves. All settings changed here will apply to every single HttpClient
// used by any other package, as long as they're running inside a zone with
// these set.
class HttpieOverrides extends HttpOverrides {
  late String? _proxy;
  final HttpOverrides? _previous = HttpOverrides.current;

  HttpieOverrides();

  // ignore: use_setters_to_change_properties
  void setProxy(String proxy) => _proxy = proxy;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (_previous != null) return _previous!.createHttpClient(context);
    return super.createHttpClient(context);
  }

  @override
  String findProxyFromEnvironment(Uri uri, Map<String, String>? environment) {
    if (_proxy != null) return _proxy!;
    if (_previous != null) {
      return _previous!.findProxyFromEnvironment(uri, environment);
    }
    return super.findProxyFromEnvironment(uri, environment);
  }
}
