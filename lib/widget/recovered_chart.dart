import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sarscovid19/help/help.dart';
import 'package:sarscovid19/model/linechart_model.dart';

class CustomRecovered extends StatelessWidget {
  final List<LineChartModel> lineRecovered;
  final bool animate;
  static List selectedDatum;
  CustomRecovered({
    this.animate,
    this.lineRecovered,
  });

  final simpleCurrencyFormatter =
      new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
    NumberFormat.compact(locale: 'en'),
  );
  static bool active;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return charts.TimeSeriesChart(
      createLineChart(),
      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
        stacked: true,
        includePoints: true,
      ),
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
            labelStyle: new charts.TextStyleSpec(
              fontSize: 14, // size in Pts.
              fontWeight: 'charts.MaterialFontWeight.bold',
              color: charts.ColorUtil.fromDartColor(Color(0xFF67717d)),
            ),

            // Change the line colors to match text color.
            lineStyle: new charts.LineStyleSpec(
                thickness: 0, color: charts.MaterialPalette.gray.shadeDefault)),
        tickProviderSpec:
            charts.AutoDateTimeTickProviderSpec(includeTime: false),
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'd/MM',
            transitionFormat: 'dd/MM',
          ),
        ),
      ),
//        layoutConfig: new charts.LayoutConfig(
//            leftMarginSpec: new charts.MarginSpec.fixedPixel(0),
//            topMarginSpec: new charts.MarginSpec.fixedPixel(0),
//            rightMarginSpec: new charts.MarginSpec.fixedPixel(0),
//            bottomMarginSpec: new charts.MarginSpec.fixedPixel(0)),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontWeight: 'Bold',
            fontSize: 14,
            color: charts.ColorUtil.fromDartColor(Color(0xFF67717d)),
          ),
          lineStyle: charts.LineStyleSpec(
            thickness: 0,
            color: charts.MaterialPalette.gray.shadeDefault,
          ),
        ),
        showAxisLine: true,
        tickFormatterSpec: simpleCurrencyFormatter,
        tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: true),
      ),
      animate: true,
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) selectedDatum = [];
          model.selectedDatum.forEach((charts.SeriesDatum datumPair) {
            var time = Help.dateTimeFormat(datumPair.datum.timeStamp);
            var value = Help.numberFormat(datumPair.datum.value);
            selectedDatum.add({
              'time': '$time',
              'text': '$value ',
              'color': datumPair.series.colorFn(0),
            });
          });
//            pointerValue = model.selectedSeries[0]
//                .measureFn(model.selectedDatum[1].index)
//                .toString();
        })
      ],
      behaviors: [
        charts.LinePointHighlighter(
          symbolRenderer: CustomCircleSymbolRenderer(size: size),
        ),
      ],
    );
  }

  List<charts.Series<LineChartModel, DateTime>> createLineChart() {
    final dataDeath = lineRecovered;
//https://stackoverflow.com/questions/56437850/how-to-apply-linear-gradient-in-flutter-charts
    return [
      charts.Series<LineChartModel, DateTime>(
        id: "Recovered",
        data: dataDeath,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF328032)),
        domainFn: (LineChartModel lineChart, _) => lineChart.timeStamp,
        measureFn: (LineChartModel lineChart, _) => lineChart.value,
      ),
    ];
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  final size;
  CustomCircleSymbolRenderer({this.size});

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: charts.Color.white,
        strokeColor: charts.Color.black,
        strokeWidthPx: 1);

    // Draw a bubble

//    final num bubbleWidth = 130;
//    final num bubbleRadius = bubbleHight / 2.0;
//    final num bubbleBoundLeft = bounds.left;
//    final num bubbleBoundTop = bounds.top - bubbleHight;

//    canvas.drawRRect(
//      Rectangle(bubbleBoundLeft, bubbleBoundTop, bubbleWidth, bubbleHight),
//      fill: charts.Color.fromHex(code: '#ffb259'),
//      stroke: charts.Color.transparent,
//      radius: bubbleRadius,
//      roundTopLeft: true,
//      roundBottomLeft: true,
//      roundBottomRight: true,
//      roundTopRight: true,
//    );

    // Add text inside the bubble
    List tooltips = CustomRecovered.selectedDatum;
    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 12;

    if (tooltips != null && tooltips.length > 0) {
      num rectWidth = 100;
      num rectHeight = bounds.height + 25 + (tooltips.length - 1) * 20;
      num left = bounds.left > (size?.width ?? 300) / 2
          ? (bounds.left > size?.width / 4
              ? bounds.left - rectWidth
              : bounds.left - rectWidth / 2)
          : bounds.left - 40;
//      canvas.drawRect(Rectangle(left, 0, rectWidth, rectHeight),
//          fill: charts.Color.fromHex(code: '#666666'));
      canvas.drawRRect(
        Rectangle(left, -5, rectWidth, rectHeight),
        fill: charts.Color.fromHex(code: '#666666'),
        radius: 10.0,
        roundBottomRight: true,
        roundBottomLeft: true,
        roundTopLeft: true,
        roundTopRight: true,
      );
      chartsTextStyle.TextStyle textStyle = chartsTextStyle.TextStyle();
      textStyle.color = charts.Color.white;
      textStyle.fontSize = 13;

      canvas.drawText(
          chartsTextElement.TextElement(tooltips[0]['time'], style: textStyle),
          left.round() + 18,
          0);
      for (int i = 0; i < tooltips.length; i++) {
        canvas.drawPoint(
          point: Point(left.round() + 10, i * 10 + 22),
          radius: 3,
          fill: tooltips[i]['color'],
          strokeWidthPx: 1,
        );
        chartsTextStyle.TextStyle textStyle = chartsTextStyle.TextStyle();
        textStyle.color = charts.Color.white;
        textStyle.fontSize = 13;
        canvas.drawText(
            chartsTextElement.TextElement(tooltips[i]['text'],
                style: textStyle),
            left.round() + 18,
            i * 15 + 15);
      }
    }
  }
}
