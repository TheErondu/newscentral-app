import 'package:flutter/material.dart';

import 'blog_news.dart';

class RecentModel with ChangeNotifier {
  List<BlogNews> blogs = [];

  void addRecentBlog(BlogNews blog) {
    blogs.removeWhere((index) => index.id == blog.id);
    if (blogs.length == 20) blogs.removeLast();
    blogs.insert(0, blog);
    notifyListeners();
  }
}
