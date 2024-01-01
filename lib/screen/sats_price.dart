import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class SatsPrice extends StatefulWidget {
  @override
  _SatsPriceState createState() => _SatsPriceState();
}

class _SatsPriceState extends State<SatsPrice> {
  late Future<List<FlSpot>> chartData;

  @override
  void initState() {
    super.initState();
    chartData = fetchBitcoinChartData();
  }

  Future<List<FlSpot>> fetchBitcoinChartData() async {
    final url = 'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=jpy&days=0.25';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> values = json.decode(response.body)['prices'];
      return values.map((val) {
        double time = (val[0] as num).toDouble();
        double price = (val[1] as num).toDouble();
        return FlSpot(time, price);
      }).toList();
    } else {
      throw Exception('Failed to load chart data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin Chart'),
      ),
      body: FutureBuilder<List<FlSpot>>(
        future: chartData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: snapshot.data!,
                    isCurved: true,
                    // colors: [Colors.blue],
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                // その他のチャート設定...
              ),
            );
          }
        },
      ),
    );
  }
}
