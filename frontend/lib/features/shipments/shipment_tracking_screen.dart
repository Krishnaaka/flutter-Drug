import 'package:flutter/material.dart';

class ShipmentTrackingScreen extends StatelessWidget {
  const ShipmentTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Shipment Tracking", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Text("Order #ORD-902 (Paracetamol IV)", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16)),
        const SizedBox(height: 32),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStep(Icons.receipt_long, "Order Placed", "City General Hospital", "10:30 AM", true, true),
              _buildLine(true),
              _buildStep(Icons.check_circle_outline, "Order Approved", "Vendor XYZ", "11:15 AM", true, true),
              _buildLine(true),
              _buildStep(Icons.local_shipping, "Shipped", "In Transit - Driver details: John Doe", "02:00 PM", true, false),
              _buildLine(false),
              _buildStep(Icons.home, "Delivered", "Awaiting confirmation", "--:--", false, false),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStep(IconData icon, String title, String subtitle, String time, bool isCompleted, bool isPast) {
    Color color = isCompleted ? Colors.greenAccent : (isPast ? Colors.blueAccent : Colors.grey);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 2)
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(isCompleted ? 1 : 0.5))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5))),
            ],
          ),
        ),
        Text(time, style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLine(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(left: 23, top: 8, bottom: 8),
      width: 2,
      height: 40,
      color: isCompleted ? Colors.greenAccent.withOpacity(0.5) : Colors.white.withOpacity(0.1),
    );
  }
}
