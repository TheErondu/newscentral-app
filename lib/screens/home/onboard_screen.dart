import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstorage/localstorage.dart';
import 'package:fluxnews/widgets/animated_indicator.dart';
import '../../common/config.dart' as config;
import '../../common/constants.dart';

const arrowColor = Colors.transparent;
const kTitleStyle =
    TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);
const kSubtitleStyle = TextStyle(fontSize: 14, color: Colors.white);
const kSkiptyle = TextStyle(fontSize: 14, height: 2, color: Colors.white);

class OnBoardScreen extends StatefulWidget {
  final appConfig;

  OnBoardScreen(this.appConfig);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final isRequiredLogin = config.kAdvanceConfig['IsRequiredLogin'];
  int page = 0;
  PageController pageController = PageController(initialPage: 0);

  Future<void> setFirstSeen(bool value) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem(kLocalKey["isFirstSeen"], value);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
            child: PageView(controller: pageController, children: [
          Slide(
              // title: "We're bringing Africa to the World,",
              hero: Image.asset(
                "assets/images/first-onboarding.png",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              // subtitle:
              //     "Building Africa’s most respected media brand, across television, mobile, and web.",
              onNext: nextPage),
          Slide(
              // title: "From an African Perspective.",
              hero: Image.asset(
                "assets/images/fogg-delivery-1.png",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              // subtitle:
              //     "Unlocking the essence, expressions and textures of Africa..",
              onNext: onDonePress),
        ])),
      ),
    );
  }

  void nextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onDonePress() async {
    await Navigator.pushNamed(context, '/home');
// Do what you want
  }
}

class Slide extends StatelessWidget {
  final Widget hero;
  // final String title;
  // final String subtitle;
  final VoidCallback onNext;

  const Slide(
      {Key key,
      this.hero,
      //  this.title, this.subtitle
      this.onNext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: hero),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Text(
                //   title,
                //   style: kTitleStyle,
                // ),
                SizedBox(
                  height: 0,
                ),
                // Text(
                //   subtitle,
                //   style: kSubtitleStyle,
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(
                  height: 0,
                ),
                ProgressButton(onNext: onNext),
              ],
            ),
          ),
          SizedBox(
            height: 2,
          )
        ],
      ),
    );
  }
}

class ProgressButton extends StatelessWidget {
  final VoidCallback onNext;
  const ProgressButton({Key key, this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Stack(children: [
        AnimatedIndicator(
          duration: const Duration(seconds: 5),
          size: 0,
          // height reduced to zero to hide default was 75

          callback: onNext,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, '/home');
// Do what you want
            },
            child: const Text(
              "Skip",
              style: kSkiptyle,
            ),
          ),
        )
      ]),
    );
  }
}
