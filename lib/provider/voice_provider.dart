import 'package:snap_app/provider/base_provider.dart';

class VoiceProvider extends BaseProvider{

  bool record = false;

  updateRecord(bool val){
    record = val;
    notifyListeners();
  }

}