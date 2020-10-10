import 'dart:async';
import 'dart:convert';
import "dart:core";
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class QueryString {
  static Map parse(String query) {
    var search = RegExp('([^&=]+)=?([^&]*)');
    var result = Map();

    // Get rid off the beginning ? in query strings.
    if (query.startsWith('?')) query = query.substring(1);
    // A custom decoder.
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1))] = decode(match.group(2));
    }
    return result;
  }
}

class BlogNewsApi {
  String url;
  bool isHttps;

  BlogNewsApi(url) {
    // ignore: prefer_initializing_formals
    this.url = url;

    if (this.url.startsWith("https")) {
      isHttps = true;
    } else {
      isHttps = false;
    }
  }

  _getOAuthURL(String requestMethod, String endpoint) {
    return url + "/wp-json/wp/v2/" + endpoint;
  }

  Future<http.StreamedResponse> getStream(String endPoint) async {
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    return await client.send(request);
  }

  Future<dynamic> getAsync(String endPoint) async {
    var url = _getOAuthURL("GET", endPoint);

    final response = await http.get(url);
    return json.decode(response.body);
  }

  Future<dynamic> postAsync(String endPoint, Map data, {String token}) async {
    var url = _getOAuthURL("POST", endPoint);
    var client = http.Client();
    var request = http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    if (token != null) {
      request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    }
    request.body = json.encode(data);
    var response =
        await client.send(request).then((res) => res.stream.bytesToString());

    var dataResponse = await json.decode(response);
    return dataResponse;
  }

  Future<dynamic> uploadImage(File imageFile, String token) async {
    // open a bytestream
    var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();
    // string to uri
    var uri = Uri.parse("$url/wp-json/wp/v2/media");
    // create multipart request
    var request = http.MultipartRequest("POST", uri);
    request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    // add file to multipart
    request.files.add(multipartFile);
    // send
    var response =
        await request.send().then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    return dataResponse;
  }

  Future<dynamic> putAsync(String endPoint, Map data) async {
    var url = _getOAuthURL("PUT", endPoint);

    var client = http.Client();
    var request = http.Request('PUT', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    var response =
        await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    return dataResponse;
  }
}
