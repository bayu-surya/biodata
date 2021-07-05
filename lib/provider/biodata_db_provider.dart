import 'package:biodata/data/db/biodata_database_helper.dart';
import 'package:biodata/data/model/biodata.dart';
import 'package:biodata/utils/result_state.dart';
import 'package:flutter/foundation.dart';

class BiodataDbProvider extends ChangeNotifier {
  final BiodataDatabaseHelper databaseHelper;

  BiodataDbProvider({@required this.databaseHelper}){
    _getBiodata();
  }

  ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Biodata> _biodata = [];
  List<Biodata> get biodata => _biodata;

  void _getBiodata() async {
    _biodata = await databaseHelper.getBiodata();
    if (_biodata.length > 0) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  Future<Biodata> getBiodataByid(String id) async {
    List<Biodata> data = await databaseHelper.getBiodataId(id);
    return data.first;
  }

  Future<bool> isBiodata(String id) async {
    final favoriteRestaurant = await databaseHelper.getBiodataById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void addBiodata(Biodata article) async {
    try {
      await databaseHelper.insertBiodata(article);
      _getBiodata();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void updateBiodata(Biodata article) async {
    try {
      await databaseHelper.updateBiodata(article);
      _getBiodata();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void removeBiodata(String url) async {
    try {
      await databaseHelper.removeBiodata(url);
      _getBiodata();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
