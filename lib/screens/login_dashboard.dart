import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isWeekly = true;
  int _selectedIndex = 0; // To track the selected navigation item

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6D88),
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.user, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bellRing, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildTopCards(),
                const SizedBox(height: 16),
                _buildCustomerVisits(),
                const SizedBox(height: 16),
                _buildRevenueTrends(),
                const SizedBox(height: 16),
               
                const SizedBox(height: 16),
                _buildRecentCustomers(),
                const SizedBox(height: 24),
              
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildFooterNavigation(),
    );
  }

  Widget _buildTopCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              title: 'Total Check-Ins',
              value: 'Today: 32',
              icon: LucideIcons.arrowRightCircle,
              color: Colors.blue,
              borderRadius: 10,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard(
              title: 'Total Reward claims',
              value: 'Today: 32',
              icon: LucideIcons.arrowRightCircle,
              color: Colors.blue,
              borderRadius: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    double borderRadius = 8,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2F6D88),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    icon,
                    size: 16,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerVisits() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Active Customers',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2F6D88),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Total Visits: 300',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 70,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildToggleButton('Weekly', true),
                      const SizedBox(height: 8),
                      _buildVisitCount('300'),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 70,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildToggleButton('Monthly', false),
                      const SizedBox(height: 8),
                      _buildVisitCount('900'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2F6D88),
          width: 1,
        ),
        color: isActive ? const Color(0xFF2F6D88) : Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isActive ? Colors.white : const Color(0xFF2F6D88),
        ),
      ),
    );
  }

  Widget _buildVisitCount(String count) {
    return Text(
      count,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFooterNavigation() {
    return Container(
      height: 140, // Adjusted height to accommodate the background image
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login-footer.png'),
          fit: BoxFit.cover, // Ensures the image covers the entire footer
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(LucideIcons.home, 'Dashboard', 0, iconSize: 18),
          _buildNavItem(LucideIcons.lightbulb, 'B to B Collab', 1,iconSize: 18),
    
          _buildNavItem(LucideIcons.shoppingCart, 'Services', 3,iconSize: 18),
          _buildNavItem(LucideIcons.messageCircle, 'Messages', 4,iconSize: 18),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {double iconSize = 18}) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        // Add navigation logic here if needed
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 54),
       Padding(
  padding: EdgeInsets.only(right: 10), // Adjust left spacing
  child: Icon(
    icon,
    color: isSelected ? Colors.white : Colors.white70,
    size: 29,
  ),
),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTrends() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revenue Trends',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Approximate Weekly Earnings',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal.shade700),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Text(
                      'Weekly',
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.teal.shade700,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 30),

          // Chart section
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Y-axis labels
                      ...['\$200', '\$150', '\$100', '\$50', '\$0']
                          .map((label) => Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),

                // Chart area
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 10, top: 10),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              TextStyle style = const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
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
                                  break;
                              }
                              return Text(text, style: style);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
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
                          spots: [
                            FlSpot(0, 110),
                            FlSpot(1, 95),
                            FlSpot(2, 130),
                            FlSpot(3, 170),
                            FlSpot(4, 155),
                            FlSpot(5, 140),
                            FlSpot(6, 130),
                          ],
                          isCurved: true,
                          // color: colorsteal.shade700,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            checkToShowDot: (spot, barData) {
                              return spot.x == 3; // Only show dot for Thursday
                            },
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 8,
                                color: Colors.teal.shade700,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.teal.shade200.withOpacity(0.3),
                                Colors.teal.shade100.withOpacity(0.1),
                              ],
                              stops: [0.5, 1.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Dashed line representing future projection
                        LineChartBarData(
                          spots: [
                            FlSpot(3, 170),
                            FlSpot(4, 155),
                            FlSpot(5, 140),
                            FlSpot(6, 130),
                          ],
                          isCurved: true,
                         color: Colors.teal.shade700,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          dashArray: [5, 5],
                        ),
                      ],
                    ),
                  ),
                ),

                // Value label for highlighted point
                Positioned(
                  top: 40,
                  left: MediaQuery.of(context).size.width * 0.5 - 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '\$510',
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Action buttons row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add New Offer\nfrom Here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.plus,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'List of Current\nDeals',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                    LucideIcons.arrowRight,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(LucideIcons.plus),
              label: Text('Add New Offer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(LucideIcons.arrowRight),
              label: Text('List of Deals'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCustomers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Active Customer List',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => SizedBox(height: 8),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/avatar${index + 1}.png'),
                ),
                title: Text('Sophie Cartier',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('12 Jan 2022'),
                trailing: Text('09:00 AM'),
              );
            },
          ),
        ],
      ),
    );
  }
}
