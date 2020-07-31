import 'package:dio/dio.dart';
import 'package:sarscovid19/model/total_model.dart';

class Api {
  Dio dio = Dio();
  final String daily =
      "https://corona.lmao.ninja/v3/covid-19/historical/all?lastdays=15";
  final String _api = 'https://corona.lmao.ninja/v2/all';

  Future<TotalModel> getTotal() async {
    try {
      Response response = await dio.get(_api);
      return TotalModel.fromJson(response.data);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> getDaily() async {
    try {
      Response response = await dio.get((daily));

      return response.data;
    } catch (error) {
      return null;
    }
  }
}
