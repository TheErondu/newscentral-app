import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/app.dart';
import '../../models/blog_news.dart';
import '../../models/category.dart';
import '../../services/wordpress.dart';
import '../../widgets/blog/detailed_blog/blog_view.dart';
//import '../../widgets/product/product_list.dart';

class SideMenuCategories extends StatefulWidget {
  final List<Category> categories;

  SideMenuCategories(this.categories);

  @override
  State<StatefulWidget> createState() {
    return SideMenuCategoriesState();
  }
}

class SideMenuCategoriesState extends State<SideMenuCategories> {
  int selectedIndex = 0;
  final WordPress _service = WordPress();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Container(
          width: 100,
          color: Theme.of(context).primaryColorLight,
          child: ListView.builder(
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 4, right: 4),
                    child: Center(
                      child: Text(
                        widget.categories[index] != null &&
                                widget.categories[index].name != null
                            ? widget.categories[index].name.toUpperCase()
                            : '',
                        style: TextStyle(
                          fontSize: 10,
                          color: selectedIndex == index
                              ? theme.primaryColor
                              : theme.accentColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(child: LayoutBuilder(
          builder: (context, constraints) {
            return FutureBuilder<List<BlogNews>>(
              future: _service.fetchBlogsByCategory(
                  lang: Provider.of<AppModel>(context, listen: false).locale,
                  categoryId: widget.categories[selectedIndex].id),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BlogNews>> snapshot) {
                if (!snapshot.hasData) {
                  return kLoadingWidget(context);
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(
                      snapshot.data.length,
                      (index) {
                        return BlogCardView(
                          blogs: snapshot.data,
                          index: index,
                          width: constraints.maxWidth,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ))
      ],
    );
  }
}
