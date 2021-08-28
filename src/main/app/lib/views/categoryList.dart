import 'package:after_layout/after_layout.dart';
import 'package:app/components/categories/categoryGrid.dart';
import 'package:app/components/dummies/dummyGrid.dart';
import 'package:app/globals.dart';
import 'package:app/models/category.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  CategoryList() : super();

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList>
    with AfterLayoutMixin<CategoryList> {
  List<Category>? categories;
  Widget grid = DummyGrid();

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    FBroadcast.instance().unregister(this);
    super.dispose();
  }

  Future<void> loadCategories() async {
    List<Category> categories = await service.getCategories();
    if (this.mounted) {
      setState(() {
        this.categories = categories;
        this.grid = CategoryGrid(this.categories as List<Category>);
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadCategories();
    FBroadcast.instance().register(BROADCAST_REFRESH_CATEGORIES,
        (context, somethingElse) => loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: panelTransition,
      child: grid,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
