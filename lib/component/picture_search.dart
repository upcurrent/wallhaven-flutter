import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/drawer/gf_drawer.dart';
import 'package:wallhevan/component/picture_grid_view.dart';
import 'package:wallhevan/store/store.dart';

import '../pages/global_theme.dart';
import '../pages/picture_filter.dart';

class PictureSearch extends StatelessWidget {
  final String keyword;
  final String tag;

  const PictureSearch({super.key, required this.keyword, required this.tag});

  @override
  Widget build(BuildContext context) {
    void init(PageLoadController load, String value) {
      load.q = value;
      load.init(renderer: true);
      getPictureList(load);
    }
    return Scaffold(
      drawer: Drawer(
        width: 400,
        // elevation: 0,
        child: GlobalTheme.backImg(const PictureFilter()),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
                iconSize: 35,
                padding:const EdgeInsets.fromLTRB(8, 8, 0, 8),
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          },
        ),
        title: GetBuilder<PageLoadController>(
          tag: tag,
          builder: (load) {
            return TextField(
              controller: TextEditingController(
                text: load.q,
              ),
              autofocus: keyword.isEmpty,
              textInputAction: TextInputAction.search,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white,fontSize: 20),
              onSubmitted: (value) {
                init(load,value);
              },
              decoration: const InputDecoration(
                  hintText: 'Search....',
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
            );
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: GetBuilder<PageLoadController>(
          tag: tag,
          builder: (load) {
            return PictureGridView(
                pictures: load.pictures,
                loadMore: load.loadMore,
                toViews: load.toViews);
          },
        ),
      ),
    );
  }
}
