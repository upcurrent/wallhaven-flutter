import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallhevan/store/search_response/picture_info.dart';
import 'package:wallhevan/store/search_response/search_result.dart';
import 'package:wallhevan/store/collections/fav_data.dart';
import '/generated/l10n.dart';
import '/api/api.dart';
import 'package:dio/dio.dart' as dio_lib;
import 'collections/fav_response.dart';
import 'package:wallhevan/store/picture_res/picture_data.dart';
import 'package:wallhevan/store/picture_res/picture_res.dart';
import 'package:wallhevan/pages/picture_views.dart';

class StoreController {
  var cachePic = <String>{}.obs;
  var cachePictureData = <String, PictureData>{}.obs;
  final ScrollController homeScrollCtrl =
      ScrollController(keepScrollOffset: false);

  void updatePic(String path) {
    if (cachePic.contains(path)) return;
    cachePic().add(path);
  }

  void updatePictureData(String id, PictureData value) {
    if (cachePictureData.containsKey(id)) return;
    cachePictureData.addAll({id: value});
  }

  void homeScrollTop() {
    homeScrollCtrl.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }
}

String getTag({String q = "", String sort = "toplist"}) {
  String tag = "${DateTime.now().millisecondsSinceEpoch}";
  PageLoadController load = PageLoadController();
  load.q = q;
  load.sort = sort;
  Get.put(load, tag: tag);
  return tag;
}

class SearchQuery extends GetxController {
  final List<Map> topRangeBtn = [
    {'value': '1d', 'name': S.current.t_1d},
    {'value': '3d', 'name': S.current.t_3d},
    {'value': '1w', 'name': S.current.t_1w},
    {'value': '1M', 'name': S.current.t_1M},
    {'value': '3M', 'name': S.current.t_3M},
    {'value': '6M', 'name': S.current.t_6M},
    {'value': '1y', 'name': S.current.t_1y},
  ];
  final List<Map> sortingBtn = [
    {'value': 'toplist', 'name': S.current.topList},
    {'value': 'hot', 'name': S.current.hot},
    {'value': 'random', 'name': S.current.random},
    {'value': 'date_added', 'name': S.current.latest},
    {'value': 'views', 'name': S.current.views},
    {'value': 'favorites', 'name': S.current.favorites},
    {'value': 'relevance', 'name': S.current.relevance},
  ];
  final List<Map> cateBtn = [
    {'value': 'general', 'name': S.current.general},
    {'value': 'anime', 'name': S.current.anime},
    {'value': 'people', 'name': S.current.people},
  ];
  final Map<String, String> params = {
    'categories': '010',
    'purity': '110',
    'topRange': '1M',
    'sorting': 'toplist',
    'order': 'desc',
  };
  final List<Map> ptyMap = [
    {'name': 'SFW', 'type': '1'},
    {'name': 'Sketchy', 'type': '2'},
    {'name': 'NSFW', 'type': '3'},
  ];
  final Map<String, String> categoriesMap = {
    'general': '1',
    'anime': '0',
    'people': '0',
  };

  final Map<String, String> purityMap = {
    'SFW': '1',
    'Sketchy': '0',
    'NSFW': '0',
  };

  void setCategories(String key) {
    categoriesMap[key] = categoriesMap[key] == '0' ? '1' : '0';
    List<String> cateStr = [];
    cateStr.addAll(categoriesMap.values);
    params.addAll({'categories': cateStr.join('')});
    update();
  }

  void setPurity(String key) {
    purityMap[key] = purityMap[key] == '0' ? '1' : '0';
    List<String> purityStr = [];
    purityStr.addAll(purityMap.values);
    params.addAll({'purity': purityStr.join('')});
    update();
  }

  void setParams(Map<String, String> data) {
    params.addAll(data);
    update();
  }
}

class BasicController extends GetxController {
  int pageNum = 1;
  int total = 0;
  bool loading = false;
  List<PictureInfo> pictures = [];
  void init({renderer = false}) {
    pageNum = 1;
    total = 0;
    pictures.clear();
    if (renderer) {
      update();
    }
  }

  void renderer() {
    update();
  }
}

class PageLoadController extends BasicController {
  String q = '';
  String sort = 'toplist';
  String seed = '';

  @override
  void onInit() {
    getPictureList(this);
    super.onInit();
  }

  void setPictures(List<PictureInfo>? data, int total, String seed) {
    if (data != null) {
      pictures.addAll(data);
      pageNum++;
    }
    this.total = total;
    this.seed = seed;
    update();
    printError(info:"5435");
  }

  void loadMore() {
    getPictureList(this);
  }

  void toViews(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PictureViews(
                  curIndex: index,
                  load: this,
                )));
  }
}

Future<void> getPictureList(PageLoadController load) async {
  if (load.loading) return;
  if (load.pageNum != 1 && load.pictures.length >= load.total) return;
  SearchQuery query = Get.find();
  Map<String, String> params = <String, String>{}..addAll(query.params);
  params['q'] = load.q;
  params['page'] = "${load.pageNum}";
  params['apikey'] ??= await StorageManger.getApiKey();
  params['sorting'] = (load.sort.isEmpty ? params['sorting'] : load.sort)!;
  if (params['sorting'] == 'random') {
    params['seed'] = load.seed;
  }
  load.loading = true;
  dio
      .get(
    '/api/v1/search',
    queryParameters: params,
  )
      .then((response) {
    load.loading = false;
    SearchResult searchResult = SearchResult.fromJson(response.data);
    final meta = searchResult.meta;
    int total = 0;
    String seed = '';
    if (meta != null) {
      total = meta.total;
      if (params['sorting'] == 'random' && params['seed']?.isEmpty == true) {
        params['seed'] = meta.seed;
        seed = meta.seed;
      }
    }
    load.setPictures(searchResult.data, total, seed);
    // ignore: invalid_return_type_for_catch_error, avoid_print
  }).catchError((error) => {print(error.toString())});
}

class CollectionController extends BasicController {
  List<FavData> collections = [];
  int collectionId = 0;
  void setCollection(List<FavData>? collections) {
    if (collections != null) {
      this.collections = collections;
      collectionId = collections[0].id;
      update();
      getFavorites(this);
    }
  }

  void setPictures(List<PictureInfo>? data, int total) {
    if (data != null) {
      if (pageNum == 1) {
        pictures.clear();
      }
      pictures.addAll(data);
      pageNum++;
      this.total = total;
    }
    update();
  }

  void switchCollection(int id) {
    collectionId = id;
    pageNum = 1;
    update();
    getFavorites(this);
  }
}

Future<void> getCollectionList(CollectionController load) async {
  if (load.loading) return;
  Map<String, dynamic> params = {
    'apikey': await StorageManger.getApiKey(),
  };
  load.loading = true;
  dio
      .get(
    '/api/v1/collections',
    queryParameters: params,
  )
      .then((response) {
    load.loading = false;
    FavoritesRes collectionList = FavoritesRes.fromJson(response.data);
    load.setCollection(collectionList.favData);
    // ignore: invalid_return_type_for_catch_error, avoid_print
  }).catchError((error) => {print(error.toString())});
}

Future<void> getFavorites(CollectionController load) async {
  if (load.loading) return;
  if (load.pageNum != 1 && load.pictures.length >= load.total) {
    return;
  }
  int id = load.collectionId;
  if (id == 0) return;
  var params = {
    'page': load.pageNum.toString(),
    'purity': '111',
    'apikey': await StorageManger.getApiKey(),
  };
  load.loading = true;
  dio
      .get(
    '/api/v1/collections/${await StorageManger.getUserName()}/$id',
    queryParameters: params,
  )
      .then((response) {
    load.loading = false;
    SearchResult favorites = SearchResult.fromJson(response.data);
    final meta = favorites.meta;
    load.setPictures(favorites.data, meta!.total);
    // ignore: invalid_return_type_for_catch_error, avoid_print
  }).catchError((error) => {print(error.toString())});
}

Future<PictureData> getPictureInfo(String id) async {
  StoreController store = Get.find();
  PictureData? data = store.cachePictureData[id];
  if (data != null) {
    return data;
  }
  String apiKey = await StorageManger.getApiKey();
  dio_lib.Response res =
      await dio.get('/api/v1/w/$id', queryParameters: {'apikey': apiKey});
  PictureRes response = PictureRes.fromJson(res.data);
  data = response.data!;
  store.updatePictureData(id, data);
  return data;
}
