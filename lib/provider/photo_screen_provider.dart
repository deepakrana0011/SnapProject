import 'package:flutter/material.dart';
import 'package:snap_app/provider/base_provider.dart';

class PhotoScreenProvider extends BaseProvider{
   Color pickerColor = const Color(0xff443a49);
   Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
     pickerColor = color;
     notifyListeners();
  }

  bool color = false;

  updateColor(bool val){
    color = val;
    notifyListeners();
  }
}