import 'package:flutter/material.dart';

import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:get/get.dart';
import 'package:wallhaven/pages/global_theme.dart';
import 'package:wallhaven/store/store.dart';
import '/generated/l10n.dart';

class PictureFilter extends StatelessWidget {
  const PictureFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: GlobalTheme.backImg(GetBuilder<SearchQuery>(
          builder: (searchQuery) {
            void setSorting(String value) {
              searchQuery.setParams({'sorting': value});
            }

            bool sortingSelected(String value) {
              return searchQuery.params['sorting'] == value;
            }

            bool cateSelected(String key) {
              return searchQuery.categoriesMap[key] == '1';
            }

            bool puritySelected(String key) {
              return searchQuery.purityMap[key] == '1';
            }

            void setTopRang(String value) {
              searchQuery.setParams({'topRange': value});
            }

            bool topRangSel(String value) {
              return searchQuery.params['topRange'] == value;
            }

            bool disableTopRange() {
              return searchQuery.params['sorting'] != 'toplist';
            }

            List<HGFButton> list = [];
            list.addAll(FilterBtn.sortingBtn.map((v) => HGFButton(
                value: v['value']!,
                text: v['name']!,
                selected: sortingSelected(v['value']!),
                onSelected: setSorting)));

            List<HGFButton> categories = [];
            categories.addAll(FilterBtn.cateBtn.map((v) => HGFButton(
                value: v['value']!,
                text: v['name']!,
                selected: cateSelected(v['value']!),
                onSelected: searchQuery.setCategories)));

            List<HGFButton> topRange = [];
            topRange.addAll(FilterBtn.topRangeBtn.map((v) => HGFButton(
                value: v['value']!,
                text: v['name']!,
                disabled: disableTopRange(),
                selected: topRangSel(v['value']!),
                onSelected: setTopRang)));
            List<HGFButton> purity = [];
            purity.addAll(searchQuery.ptyMap.map((v) => HGFButton(
                type: v['type']!,
                text: v['name']!,
                selected: puritySelected(v['name']!),
                onSelected: searchQuery.setPurity)));
            Widget grid(List<HGFButton> btnList) {
              return SizedBox(
                width: double.infinity,
                child: GridView.builder(
                    physics: const PageScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    itemCount: btnList.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 120,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (_, i) => btnList[i]),
              );
            }

            Widget title(String text) {
              return SizedBox(
                width: double.infinity,
                height: 40,
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title(S.current.sorting),
                  grid(list),
                  title(S.current.categories),
                  grid(categories),
                  title(S.current.topRange),
                  grid(topRange),
                  title(S.current.purity),
                  grid(purity),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextField(
                      controller: TextEditingController(
                        text: '',
                      ),
                      textInputAction: TextInputAction.search,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (value) {
                        // TODO
                        searchQuery.setParams({'q': value});
                        // setKeyword(value);
                        Scaffold.of(context).closeDrawer();
                      },
                      decoration: const InputDecoration(
                          hintText: 'Search....',
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(0.5),
                        child: RawMaterialButton(
                          onPressed: () {
                            // TODO
                            // searchQuery.init();
                          },
                          child: const Text('search'),
                        )),
                  ),
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}

class HGFButton extends StatelessWidget {
  const HGFButton(
      {super.key,
      required this.text,
      required this.onSelected,
      required this.selected,
      this.type = '0',
      this.value = '',
      this.disabled = false,
      this.size});
  final String text;
  final String value;
  final bool selected;
  final Function onSelected;
  final String type;
  final bool disabled;
  final double? size;
  List<Color> getColor() {
    switch (type) {
      case '1':
        return [const Color(0xff99ff99), const Color(0xff447744)];
      case '2':
        return [const Color(0xffffff99), const Color(0xff777744)];
      case '3':
        return [const Color(0xffff9999), const Color(0xff774444)];
      default:
        return [const Color(0xffffffff), const Color(0xff5e5e5e)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return selected
        ? GFButton(
            onPressed: disabled
                ? null
                : () {
                    onSelected(value.isEmpty ? text : value);
                  },
            textColor: getColor()[0],
            disabledColor: const Color(0x1e1e1e80),
            color: getColor()[1],
            text: text,
            shape: GFButtonShape.standard,
            size: size ?? 35,
          )
        : GFButton(
            onPressed: disabled
                ? null
                : () {
                    onSelected(value.isEmpty ? text : value);
                  },
            textColor: const Color(0xffaaaaaa),
            color: const Color(0xff353535),
            disabledColor: const Color.fromARGB(255, 182, 182, 182),
            disabledTextColor: const Color.fromARGB(255, 32, 32, 32),
            text: text,
            shape: GFButtonShape.standard,
            size: size ?? 35,
          );
  }
}

class FilterBtn {
  static List<Map> topRangeBtn = [
    {'value': '1d', 'name': S.current.t_1d},
    {'value': '3d', 'name': S.current.t_3d},
    {'value': '1w', 'name': S.current.t_1w},
    {'value': '1M', 'name': S.current.t_1M},
    {'value': '3M', 'name': S.current.t_3M},
    {'value': '6M', 'name': S.current.t_6M},
    {'value': '1y', 'name': S.current.t_1y},
  ];
  static List<Map> sortingBtn = [
    {'value': 'toplist', 'name': S.current.topList},
    {'value': 'hot', 'name': S.current.hot},
    {'value': 'random', 'name': S.current.random},
    {'value': 'date_added', 'name': S.current.latest},
    {'value': 'views', 'name': S.current.views},
    {'value': 'favorites', 'name': S.current.favorites},
    {'value': 'relevance', 'name': S.current.relevance},
  ];
  static List<Map> cateBtn = [
    {'value': 'general', 'name': S.current.general},
    {'value': 'anime', 'name': S.current.anime},
    {'value': 'people', 'name': S.current.people},
  ];
}
