import 'dart:ui';

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final   Color color;
}
class CandleData {
  final String day;
  final double open;
  final double high;
  final double low;
  final double close;
  final double width;

  CandleData(this.day, this.open, this.high, this.low, this.close, this.width);
}
class LineChartData {
  LineChartData(this.x, this.high, this.low);

  final DateTime x;
  final double high;
  final double low;
}
class ChartColumnData {
  ChartColumnData(this.x, this.y, this.y1);

  final String x;
  final double? y;
  final double? y1;
}
