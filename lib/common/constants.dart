// The config app layout variable
// or this value can load online https://json-inspire-ui.inspire.now.sh/config.json - see document
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const kAppConfig = 'https://config-fluxstore-neodavids.vercel.app';

class Constants {
  //
  static const String API_KEY = 'AIzaSyD3VjqTkLu1-Fh0I4tQI-fGZqLOgF6xbQ0';
}

const kRedColorHeart = 0xFFf22742;
enum kHeartButtonType { cornerType, squareType }
const kDefaultImage =
    "https://user-images.githubusercontent.com/1459805/58628416-d3056f00-8303-11e9-9212-00179a1f3682.jpg";
const kLogoImage = 'assets/images/logo.png';

const settingsBackground = 'assets/images/fogg-delivery-1.png';

const kProfileBackground = 'assets/images/first-onboarding.png';

const welcomeGift = 'assets/images/settings-back.jpg';

//     There are totally 3 types: "flare" uses .flr file, "animated" uses .png|.jpeg|.jpg file
//     or image url and "zoomIn" uses logo or image url
//     In config.json, edit data according to "SplashScreen" key properly to meet those needs.

const kSplashScreenType = "animated";
//const kSplashScreen = "assets/images/splashscreen.flr";
const kSplashScreen = "assets/images/splashscreen.png";

enum kCategoriesLayout {
  card,
  sideMenu,
  column,
  subCategories,
  animation,
  grid
}

const kEmptyColor = 0XFFF2F2F2;

const kColorNameToHex = {
  "red": "#ec3636",
  "black": "#000000",
  "white": "#ffffff",
  "green": "#36ec58",
  "grey": "#919191",
  "yellow": "#f6e46a",
  "blue": "#3b35f3"
};

/// Filter value
const kSliderActiveColor = 0xFF2c3e50;
const kSliderInactiveColor = 0x992c3e50;
const kMaxPriceFilter = 1000.0;
const kFilterDivision = 10;

const kOrderStatusColor = {
  "processing": "#B7791D",
  "cancelled": "#C82424",
  "refunded": "#C82424",
  "completed": "#15B873"
};

const kLocalKey = {
  "userInfo": "userInfo",
  "shippingAddress": "shippingAddress",
  "recentSearches": "recentSearches",
  "wishlist": "wishlist",
  "home": "home",
  "cart": "cart",
  "jwtToken": "jwtToken",
  "isFirstSeen": "isFirstSeen",
};

/// id_category : image_category
const kGridIconsCategories = {
  23: "assets/icons/categories/i_briefcase.png",
  208: "assets/icons/categories/i_chrome.png",
  24: "assets/icons/categories/i_download.png",
  30: "assets/icons/categories/i_compass.png",
  19: "assets/icons/categories/i_instagram.png",
  21: "assets/icons/categories/i_lib.png",
  25: "assets/icons/categories/i_map.png",
  27: "assets/icons/categories/i_package.png",
  29: "assets/icons/categories/i_shopping.png"
};

Widget kLoadingWidget(context) => Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 30.0,
      ),
    );

enum kBlogLayout {
  simpleType,
  fullSizeImageType,
  halfSizeImageType,
  oneQuarterImageType
}

const kProductListLayout = [
  {"layout": "list", "image": "assets/icons/tabs/icon-list.png"},
  {"layout": "columns", "image": "assets/icons/tabs/icon-columns.png"},
  {"layout": "card", "image": "assets/icons/tabs/icon-card.png"}
];

enum kCommentLayout { fullSize, halfSize, oneQuarter }

enum kAdType {
  googleBanner,
  googleInterstitial,
  googleReward,
  facebookBanner,
  facebookInterstitial,
  facebookNative,
  facebookNativeBanner,
}

var addPostAccessibleRoles = ['author', 'administrator'];
const bool kIsWeb = false;

// use eventbus for fluxbuilder
EventBus eventBus = EventBus();
