import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BusinessHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard', 
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.thLarge, color: Colors.black, size: 22),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top two cards
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Total Check-Ins',
                                style: TextStyle(color: Colors.blue, fontSize: 14)
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Today: 32',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Total Reward claims',
                                style: TextStyle(color: Colors.blue, fontSize: 14)
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Today: 32',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Active customers card
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Active Customers this week',
                          style: TextStyle(color: Colors.blue, fontSize: 14)
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Total: 300',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                            Text(
                              'Repeated Customers: 120',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Section title
              const Padding(
                padding: EdgeInsets.only(top: 24.0, bottom: 16.0),
                child: Text(
                  'Business Performance Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              
              // Chart card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'People Visited',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Amount Earned This Week',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: const [
                                Text('Weekly', style: TextStyle(fontSize: 12)),
                                SizedBox(width: 4),
                                FaIcon(FontAwesomeIcons.chevronDown, size: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 50,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.shade200,
                                  strokeWidth: 1,
                                );
                              },
                              verticalInterval: 1,
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: Colors.transparent,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const style = TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    );
                                    String text;
                                    switch (value.toInt()) {
                                      case 0:
                                        text = 'Mon';
                                        break;
                                      case 1:
                                        text = 'Tue';
                                        break;
                                      case 2:
                                        text = 'Wed';
                                        break;
                                      case 3:
                                        text = 'Thu';
                                        break;
                                      case 4:
                                        text = 'Fri';
                                        break;
                                      case 5:
                                        text = 'Sat';
                                        break;
                                      case 6:
                                        text = 'Sun';
                                        break;
                                      default:
                                        text = '';
                                    }
                                    return Text(text, style: style);
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 50,
                                  getTitlesWidget: (value, meta) {
                                    if (value == 0) {
                                      return const Text('\$0', style: TextStyle(color: Colors.grey, fontSize: 10));
                                    }
                                    return Text('\$${value.toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 10));
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            minX: 0,
                            maxX: 6,
                            minY: 0,
                            maxY: 200,
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(0, 100),
                                  FlSpot(1, 120),
                                  FlSpot(2, 150),
                                  FlSpot(3, 170),
                                  FlSpot(4, 150),
                                  FlSpot(5, 170),
                                  FlSpot(6, 140),
                                ],
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    if (index == 3) {
                                      return FlDotCirclePainter(
                                        radius: 6,
                                        color: Colors.white,
                                        strokeWidth: 3,
                                        strokeColor: Colors.blue,
                                      );
                                    }
                                    return FlDotCirclePainter(
                                      radius: 0,
                                      color: Colors.transparent,
                                      strokeWidth: 0,
                                      strokeColor: Colors.transparent,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.blue.withOpacity(0.3),
                                      Colors.blue.withOpacity(0.05),
                                    ],
                                  ),
                                ),
                              ),
                              LineChartBarData(
                                spots: const [
                                  FlSpot(3, 170),
                                  FlSpot(4, 150),
                                  FlSpot(5, 170),
                                  FlSpot(6, 140),
                                ],
                                isCurved: true,
                                color: Colors.blue.withOpacity(0.5),
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: FlDotData(show: false),
                                dashArray: [5, 5],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Pricing plans
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Basic plan',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$40',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '/month',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Perfect your starters',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(width: 4),
                                FaIcon(FontAwesomeIcons.rocket, size: 12, color: Colors.grey),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.arrowRight,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Transactions
              buildTransactionItem(
                'Elsa Max',
                '10 jan 2022',
                '\$544',
                'In Cash',
                Colors.blue.shade100,
                FontAwesomeIcons.store,
              ),
              buildTransactionItem(
                'Marie Marlyn',
                '11 jan 2022',
                '\$54,417.80',
                'Card',
                Colors.blue.shade100,
                FontAwesomeIcons.creditCard,
              ),
              buildTransactionItem(
                'Sophie Cartier',
                '12 jan 2022',
                '\$54.00',
                'Online',
                Colors.blue.shade100,
                FontAwesomeIcons.taxi,
              ),
              
              // Space for bottom navigation
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.thLarge),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartBar),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const FaIcon(FontAwesomeIcons.mapMarkerAlt, color: Colors.white),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.tools),
            label: 'Services',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.commentDots),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
  
  Widget buildTransactionItem(String name, String date, String amount, String method, Color iconBgColor, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                method,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}