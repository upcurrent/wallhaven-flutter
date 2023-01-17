import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:wallhevan/pages/global_theme.dart';
import 'package:wallhevan/store/search_response/picture_info.dart';

import '/component/picture_comp.dart';
import '/store/store.dart';

class PictureGridView extends StatefulWidget {
  const PictureGridView({super.key, this.keepAlive, required this.pictures, required this.loadMore, required this.toViews});

  final bool? keepAlive;

  final List<PictureInfo> pictures;

  final Function loadMore;

  final Function toViews;

  @override
  State<StatefulWidget> createState() {
    return _PictureGridViewState();
  }
}

class _PictureGridViewState extends State<PictureGridView>
    with AutomaticKeepAliveClientMixin {
  StoreController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var pictures = widget.pictures;
    return GlobalTheme.backImg(NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 400) {
            widget.loadMore();
            return true;
          }
          return false;
        },
        child: MasonryGridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          itemCount: widget.pictures.length,
          itemBuilder: (context, index) {
            String url = pictures[index].thumbs.original!;
            String path = pictures[index].path;
            return GestureDetector(onTap: () {
              widget.toViews(context,index);
            }, child: Obx(() {
              return controller.cachePic.contains(path)
                  ? PictureComp.create(context, pictures[index], path)
                  : PictureComp.create(context, pictures[index], url);
            }));
          },
        )));
  }

  @override
  bool get wantKeepAlive => widget.keepAlive ?? true;
}
