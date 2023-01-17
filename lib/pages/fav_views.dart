import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallhevan/component/picture_comp.dart';
import 'package:wallhevan/pages/search_query.dart';
import 'package:wallhevan/store/store.dart';
import '../component/search_page.dart';
import 'global_theme.dart';
import '/generated/l10n.dart';
import './picture_views.dart' show picDataBuild;

class FavPictureViews extends StatefulWidget {
  const FavPictureViews({
    super.key,
    required this.curIndex,
  });
  final int curIndex;
  @override
  State<StatefulWidget> createState() => _FavPictureViewsState();
}

class _FavPictureViewsState extends State<FavPictureViews> {
  CollectionController load = Get.find();

  final StoreController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.updatePic(load.pictures[widget.curIndex].path);
  }

  @override
  void dispose() {
    Timer(const Duration(milliseconds: 100), () {
      load.renderer();
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
                        getFavorites(load);
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
