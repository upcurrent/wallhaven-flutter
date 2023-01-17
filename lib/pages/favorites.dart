import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallhevan/pages/global_theme.dart';
import 'package:wallhevan/pages/fav_list.dart';
import 'package:wallhevan/pages/search_query.dart';
import 'package:wallhevan/store/store.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  
  @override
  void initState() {
    super.initState();
    CollectionController controller = Get.find();
    getCollectionList(controller);
  }

  List<Widget> getBtn(CollectionController controller) {
    List<Widget> tabs = [];
    for (var fav in controller.collections) {
      tabs.add(
        HGFButton(
            type: '0',
            text: fav.label,
            selected: fav.id == controller.collectionId,
            onSelected: (value) {
              controller.switchCollection(fav.id);
            }),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CollectionController>(
      builder: (controller) {
      return GlobalTheme.backImg(Scaffold(
        backgroundColor: Colors.transparent,
        body: NestedScrollView(
            headerSliverBuilder: (context, sel) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0,
                  pinned: false,
                  snap: false,
                  floating: false,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    children: getBtn(controller),
                  ),
                )
              ];
            },
            body: const FavPictureList(
              keepAlive: false,
            )),
      ));
    });
  }
}
