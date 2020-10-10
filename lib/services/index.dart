import '../models/category.dart';
import '../models/review.dart';
import '../models/user.dart';

abstract class BaseServices {
  Future<List<Category>> getCategories({lang});

  Future<User> loginFacebook({String token});

  Future<User> loginSMS({String token});

  Future<List<Review>> getReviews(productId);

  Future<User> getUserInfo(cookie);

  Future<User> createUser({
    firstName,
    lastName,
    username,
    password,
  });

  Future<User> login({username, password});

  Future<Null> createReview({int productId, Map<String, dynamic> data});
}

class Services implements BaseServices {
  BaseServices serviceApi;

  static final Services _instance = Services._internal();

  factory Services() => _instance;

  Services._internal();

  @override
  Future<List<Category>> getCategories({lang = "en"}) async {
    return serviceApi.getCategories(lang: lang);
  }

  @override
  Future<User> loginFacebook({String token}) async {
    return serviceApi.loginFacebook(token: token);
  }

  @override
  Future<User> loginSMS({String token}) async {
    return serviceApi.loginSMS(token: token);
  }

  @override
  Future<List<Review>> getReviews(productId) async {
    return serviceApi.getReviews(productId);
  }

  @override
  Future<User> createUser({firstName, lastName, username, password}) async {
    return serviceApi.createUser(
      firstName: firstName,
      lastName: lastName,
      username: username,
      password: password,
    );
  }

  @override
  Future<User> getUserInfo(cookie) async {
    return serviceApi.getUserInfo(cookie);
  }

  @override
  Future<User> login({username, password}) async {
    return serviceApi.login(
      username: username,
      password: password,
    );
  }

  @override
  Future<Null> createReview({int productId, Map<String, dynamic> data}) async {
    return serviceApi.createReview(productId: productId, data: data);
  }
}
