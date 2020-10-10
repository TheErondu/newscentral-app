import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'banner/banner_animate_items.dart';
import 'banner/banner_group_items.dart';
import 'banner/banner_slider_items.dart';
import 'header/header_text.dart';
import 'horizontal/blog_list_layout.dart';
import 'horizontal/horizontal_list_items.dart';
import 'horizontal/slider_item.dart';
import 'horizontal/slider_list.dart';
import 'logo.dart';
import 'vertical/vertical_layout.dart';

class HomeLayout extends StatefulWidget {
  final configs;

  HomeLayout({this.configs});

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// convert the JSON to list of horizontal widgets
  Widget jsonWidget(config) {
    switch (config["layout"]) {
      case "logo":
        {
          if ((widget.configs["Setting"] != null
              ? (widget.configs["Setting"]["StickyHeader"] ?? false)
              : false)) {
            return Container();
          }
          return Logo(
              config: config,
              key: config['key'] != null ? Key(config['key']) : null);
        }
      case 'header_text':
        return HeaderText(
            config: config,
            key: config['key'] != null ? Key(config['key']) : null);

      case "bannerAnimated":
        return BannerAnimated(
            config: config,
            key: config['key'] != null ? Key(config['key']) : null);

      case "bannerImage":
        return config['isSlider'] == true
            ? BannerSliderItems(
                config: config,
                key: config['key'] != null ? Key(config['key']) : null)
            : BannerGroupItems(
                config: config,
                key: config['key'] != null ? Key(config['key']) : null);
      case 'largeCardHorizontalListItems':
        return LargeCardHorizontalListItems(
            config: config,
            key: config['key'] != null ? Key(config['key']) : null);
      case "sliderList":
        return HorizontalSliderList(
            config: config,
            key: config['key'] != null ? Key(config['key']) : null);
      case "sliderItem":
        return SliderItem(
            config: config,
            key: config['key'] != null ? Key(config['key']) : null);

      default:
        return BlogListLayout(
            config: config,
            key: config['key'] != null ? Key(config['key']) : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.configs == null) return Container();
    bool isStickyHeader = widget.configs["Setting"] != null
        ? (widget.configs["Setting"]["StickyHeader"] ?? false)
        : false;
    Widget content = Column(
      children: <Widget>[
        for (var config in widget.configs["HorizonLayout"])
          jsonWidget(
            config,
          ),
        if (widget.configs["VerticalLayout"] != null)
          VerticalViewLayout(
            config: widget.configs["VerticalLayout"],
          ),
      ],
    );
    List<Map<String, dynamic>> horizonLayout =
        List<Map<String, dynamic>>.from(widget.configs["HorizonLayout"]);
    var config = horizonLayout
        .firstWhere((element) => element['layout'] == 'logo', orElse: () => {});

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Future.delayed(
          const Duration(milliseconds: 1000),
        ),
        child: SingleChildScrollView(
          child: isStickyHeader
              ? StickyHeader(
                  header: Container(
                    height: 40.0,
                    color: Theme.of(context).backgroundColor,
                    alignment: Alignment.centerLeft,
                    child: Logo(
                      config: config,
                      key: config['key'] != null ? Key(config['key']) : null,
                    ),
                  ),
                  content: content,
                )
              : content,
        ),
      ),
    );
  }
}
