import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallhevan/component/picture_comp.dart';
import 'package:wallhevan/pages/search_query.dart';
import 'package:wallhevan/store/store.dart';
import 'package:getwidget/getwidget.dart';
import '../component/search_page.dart';
import '../store/picture_res/picture_data.dart';
import 'global_theme.dart';
import '/generated/l10n.dart';

class PictureViews extends StatefulWidget {
  const PictureViews({
    super.key,
    required this.load,
    required this.curIndex,
  });
  final PageLoadController load;
  final int curIndex;
  @override
  State<StatefulWidget> createState() => _PictureViewsState();
}

class _PictureViewsState extends State<PictureViews> {
  final StoreController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.updatePic(widget.load.pictures[widget.curIndex].path);
  }

  @override
  void dispose() {
    Timer(const Duration(milliseconds: 100), () {
      widget.load.renderer();
    });
    super.dispose();
  }

  void addSearchPage(BuildContext context, String keyword) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SearchBarPage(
                keyword: keyword, tag: getTag(q: keyword, sort: 'relevance'))));
  }

  @override
  Widget build(BuildContext context) {
    var load = widget.load;
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: ExtendedImageSlidePage(
          slideAxis: SlideAxis.vertical,
          slideType: SlideType.onlyImage,
          onSlidingPage: (state) {},
          // slideScaleHandler:(offset){
          //
          // },
          // slideEndHandler: (){
          //
          // },
          child: GlobalTheme.backImg(
            GetBuilder(
                init: load,
                builder: (_) {
                  return ExtendedImageGesturePageView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var picture = load.pictures[index];
                      Widget image = PictureComp(
                          image: picture,
                          type: PictureComp.pictureViews,
                          url: picture.path);
                      image = SingleChildScrollView(
                          child: Column(
                        children: [
                          // Expanded(child: image),
                          image,
                          Center(
                              child: HGFButton(
                            text: S.current.more,
                            type: "1",
                            selected: true,
                            size: 44,
                            onSelected: (_) =>
                                addSearchPage(context, 'like:${picture.id}'),
                          )),
                          picDataBuild(
                              picture.id,
                              (int tagId) =>
                                  addSearchPage(context, 'id:$tagId')),
                        ],
                      ));
                      // image = Center(
                      //   child: image,
                      // );
                      if (index == widget.curIndex) {
                        return Hero(
                          tag: picture.path + index.toString(),
                          child: image,
                        );
                      } else {
                        return image;
                      }
                    },
                    itemCount: load.pictures.length,
                    onPageChanged: (int index) {
                      controller.updatePic(load.pictures[index].path);
                      if (index >= load.pictures.length - 2) {
                        getPictureList(load);
                      }
                    },
                    controller: ExtendedPageController(
                      initialPage: widget.curIndex,
                    ),
                    scrollDirection: Axis.horizontal,
                  );
                }),
          )),
    );
  }
}
Widget picDataBuild(String id, Function showSearch) {
  String getType(String purity) {
    switch (purity) {
      case 'sketchy':
        return '2';
      case 'nsfw':
        return '3';
      default:
        return '1';
    }
  }

  return FutureBuilder<PictureData>(
      future: getPictureInfo(id),
      builder: (context, AsyncSnapshot<PictureData> snapshot) {
        var data = snapshot.data;
        if (data != null) {
          var tags = data.tags;
          List<Widget> tagWidgets = [];
          tagWidgets.addAll(tags.map((tag) => HGFButton(
              type: getType(tag.purity),
              text: tag.name,
              selected: true,
              onSelected: (_) => showSearch(tag.id))));
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  color: Colors.transparent,
                  child: GFListTile(
                      avatar: GFAvatar(
                        backgroundImage:
                            NetworkImage(data.uploader!.avatar!.p128),
                      ),
                      color: Colors.transparent,
                      titleText: data.uploader!.username,
                      listItemTextColor: GFColors.WHITE,
                      icon: const Icon(Icons.favorite))),
              Wrap(
                spacing: 2,
                children: tagWidgets,
              )
            ],
          );
        }
        return Container();
      });
}
