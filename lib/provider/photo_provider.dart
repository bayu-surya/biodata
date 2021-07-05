import 'package:flutter/foundation.dart';

class PhotoProvider extends ChangeNotifier {
  String _photo = "";

  String get photo => _photo;

  void complete(String photo) {
    _photo=photo;
    notifyListeners();
  }
}