import 'package:flutter/material.dart';
import 'package:jasmine/basic/commons.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/configs/login.dart';
import 'package:jasmine/screens/components/comic_pager.dart';

import 'components/right_click_pop.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _folderId = 0;

  final Map<int, String> _folderMap = {
    0: "全部",
  };

  _chooseFolder() async {
    int? f = await chooseMapDialog(
      context,
      values: _folderMap.map((key, value) => MapEntry(value, key)),
      title: "选择文件夹",
    );
    if (f != null) {
      setState(() {
        _folderId = f;
      });
    }
  }

  @override
  void initState() {
    for (var value in selfInfo.favoriteList) {
      try {
        _folderMap[int.parse(value.fid)] = value.name;
      } catch (e) {}
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return rightClickPop(child: buildScreen(context), context: context);
  }

  Widget buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("收藏夹"),
        actions: [
          MaterialButton(
            textColor: Colors.white,
            onPressed: _chooseFolder,
            child: Text(_folderMap[_folderId] ?? ""),
          ),
        ],
      ),
      body: ComicPager(
        key: Key("FAVOUR:$_folderId"),
        onPage: (int page) async {
          final response = await methods.favorites(_folderId, page);
          return InnerComicPage(total: response.total, list: response.list);
        },
      ),
    );
  }
}
