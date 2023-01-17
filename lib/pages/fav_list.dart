import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallhevan/pages/global_theme.dart';
import 'package:wallhevan/pages/fav_views.dart';
import 'package:wallhevan/store/search_response/picture_info.dart';
import 'package:wallhevan/store/store.dart';
import 'package:get/get.dart';

import '../component/picture_comp.dart';

class FavPictureList extends StatefulWidget {
  const FavPictureList({super.key, this.keepAlive});

  final bool? keepAlive;

  @override
  State<StatefulWidget> createState() {
    return _FavPictureListState();
  }
}

class _FavPictureListState extends State<FavPictureList>
    with AutomaticKeepAliveClientMixin {
  StoreController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GlobalTheme.backImg(GetBuilder<CollectionController>(
        builder: (collection) {
          List<PictureInfo> pictures = collection.pictures;
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 400) {
                getFavorites(collection);
                return true;
              }
              return false;
            },
            child: MasonryGridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 2,
              itemCount: pictures.length,
              itemBuilder: (context, index) {
                String url = pictures[index].thumbs.original!;
                String path = pictures[index].path;
                return GestureDetector(onTap: () {
                  // listModel.preview(path);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FavPictureViews(
                                curIndex: index,
                              )));
                }, child: Obx(() {
                  return controller.cachePic.contains(path)
                      ? PictureComp.create(context, collection.pictures[index], path)
                      : PictureComp.create(context, collection.pictures[index], url);
                }));
              },
            ),
          );
        }));
  }

  @override
  bool get wantKeepAlive => widget.keepAlive ?? true;
}
