import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:shriken/components/app_drawer.dart';

class SatsPrice extends StatefulWidget {
  @override
  _SatsPriceState createState() => _SatsPriceState();
}

class _SatsPriceState extends State<SatsPrice> {
  late Future<Map<String, dynamic>> bitcoinData;

  @override
  void initState() {
    super.initState();
    bitcoinData = fetchBitcoinData();
  }

  Future<Map<String, dynamic>> fetchBitcoinData() async {
    try {
      // 現在価格を取得
      final priceResponse = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=jpy&include_24hr_change=true'
      ));
      
      // チャートデータを取得
      final chartResponse = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=jpy&days=0.25'
      ));

      if (priceResponse.statusCode == 200 && chartResponse.statusCode == 200) {
        final priceData = json.decode(priceResponse.body);
        final chartData = json.decode(chartResponse.body);
        
        final List<dynamic> prices = chartData['prices'];
        final chartSpots = prices.map((val) {
          double time = (val[0] as num).toDouble();
          double price = (val[1] as num).toDouble();
          return FlSpot(time, price);
        }).toList();

        return {
          'currentPrice': priceData['bitcoin']['jpy'].toDouble(),
          'change24h': priceData['bitcoin']['jpy_24h_change'].toDouble(),
          'chartData': chartSpots,
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  String formatPrice(double price) {
    return '¥${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String formatChange(double change) {
    return '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ビットコイン価格'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // 戻るボタンを非表示
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                bitcoinData = fetchBitcoinData();
              });
            },
          ),
        ],
      ),
      drawer: AppDrawer(), // ハンバーガーメニューを追加
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: bitcoinData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ビットコイン価格を読み込み中...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'データの取得に失敗しました',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          bitcoinData = fetchBitcoinData();
                        });
                      },
                      child: Text('再試行'),
                    ),
                  ],
                ),
              );
            } else {
              final data = snapshot.data!;
              final currentPrice = data['currentPrice'] as double;
              final change24h = data['change24h'] as double;
              final chartSpots = data['chartData'] as List<FlSpot>;
              final isPositive = change24h >= 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ヘッダー
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.orange,
                        child: Text(
                          '₿',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bitcoin (BTC)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '過去6時間の価格チャート',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // 現在価格カード
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '現在価格',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            formatPrice(currentPrice),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPositive 
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive ? Icons.trending_up : Icons.trending_down,
                                  color: isPositive ? Colors.green[600] : Colors.red[600],
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  formatChange(change24h),
                                  style: TextStyle(
                                    color: isPositive ? Colors.green[600] : Colors.red[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '24h',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // チャートカード
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.show_chart,
                                  color: Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '価格チャート (6時間)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Expanded(
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: chartSpots,
                                      isCurved: true,
                                      color: Theme.of(context).colorScheme.primary,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 10000,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey[300],
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 80,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '¥${(value / 1000).toStringAsFixed(0)}k',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // フッター情報
                  Text(
                    'データ提供: CoinGecko API • 最終更新: ${DateTime.now().toString().substring(11, 19)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
