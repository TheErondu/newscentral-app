import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constants.dart';

/// Server config
const serverConfig = {
  "url": "http://newscentral.africa",
  "forgetPassword": "http://newscentral.africa/wp-login.php?action=lostpassword"
};

const kOneSignalKey = {
  'appID': "e01fa269-49a1-4558-90f5-5609a575f6e4",
};

const CategoriesListLayout = kCategoriesLayout.sideMenu;

var kLayoutWeb = false;

const CategoryStaticImages = {
  30: 'assets/images/first-onboarding.png',
  41: 'assets/images/first-onboarding.png',
  45: 'assets/images/first-onboarding.png',
  46: 'assets/images/first-onboarding.png',
  40: 'assets/images/first-onboarding.png',
  37: 'assets/images/first-onboarding.png',
  31: 'assets/images/first-onboarding.png',
  36: 'assets/images/first-onboarding.png',
  32: 'assets/images/first-onboarding.png',
  33: 'assets/images/first-onboarding.png',
  34: 'assets/images/first-onboarding.png',
};

/// the welcome screen data
List onBoardingData = [
  {
    "title": "We're bringing Africa to the World,",
    "image": "assets/images/first-onboarding.png",
    "desc":
        "Building Africa’s most respected media brand, across television, mobile, and web. ",
    "background": "#040404"
  },
  {
    "title": "By Telling the True African Story,",
    "image": "assets/images/fogg-delivery-1.png",
    "desc":
        "In our news stories, we bring factual content and real shared experiences to our audience.",
    "background": "#040404"
  },
  {
    "title": "From an African Perspective.",
    "image": "assets/images/fogg-order-completed.png",
    "desc": "Unlocking the essence, expressions and textures of Africa..",
    "background": "#040404"
  },
];

/// Below config is use for further WooCommerce integration,
/// you can skip the config if not using WooCommerce
const afterShip = {
  "api": "e2e9bae8-ee39-46a9-a084-781d0139274f",
  "tracking_url": "https://fluxstore.aftership.com"
};

const Payments = {
  "paypal": "assets/icons/payment/paypal.png",
  "stripe": "assets/icons/payment/stripe.png",
  "razorpay": "assets/icons/payment/razorpay.png",
};

/// The product variant config
const ProductVariantLayout = {
  "color": "color",
  "size": "box",
  "height": "option",
};

const kAdvanceConfig = {
  "DefaultLanguage": "en",
  "IsRequiredLogin": false,
  "GuestCheckout": true,
  "EnableShipping": false,
  "GridCount": 3,
  "DetailedBlogLayout": "oneQuarterSizeImageType",
  "EnablePointReward": false,
  "HeartButtonType": kHeartButtonType.cornerType
};

/// The Google API Key to support Pick up the Address automatically
/// We recommend to generate both ios and android to restrict by bundle app id
/// The download package is remove these keys, please use your own key
const kGoogleAPIKey = {
  "android": "your-google-api-key",
  "ios": "your-google-api-key"
};

/// use to config the product image height for the product detail
/// height=(percent * width-screen)
/// isHero: support hero animate
const kProductDetail = {
  "height": 0.5,
  "marginTop": 0,
  "isHero": true,
  "safeArea": false,
  "showVideo": true,
  "showThumbnailAtLeast": 3,
  "showComment": false
};

/// config for the chat app
const smartChat = [
  {
    'app': 'whatsapp://send?phone=+2349011900000',
    'iconData': FontAwesomeIcons.whatsapp
  },
  {'app': 'tel:+2348166289825', 'iconData': FontAwesomeIcons.phone},
  {'app': 'sms://+2348166289825', 'iconData': FontAwesomeIcons.sms},
  // {'app': 'firebase', 'iconData': FontAwesomeIcons.google},
  // {'app': 'intercome', 'iconData': FontAwesomeIcons.intercom},
];
const String adminEmail = "itsupport@newscentral.ng";

const kIntercomAPIKey = {
  'android': 'android_sdk-2c16c0e017a1e7b8d3b73b5a13a56b54cbf535c0',
  'ios': 'ios_sdk-33135e6653b055cec773b7903baff10efee94bc0',
  'appID': 'xro9xnfd'
};

const kAdConfig = {
  "enabled": false,
  "type": kAdType.googleReward,
  // ----------------- Facebook Ads  -------------- //

  "hasdedIdTestingDevice": "3f06ede0-3b68-4cdb-a639-1b1007cedd31",
  "bannerPlacementId": "430258564493822_489007588618919",
  "interstitialPlacementId": "430258564493822_489092398610438",
  "nativePlacementId": "430258564493822_489092738610404",
  "nativeBannerPlacementId": "430258564493822_489092925277052",

  // ------------------ Google Admob  -------------- //

  "androidAppId": "ca-app-pub-2101182400000000~7554000316",
  "androidUnitBanner": "ca-app-pub-2101182400000000~7554000316",
  "androidUnitInterstitial": "ca-app-pub-2101182400000000~7554000316",
  "androidUnitReward": "ca-app-pub-2101182400000000~7554000316",
  "iosAppId": "ca-app-pub-2101182400000000~7554000316",
  "iosUnitBanner": "ca-app-pub-2101182400000000/5418791562",
  "iosUnitInterstitial": "ca-app-pub-2101182400000000/9218413691",
  "iosUnitReward": "ca-app-pub-2101182400000000/9026842008",
  "waitingTimeToDisplayInterstitial": 3,
  "waitingTimeToDisplayReward": 3,
};

const kDefaultDrawer = {
  "logo": "assets/images/logo.gif",
  "background": "assets/images/logo.gif",
  "items": [
    {"type": "home", "show": true},
    {"type": "web", "show": true},
    {"type": "about", "show": true},
    {"type": "login", "show": true},
    {"type": "category", "show": true}
  ]
};

const kDefaultSettings = [
  'wishlist',
  'post',
  'notifications',
  'language',
  'darkTheme',
  'privacy'
];

const kLoginSetting = {
  "IsRequiredLogin": false,
  'showAppleLogin': true,
  'showFacebook': true,
  'showSMSLogin': true,
  'showGoogleLogin': true,
};
