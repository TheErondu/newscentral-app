import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/styles.dart';
import '../../generated/l10n.dart';
import '../../models/search.dart';
import '../../widgets/blog_news/blog_card_view.dart';

class Recent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var screenWidth = constraints.maxWidth;

        return ListenableProvider.value(
          value: Provider.of<SearchModel>(context, listen: false),
          child: Consumer<SearchModel>(builder: (context, model, child) {
            if (model.blogs == null || model.blogs.isEmpty) {
              return Container();
            }
            return Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(S.of(context).recents,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
//                FlatButton(
//                    onPressed: null,
//                    child: Text(
//                      S.of(context).seeAll,
//                      style: TextStyle(color: Colors.greenAccent, fontSize: 13),
//                    ))
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  height: 1,
                  color: kGrey200,
                ),
                const SizedBox(height: 10),
                Container(
                  height: screenWidth * 0.35 + 120,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var item in model.blogs)
                          BlogCard(item: item, width: screenWidth * 0.35)
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
