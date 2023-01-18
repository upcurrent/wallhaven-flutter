import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallhevan/component/pictire_page_view.dart';
import 'package:wallhevan/store/search_res/picture_info.dart';
import 'package:wallhevan/store/search_res/search_result.dart';
import 'package:wallhevan/store/collection_res/fav_data.dart';
import '/api/api.dart';
import 'collection_res/fav_response.dart';
import 'package:wallhevan/store/picture_res/picture_data.dart';
import 'package:wallhevan/store/picture_res/picture_res.dart';

class StorageManger {
  static SharedPreferences? _prefs;
  static Future<SharedPreferences> get prefs async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<String> getApiKey() async {
    SharedPreferences prefs = await StorageManger.prefs;
    return prefs.getString('apiKey') ?? 'MJq2IZyeA8QI43iccfNDJSpWQ8qKw8w5';
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await StorageManger.prefs;
    return prefs.getString('userName') ?? 'ikism';
  }

  static void setParams(Map<String, String> params) async {
    SharedPreferences prefs = await StorageManger.prefs;
    params.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  static Future<String> getParams() async {
    SharedPreferences prefs = await StorageManger.prefs;
    return prefs.getString('userName') ?? 'ikism';
  }
}

class StoreController extends GetxController {
  var cachePic = <String>{};
  var cachePictureData = <String, PictureData>{};
  final ScrollController homeScrollCtrl =
      ScrollController(keepScrollOffset: false);

  void updatePic(String path) {
    if (cachePic.contains(path)) return;
    cachePic.add(path);
  }

  void updatePictureData(String id, PictureData value) {
    if (cachePictureData.containsKey(id)) return;
    cachePictureData.addAll({id: value});
    update();
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
    setParams({'categories': join(categoriesMap.values)});
    update();
    StorageManger.setParams(categoriesMap);
  }

  void setPurity(String key) {
    purityMap[key] = purityMap[key] == '0' ? '1' : '0';
    var purity = join(purityMap.values);
    if(purity == '000'){
      purityMap[key] = '1';
      purity = join(purityMap.values);
    }
    setParams({'purity': purity});
    update();
    StorageManger.setParams(purityMap);
  }

  String join(Iterable<String> i) {
    List<String> list = [];
    list.addAll(i);
    return list.join('');
  }

  void setParams(Map<String, String> data) {
    params.addAll(data);
    update();
  }

  @override
  void onInit() {
    getStorageParams();
    super.onInit();
  }

  Future<void> getStorageParams() async {
    var prefs = await StorageManger.prefs;
    var cate = <String, String>{};
    var purity = <String, String>{};
    categoriesMap.forEach((key, value) {
      String v = prefs.getString(key) ?? value;
      cate.addAll({key: v});
    });
    purityMap.forEach((key, value) {
      String v = prefs.getString(key) ?? value;
      purity.addAll({key: v});
    });
    categoriesMap.addAll(cate);
    purityMap.addAll(purity);
    params.addAll({'categories': join(categoriesMap.values)});
    params.addAll({'purity': join(purityMap.values)});
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

  void loadStart() {
    loading = true;
    update();
  }

  void loadMore() {}

  void renderer() {
    update();
  }

  void toViews(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PicturePageView(
                  pictures: pictures,
                  curIndex: index,
                  loadMore: loadMore,
                  renderer: renderer,
                )));
  }
}

class PageLoadController extends BasicController {
  String q = '';
  String sort = 'toplist';
  String seed = '';

  @override
  void onInit() {
    // getPictureList(this); // TODO
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
  }

  @override
  void loadMore() {
    getPictureList(this);
  }
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
    // getFavorites(this); // TODO
  }

  @override
  void loadMore() {
    getCollectionList(this);
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
  load.loadStart();
  getPictureAPI(params).then((response) {
    load.loading = false;
    SearchResult searchResult = SearchResult.fromJson(response.data);
    final meta = searchResult.meta;
    int total = 0;
    String seed = '';
    if (meta != null) {
      total = meta.total;
      if (params['sorting'] == 'random' &&
          (load.pageNum == 1 || load.seed.isEmpty == true)) {
        seed = meta.seed;
      }
    }
    load.setPictures(searchResult.data, total, seed);
    // ignore: invalid_return_type_for_catch_error, avoid_print
  }).catchError((error) => {print(error.toString())});
}

Future<void> getCollectionList(CollectionController load) async {
  if (load.loading) return;
  Map<String, dynamic> params = {
    'apikey': await StorageManger.getApiKey(),
  };
  load.loadStart();
  getCollectionsAPI(params).then((response) {
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
  SearchQuery query = Get.find();
  int id = load.collectionId;
  if (id == 0) return;
  var params = {
    'page': load.pageNum.toString(),
    'purity': query.params['purity'],
    'apikey': await StorageManger.getApiKey(),
  };
  load.loading = true;
  getFavoritesAPI(params, id).then((response) {
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
  var res = await dio.get('/api/v1/w/$id', queryParameters: {'apikey': apiKey});
  PictureRes response = PictureRes.fromJson(res.data);
  data = response.data!;
  store.updatePictureData(id, data);
  return data;
}
