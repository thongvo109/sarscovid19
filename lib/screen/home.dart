import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sarscovid19/api/api.dart';
import 'package:sarscovid19/help/help.dart';
import 'package:sarscovid19/model/linechart_model.dart';
import 'package:sarscovid19/model/total_model.dart';
import 'package:sarscovid19/widget/cases_chart.dart';
import 'package:sarscovid19/widget/death_chart.dart';
import 'package:sarscovid19/widget/item_show.dart';
import 'package:sarscovid19/widget/recovered_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  TotalModel total;
  RefreshController _refreshController;
  bool _isLoading;
  List<LineChartModel> listCases = List();
  List<LineChartModel> listDeath = List();
  List<LineChartModel> listRecovered = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    _refreshController = RefreshController();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getData();
    getDaily();
    initializeDateFormatting();
  }

  void getDaily() async {
    var data = await Api().getDaily();
    if (data != null) {
      setState(() {
        for (var item in data['cases'].entries) {
          var time = Help.convertTimeStamp('${item.key}');
          listCases.add(LineChartModel(
              timeStamp: DateTime.fromMicrosecondsSinceEpoch(time),
              value: item.value));
        }
        for (var item in data['deaths'].entries) {
          var time = Help.convertTimeStamp('${item.key}');
          listDeath.add(LineChartModel(
              timeStamp: DateTime.fromMicrosecondsSinceEpoch(time),
              value: item.value));
        }
        for (var item in data['recovered'].entries) {
          var time = Help.convertTimeStamp('${item.key}');
          listRecovered.add(LineChartModel(
              timeStamp: DateTime.fromMicrosecondsSinceEpoch(time),
              value: item.value));
        }
      });
    } else {
      print('Error Internet');
    }
  }

  void getData() async {
    TotalModel totalModel = await Api().getTotal();
    if (totalModel != null) {
      setState(() {
        _isLoading = false;
        _refreshController.refreshCompleted();
        total = totalModel;
      });
    } else {
      _refreshController.refreshFailed();
      setState(() {
        _isLoading = false;
      });
      print('Error Internet');
    }
  }

  void _onRefresh() {
    setState(() {
      listCases = [];
      listDeath = [];
      listRecovered = [];
      _isLoading = true;
      _refreshController.resetNoData();
    });
    getData();
    getDaily();
  }

  void onLoading() {
    getData();
    getDaily();
  }

  Widget _buildBody() {
    var sizeHeight = MediaQuery.of(context).size.width;
    Widget renderBody;
    if (listCases.length > 0) {
      renderBody = SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ItemShow(
              typeName: 'Total cases: ',
              value: total.totalCase,
              typeName1: 'New cases:',
              value1: total.todayCase,
              color: Colors.white60,
              lineThree: false,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: sizeHeight,
              height: 300,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: CustomCasesChart(
                      lineCases: listCases,
                      animate: true,
                    ),
                  ),
                  Text(
                    'Update at ${Help.timestampFormatLong(total.timeUpdate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            ItemShow(
              typeName: 'Total Recovered: ',
              value: total.recovered,
              typeName1: 'Active:',
              value1: total.active,
              color: Color(0xFF4caf50),
              lineThree: false,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: sizeHeight,
              height: 300,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: CustomRecovered(
                      lineRecovered: listRecovered,
                      animate: true,
                    ),
                  ),
                  Text(
                    'Update at ${Help.timestampFormatLong(total.timeUpdate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            ItemShow(
              typeName: 'Total deaths: ',
              value: total.death,
              typeName1: 'Critical:',
              value1: total.critical,
              color: Color(0xFFf44336),
              lineThree: true,
              typeName2: 'Today death',
              value2: total.todayDeath,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: sizeHeight,
              height: 300,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: CustomDeathChart(
                      lineDeath: listDeath,
                      animate: true,
                    ),
                  ),
                  Text(
                    'Update at ${Help.timestampFormatLong(total.timeUpdate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    } else {
      renderBody = Container();
    }

    return renderBody;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232c37),
      appBar: AppBar(
        backgroundColor: Color(0xFFf44336),
        title: Text('SARS COVID-19'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: onLoading,
        header: WaterDropMaterialHeader(
          backgroundColor: Color(0xFFf44336),
        ),
        child: _isLoading
            ? Indicator()
            : _buildBody(),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final double size;
  final Color color;

  Indicator({this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 16.0,
        height: size ?? 16.0,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              this.color ?? Color(0xFFd8d8df)),
        ),
      ),
    );
  }
}
