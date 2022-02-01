import 'package:flutter/material.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/locator.dart';
import 'package:snap_app/service/api.dart';

class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  Api api = locator<Api>();

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

}