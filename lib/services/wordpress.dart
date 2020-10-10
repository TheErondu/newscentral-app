import 'dart:async';
import 'dart:convert' as convert;
import "dart:core";
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quiver/strings.dart';

import '../models/blog_news.dart';
import '../models/category.dart';
import '../models/comment.dart';
import '../models/user.dart';
import 'helper/blognews_api.dart';

class WordPress {
  WordPress serviceApi;
  static final WordPress _instance = WordPress._internal();

  factory WordPress() => _instance;

  WordPress._internal();

  static BlogNewsApi blogApi;

  String isSecure;

  String url;

  void setAppConfig(appConfig) {
    blogApi = BlogNewsApi(appConfig["url"]);
    isSecure = appConfig["url"].indexOf('https') != -1 ? '' : '&insecure=cool';
    url = appConfig["url"];
  }

  Future<bool> createComment(
      {int blogId,
      String content,
      String authorName,
      String authorAvatar,
      String userEmail,
      String date}) async {
    try {
      //return true if comment created successful, false if otherwise
      final http.Response response =
          await http.post("$url/wp-json/wp/v2/comments?post=$blogId",
              body: convert.jsonEncode({
                "content": content,
                "author_name": authorName,
                "author_avatar_urls": authorAvatar,
                "email": userEmail,
                "date": date
              }));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Null> createBlog(File file, {Map<String, dynamic> data}) async {
    try {
      int mediaImageId;
      String jwtToken = await UserModel().getJwtAuthToken();
      if (jwtToken == null) {
        print('Error on getting JwtToken');
      } else {
        await blogApi.uploadImage(file, jwtToken).then((response) {
          mediaImageId = response['id'];
          if (mediaImageId != null) {
            data['featured_media'] = mediaImageId;
          }
        });
        await blogApi.postAsync("posts", data, token: jwtToken);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogNews>> searchBlog({name}) async {
    try {
      var response = await blogApi.getAsync("posts?_embed&search=$name");

      List<BlogNews> list = [];
      for (var item in response) {
        list.add(BlogNews.fromJson(item));
      }
      print(list);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Comment>> getCommentsByPostId({postId}) async {
    try {
      print(postId);
      List<Comment> list = [];

      var endPoint = "comments?";
      if (postId != null) {
        endPoint += "&post=$postId";
      }

      var response = await blogApi.getAsync(endPoint);

      for (var item in response) {
        list.add(Comment.fromJson(item));
      }

      return list;
    // ignore: empty_catches
    } catch (e) {

    }
  }

  Future<List<Category>> getCategories({lang = "en"}) async {
    try {
      var response = await blogApi.getAsync(
          "categories?per_page=100&hide_empty=0&exclude=257,247,198,249,253,292,202,300,293,215,293,33978,33977,33968,33997,33967,33962,33999,1,15725");
      print('responseee $response');
      List<Category> list = [];
      for (var item in response) {
        if (item['slug'] != "uncategorized" && item['count'] > 0) {
          list.add(Category.fromJson(item));
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogNews>> getBlogs() async {
    try {
      var response = await blogApi.getAsync("posts");
      List<BlogNews> list = [];
      for (var item in response) {
        list.add(BlogNews.fromJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getUsersByRole(String role) async {
    try {
      var response = await blogApi.getAsync('users?roles=$role&context=edit');
      List<User> userList = [];
      for (var user in response) {
        userList.add(User.fromLocalJson(user));
      }
      return userList;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<BlogNews>> getBlogsByCategory(int cateId) async {
    try {
      var response = await blogApi.getAsync("posts?_embed&categories=$cateId");
      List<BlogNews> list = [];
      for (var item in response) {
        list.add(BlogNews.fromJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogNews>> getBlogsByUserId(int userId) async {
    try {
      var response = await blogApi.getAsync("posts?_embed&author=$userId");
      List<BlogNews> list = [];
      for (var item in response) {
        list.add(BlogNews.fromJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<BlogNews> getPageById(int pageId) async {
    try {
      var response = await blogApi.getAsync("pages/$pageId?_embed");
      return BlogNews.fromPageJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BlogNews> getBlog(id) async {
    try {
      var response = await blogApi.getAsync("posts/$id");

      return BlogNews.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogNews>> fetchBlogLayout({config, lang = 'en'}) async {
    try {
      List<BlogNews> list = [];

      var endPoint = "posts?_embed&per_page=10&lang=$lang";
      if (config.containsKey("category")) {
        endPoint += "&categories=${config["category"]}";
      }
      if (config.containsKey("page")) {
        endPoint += "&page=${config["page"]}";
      }

      var response = await blogApi.getAsync(endPoint);

      for (var item in response) {
        BlogNews blog = BlogNews.fromJson(item);
        blog.categoryId = config["category"];
        list.add(blog);
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogNews>> fetchBlogsByCategory(
      {categoryId, page = 1, lang = 'en'}) async {
    try {
      print(categoryId);
      List<BlogNews> list = [];

      var endPoint = "posts?_embed&lang=$lang&per_page=15&page=$page";
      if (categoryId != null) {
        endPoint += "&categories=$categoryId";
      }
      var response = await blogApi.getAsync(endPoint);
      for (var item in response) {
        list.add(BlogNews.fromJson(item));
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future getNonce({method = 'register'}) async {
    try {
      http.Response response = await http.get(
          "$url/api/get_nonce/?controller=mstore_user&method=$method&$isSecure");
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body)['nonce'];
      } else {
        throw Exception(['error getNonce', response.statusCode]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getJwtAuth(String username, String password) async {
    try {
      var endPoint =
          "$url/wp-json/jwt-auth/v1/token?username=$username&password=$password";
      var response = await http.post(endPoint);
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode['token'] == null) {
        throw Exception(jsonDecode['code']);
      }
      return jsonDecode['token'];
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document or contact supporters/
      rethrow;
    }
  }

  Future<User> loginGoogle({String token}) async {
    const cookieLifeTime = 120960000000;

    try {
      var endPoint =
          "$url/wp-json/api/flutter_user/google_login/?second=$cookieLifeTime"
          "&access_token=$token$isSecure";

      var response = await http.get(endPoint);

      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['wp_user_id'] == null || jsonDecode["cookie"] == null) {
        throw Exception(jsonDecode['error']);
      }

      return User.fromJsonFB(jsonDecode);
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document/
      rethrow;
    }
  }

  Future<User> loginApple({String email, String fullName}) async {
    try {
      var endPoint =
          "$url/wp-json/api/flutter_user/apple_login?email=$email&display_name=$fullName&user_name=${email.split("@")[0]}$isSecure";

      var response = await http.get(endPoint);

      var jsonDecode = convert.jsonDecode(response.body);

      return User.fromJsonSMS(jsonDecode);
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document

      rethrow;
    }
  }

  Future<User> loginFacebook({String token}) async {
    const cookieLifeTime = 120960000000;

    try {
      var endPoint =
          "$url/wp-json/api/flutter_user/fb_connect/?second=$cookieLifeTime"
          "&access_token=$token$isSecure";

      var response = await http.get(endPoint);

      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['wp_user_id'] == null || jsonDecode["cookie"] == null) {
        throw Exception(jsonDecode['msg']);
      }

      return User.fromJsonFB(jsonDecode);
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document

      rethrow;
    }
  }

  Future<User> loginSMS({String token}) async {
    try {
      //var endPoint = "$url/wp-json/api/flutter_user/sms_login/?access_token=$token$isSecure";
      var endPoint =
          "$url/wp-json/api/flutter_user/firebase_sms_login?phone=$token$isSecure";

      var response = await http.get(endPoint);

      var jsonDecode = convert.jsonDecode(response.body);

      return User.fromJsonSMS(jsonDecode);
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document

      rethrow;
    }
  }

  Future<User> getUserInfo(cookie, {password}) async {
    try {
      final http.Response response = await http.get(
          "$url/wp-json/api/flutter_user/get_currentuserinfo?cookie=$cookie&$isSecure");
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200 && body["user"] != null) {
        var user = body['user'];
        user['password'] = password;
        return User.fromAuthUser(user, cookie);
      } else {
        throw Exception(body["message"]);
      }
    } catch (err) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document f

      rethrow;
    }
  }

  Future<User> createUser({firstName, lastName, username, password}) async {
    try {
      String niceName = firstName + " " + lastName;

      final http.Response response = await http.post(
          "$url/wp-json/api/flutter_user/register/?insecure=cool&$isSecure",
          body: convert.jsonEncode({
            "user_email": username,
            "user_login": username,
            "username": username,
            "user_pass": password,
            "email": username,
            "user_nicename": niceName,
            "display_name": niceName,
          }));

      var body = convert.jsonDecode(response.body);
      print(body);

      if (response.statusCode == 200 && body["message"] == null) {
        var cookie = body['cookie'];
        return await getUserInfo(cookie, password: password);
      } else {
        var message = body["message"];
        throw Exception(message != null ? message : "Can not create the user.");
      }
    } catch (err) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document
      print(err.toString());
      rethrow;
    }
  }

  Future<User> login({username, password}) async {
    var cookieLifeTime = 120960000000;
    try {
      final http.Response response = await http.post(
          "$url/wp-json/api/flutter_user/generate_auth_cookie/?insecure=cool&$isSecure",
          body: convert.jsonEncode({
            "seconds": cookieLifeTime.toString(),
            "username": username,
            "password": password
          }));

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200 && isNotBlank(body['cookie'])) {
        return await getUserInfo(body['cookie'], password: password);
      } else {
        throw Exception("The username or password is incorrect.");
      }
    } catch (err) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document
      rethrow;
    }
  }
}
