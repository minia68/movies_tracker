import '../../data/movies_service.dart';
import 'search_controller.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<SearchController>(
        global: false,
        init: SearchController(Get.find<MoviesService>()),
        builder: (controller) {
          if (controller.searchResult.value.error != null) {
            return Center(child: Text(controller.searchResult.value.error));
          }
          if (controller.searchResult.value.data != null) {
            return _buildBody(controller);
          }
          return Center(
            child: SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(SearchController controller) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.keyboard_voice),
              onPressed: () {},
            ),
            SizedBox(width: 24),
            Expanded(flex: 2, child: Obx(() => Text(controller.text.value))),
            Expanded(
              flex: 3,
              child: VirtualKeyboard(
                height: 150,
                textColor: Colors.white,
                type: VirtualKeyboardType.Alphanumeric,
                onKeyPress: controller.onKeyPress,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, i) =>
                _buildSearchResult(controller.searchResult.value.data[i]),
            itemCount: controller.searchResult.value.data.length,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResult(MovieTorrentInfo data) {
    return RawMaterialButton(
      onPressed: () {},
      child: ListTile(
        //TODO separate widget
        title: Text(
          '${data.title}',
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          '${(data.size / 1000000000).toStringAsFixed(1)} GB '
          'S:${data.seeders} L:${data.leechers}',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
