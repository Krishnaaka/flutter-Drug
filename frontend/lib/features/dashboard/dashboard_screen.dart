import 'dart:ui';
import 'package:flutter/material.dart';
import '../inventory/inventory_screen.dart';
import '../shipments/shipment_tracking_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  
  // Staggered Animations for content
  late AnimationController _pageController;
  String _userName = "Admin User";
  String _userRole = "System Administrator";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _pageController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _pageController.forward();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "Admin User";
      _userRole = prefs.getString('user_role') ?? "User";
    });
  }

  void _handleSignOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      context.go('/login');
    }
  }

  void _onNavTapped(int index) {
    if (_selectedIndex == index) return;
    _pageController.reset();
    setState(() => _selectedIndex = index);
    _pageController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090E), // Very dark sleek background
      body: Row(
        children: [
          // High-end Sidebar
          _buildSidebar(),
          // Main Content Area with subtle mesh background
          Expanded(
            child: Stack(
              children: [
                // Top-right glowing accent
                Positioned(top: -200, right: -200, child: Container(width: 600, height: 600, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent.withOpacity(0.05)))),
                // Bottom-left glowing accent
                Positioned(bottom: -200, left: -200, child: Container(width: 600, height: 600, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purpleAccent.withOpacity(0.05)))),
                
                Column(
                  children: [
                    _buildTopbar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
                        child: AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: Curves.easeOut.transform(_pageController.value),
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - Curves.easeOutCubic.transform(_pageController.value))),
                                child: _buildMainContent(),
                              ),
                            );
                          }
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF13131A), // Sleek sidebar
        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.05))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(5, 0))]
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo Area
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 4))]
                ),
                child: const Icon(Icons.hub_rounded, color: Colors.black, size: 32),
              ),
              const SizedBox(width: 16),
              const Text("DISCTS", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 60),
          _buildNavItem(0, Icons.grid_view_rounded, "Dashboard Overview"),
          _buildNavItem(1, Icons.medication_liquid_rounded, "Live Inventory"),
          _buildNavItem(2, Icons.route_rounded, "Shipment Tracking"),
          _buildNavItem(3, Icons.receipt_long_rounded, "Purchase Orders"),
          _buildNavItem(4, Icons.business_rounded, "Vendors & Partners"),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purpleAccent.withOpacity(0.1), Colors.blueAccent.withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.security_rounded, color: Colors.cyanAccent),
                const SizedBox(height: 12),
                const Text("System Secure", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("All connections encrypted.", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          _buildNavItem(6, Icons.logout_rounded, "Sign Out", isLogout: true, onTap: _handleSignOut),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String title, {bool isLogout = false, VoidCallback? onTap}) {
    bool isSelected = _selectedIndex == index && !isLogout;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: _HoverScale(
        child: InkWell(
          onTap: onTap ?? (() => isLogout ? null : _onNavTapped(index)),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.cyanAccent.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? Colors.cyanAccent.withOpacity(0.3) : Colors.transparent),
            ),
            child: Row(
              children: [
                Icon(icon, color: isLogout ? Colors.redAccent : (isSelected ? Colors.cyanAccent : Colors.white.withOpacity(0.4)), size: 24),
                const SizedBox(width: 16),
                Text(title, style: TextStyle(color: isLogout ? Colors.redAccent : (isSelected ? Colors.white : Colors.white.withOpacity(0.6)), fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopbar() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      decoration: BoxDecoration(
        color: const Color(0xFF09090E).withOpacity(0.8),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Glassmorphic Search Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 350,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search drugs, hospitals, orders...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    icon: Icon(Icons.search_rounded, color: Colors.cyanAccent.withOpacity(0.8)),
                  ),
                ),
              ),
            ),
          ),
          // User Actions
          Row(
            children: [
              _HoverScale(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.1))),
                  child: const Badge(child: Icon(Icons.notifications_outlined, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 24),
              Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 2)),
                child: const CircleAvatar(backgroundColor: Colors.blueAccent, radius: 20, child: Text("AD", style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(_userRole, style: TextStyle(color: Colors.cyanAccent.withOpacity(0.8), fontSize: 13)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_selectedIndex == 1) return const InventoryScreen();
    if (_selectedIndex == 2) return const ShipmentTrackingScreen();
    
    // Default Overview
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Command Center", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Text("Real-time telemetry for national drug supply chain.", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
                ],
              ),
              _HoverScale(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(color: Colors.cyanAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.cyanAccent.withOpacity(0.3))),
                  child: const Row(children: [Icon(Icons.download_rounded, color: Colors.cyanAccent, size: 20), SizedBox(width: 8), Text("Export Report", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold))]),
                ),
              )
            ],
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              _buildGlassStatCard("Total Inventory Units", "12,450", "+14.2%", Icons.medication_liquid_rounded, [Colors.blueAccent, Colors.cyanAccent]),
              const SizedBox(width: 32),
              _buildGlassStatCard("Active Shipments", "142", "+5.8%", Icons.route_rounded, [Colors.deepPurpleAccent, Colors.purpleAccent]),
              const SizedBox(width: 32),
              _buildGlassStatCard("Critical Low Stock", "8", "-2.1%", Icons.warning_rounded, [Colors.redAccent, Colors.orangeAccent]),
            ],
          ),
          const SizedBox(height: 48),
          const Text("Supply Chain Telemetry", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          _buildTelemetryChart(),
          const SizedBox(height: 48),
          const Text("Live Shipments Activity", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          _buildPremiumTable(),
        ],
      ),
    );
  }

  Widget _buildGlassStatCard(String title, String value, String trend, IconData icon, List<Color> colors) {
    return Expanded(
      child: _HoverScale(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [BoxShadow(color: colors[0].withOpacity(0.05), blurRadius: 30, spreadRadius: -5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: colors[0].withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))]
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: trend.startsWith('+') ? Colors.greenAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(trend.startsWith('+') ? Icons.trending_up : Icons.trending_down, color: trend.startsWith('+') ? Colors.greenAccent : Colors.redAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(trend, style: TextStyle(color: trend.startsWith('+') ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              Text(value, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1)),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTelemetryChart() {
    return _HoverScale(
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.05), blurRadius: 40, spreadRadius: -10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart_rounded, color: Colors.cyanAccent),
                const SizedBox(width: 8),
                Text("Order Volume (Last 7 Days)", style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1)),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0, maxX: 6, minY: 0, maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [FlSpot(0, 30), FlSpot(1, 50), FlSpot(2, 40), FlSpot(3, 80), FlSpot(4, 60), FlSpot(5, 90), FlSpot(6, 100)],
                      isCurved: true,
                      gradient: LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true, 
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 6, color: Colors.black, strokeWidth: 2, strokeColor: Colors.cyanAccent)
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(colors: [Colors.cyanAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: DataTable(
          headingRowHeight: 70,
          dataRowMaxHeight: 80,
          dataRowMinHeight: 80,
          headingTextStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: 14),
          dataTextStyle: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          dividerThickness: 0.1,
          columns: const [
            DataColumn(label: Text("Tracking ID")),
            DataColumn(label: Text("Drug Consignment")),
            DataColumn(label: Text("Destination Hospital")),
            DataColumn(label: Text("Status Indicator")),
            DataColumn(label: Text("Time Delta")),
          ],
          rows: [
            _buildDataRow("#TRK-901A", "Amoxicillin 500mg (1000 Units)", "City General", "Delivered", "2 Hrs Ago"),
            _buildDataRow("#TRK-902B", "Paracetamol IV (500 Units)", "Metro Care", "In Transit", "5 Hrs Ago"),
            _buildDataRow("#TRK-903C", "Ibuprofen 400mg (2000 Units)", "St. Jude", "Processing", "1 Day Ago"),
            _buildDataRow("#TRK-904D", "Azithromycin (250 Units)", "Global Health", "Approved", "1 Day Ago"),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String id, String drug, String hospital, String status, String date) {
    Color statusColor;
    if (status == "Delivered") statusColor = Colors.greenAccent;
    else if (status == "In Transit") statusColor = Colors.cyanAccent;
    else if (status == "Approved") statusColor = Colors.purpleAccent;
    else statusColor = Colors.orangeAccent;

    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent))),
        DataCell(Row(children: [const Icon(Icons.medication_rounded, color: Colors.grey, size: 20), const SizedBox(width: 12), Text(drug)])),
        DataCell(Row(children: [const Icon(Icons.local_hospital_rounded, color: Colors.grey, size: 20), const SizedBox(width: 12), Text(hospital)])),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor.withOpacity(0.3))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: statusColor, blurRadius: 10)])),
                const SizedBox(width: 8),
                Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          )
        ),
        DataCell(Text(date, style: TextStyle(color: Colors.white.withOpacity(0.5)))),
      ]
    );
  }
}

// Helper Widget for Hover Scaling
class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});
  @override State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _isHovered = false;
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        child: widget.child,
      ),
    );
  }
}
