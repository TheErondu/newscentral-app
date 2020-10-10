import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/category.dart';
import 'card.dart';
import 'column.dart';
import 'side_menu.dart';
import 'sub.dart';

class CategoriesScreen extends StatefulWidget {
  final String layout;
  final List<dynamic> categories;
  final List<dynamic> images;
  CategoriesScreen({Key key, this.layout, this.categories, this.images})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoriesScreenState();
  }
}

class CategoriesScreenState extends State<CategoriesScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  FocusNode _focus;
  bool isVisibleSearch = false;
  String searchText;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 0, end: 60).animate(controller);
    animation.addListener(() {
      setState(() {});
    });

    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focus.hasFocus && animation.value == 0) {
      controller.forward();
      setState(() {
        isVisibleSearch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final category = Provider.of<CategoryModel>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListenableProvider.value(
        value: category,
        child: Consumer<CategoryModel>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return kLoadingWidget(context);
            }

            if (value.categories == null) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: const Text('Empty'),
              );
            }

            List<Category> categories = value.categories;
            if (widget.categories != null) {
              List<Category> _categories = [];
              for (var cat in widget.categories) {
                Category item = categories.firstWhere(
                    (element) => element.id.toString() == cat,
                    orElse: () => null);
                if (item != null) {
                  _categories.add(item);
                }
              }
              categories = _categories;
            }

            return SafeArea(
              child: ['grid', 'column', 'sideMenu', 'subCategories']
                      .contains(widget.layout)
                  ? Column(
                      children: <Widget>[
                        Container(
                          width: screenSize.width,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Container(
                              width: screenSize.width /
                                  (2 / (screenSize.height / screenSize.width)),
                              child: Padding(
                                child: Text(
                                  S.of(context).category,
                                  style: const TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, bottom: 20, right: 10),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: renderCategories(categories),
                        )
                      ],
                    )
                  : ListView(
                      children: <Widget>[
                        Container(
                          width: screenSize.width,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Container(
                              width: screenSize.width /
                                  (2 / (screenSize.height / screenSize.width)),
                              child: Padding(
                                child: Text(
                                  S.of(context).category,
                                  style: const TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, bottom: 20, right: 10),
                              ),
                            ),
                          ),
                        ),
                        renderCategories(categories)
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget renderCategories(value) {
    switch (widget.layout) {
      case 'card':
        return CardCategories(value);
      case 'column':
        return ColumnCategories(value);
      case 'subCategories':
        return SubCategories(value);
      case 'sideMenu':
        return SideMenuCategories(value);
      // case 'animation':
      //   return HorizonMenu(value);
      // case 'grid':
      //   return GridCategory(value, icons: widget.images,);
      default:
        return CardCategories(value);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
