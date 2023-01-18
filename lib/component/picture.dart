import 'package:flutter/material.dart';
import 'package:wallhevan/component/picture_comp.dart';

import '../pages/global_theme.dart';
import '../store/search_res/picture_info.dart';

class Picture extends StatelessWidget {
  const Picture({super.key});

  @override
  Widget build(BuildContext context) {
    PictureInfo routeParams =
        ModalRoute.of(context)?.settings.arguments as PictureInfo;
    return Scaffold(
      body: GlobalTheme.backImg(Center(child: PictureComp(image: routeParams, type: PictureComp.fallSizePicture,url:routeParams.path))),
      // border: Border.all(color: Colors.red, width: 1.0),
      // shape: boxShape,
      // borderRadius: BorderRadius.all(Radius.circular(30.0)),
      //cancelToken: cancellationToken,
    );
  }
}
