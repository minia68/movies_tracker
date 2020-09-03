import 'package:virtual_keyboard/virtual_keyboard.dart';

import '../../data/movies_service.dart';
import 'package:domain/domain.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final MoviesService _moviesService;
  final searchResult = SearchState(data: []).obs;
  bool shiftEnabled = false;
  var text = ''.obs;

  SearchController(this._moviesService);

  void onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text.value += (shiftEnabled ? key.capsText : key.text);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.value.length == 0) return;
          text.value = text.value.substring(0, text.value.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          _search(text.value);
          break;
        case VirtualKeyboardKeyAction.Space:
          text.value += key.text;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
  }

  Future<void> _search(String search) async {
    searchResult.value = SearchState();
    try {
      searchResult.value =
          SearchState(data: await _moviesService.searchTorrents(search));
    } catch (e, s) {
      print(s);
      searchResult.value = SearchState(error: e.toString());
    }
  }
}

class SearchState {
  final List<MovieTorrentInfo> data;
  final String error;

  SearchState({this.data, this.error});
}
