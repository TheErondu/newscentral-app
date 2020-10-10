import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../models/category.dart';

class AppModel with ChangeNotifier {
  Map<String, dynamic> appConfig;
  Map<String, dynamic> drawer;
  bool isLoading = true;
  String message;
  bool darkTheme = false;
  String locale = kAdvanceConfig['DefaultLanguage'] ?? "en";
  String productListLayout;
  bool isAccessedByOnBoardingBoard = false;
  Map deeplink;

  Future<bool> changeLanguage(String country, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      locale = country;
      await prefs.setString("language", country);
      await loadAppConfig();
      notifyListeners();
      Provider.of<CategoryModel>(context, listen: false)
          .getCategories(lang: country);
      return true;
    } catch (err) {
      return false;
    }
  }

  void updateTheme(bool theme) async {
//    enable darkTheme at local scope for listeners
    darkTheme = theme;
    notifyListeners();
  }

  void loadStreamConfig(config) {
    appConfig = config;
    productListLayout = appConfig['Setting']['ProductListLayout'];
    isLoading = false;
    notifyListeners();
  }

  Future<Map> loadAppConfig() async {
    try {
      final LocalStorage storage = LocalStorage('builder.json');
      var config = await storage.getItem('config');
      if (config != null) {
        appConfig = config;
      } else {
        if (kAppConfig.contains('http')) {
          // load on cloud config and update on air
          final appJson = await http.get(Uri.encodeFull(kAppConfig),
              headers: {"Accept": "application/json"});
          appConfig = convert.jsonDecode(appJson.body);
        } else {
          // load local config
          String path = "lib/config/config_$locale.json";
          try {
            final appJson = await rootBundle.loadString(path);
            appConfig = convert.jsonDecode(appJson);
          } catch (e) {
            final appJson = await rootBundle.loadString(kAppConfig);
            appConfig = convert.jsonDecode(appJson);
          }
        }
      }

      productListLayout = appConfig['Setting']['ProductListLayout'];
      drawer = appConfig['Drawer'] != null
          ? Map<String, dynamic>.from(appConfig['Drawer'])
          : null;
      isLoading = false;
      notifyListeners();
      return appConfig;
    } catch (err) {
      isLoading = false;
      message = err.toString();
      notifyListeners();
      return null;
    }
  }

  void updateProductListLayout(layout) {
    productListLayout = layout;
    notifyListeners();
  }
}

class App {
  Map<String, dynamic> appConfig;

  App(this.appConfig);
}
