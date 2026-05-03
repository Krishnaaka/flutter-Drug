import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class Drug {
  final int? id;
  final String name;
  final String category;
  final int quantity;
  final double price;
  final String manufacturer;

  Drug({this.id, required this.name, required this.category, required this.quantity, required this.price, required this.manufacturer});

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      manufacturer: json['manufacturer'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'quantity': quantity,
    'price': price,
    'manufacturer': manufacturer,
  };
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Drug> _drugs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDrugs();
  }

  Future<void> _fetchDrugs() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.get('/drugs');
      final List data = response.data;
      setState(() {
        _drugs = data.map((e) => Drug.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to fetch inventory")));
    }
  }

  Future<void> _deleteDrug(int id) async {
    try {
      await ApiService.delete('/drugs/$id');
      _fetchDrugs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Delete failed")));
    }
  }

  void _showAddDrugDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();
    final manufacturerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Drug"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Drug Name")),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: "Category")),
              TextField(controller: qtyController, decoration: const InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
              TextField(controller: manufacturerController, decoration: const InputDecoration(labelText: "Manufacturer")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                await ApiService.post('/drugs', {
                  'name': nameController.text,
                  'category': categoryController.text,
                  'quantity': int.parse(qtyController.text),
                  'price': double.parse(priceController.text),
                  'manufacturer': manufacturerController.text,
                });
                Navigator.pop(context);
                _fetchDrugs();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add failed")));
              }
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Drug Inventory", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            ElevatedButton.icon(
              onPressed: _showAddDrugDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add New Drug", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: DataTable(
                    headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    dataTextStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    columns: const [
                      DataColumn(label: Text("Drug Name")),
                      DataColumn(label: Text("Category")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Price")),
                      DataColumn(label: Text("Actions")),
                    ],
                    rows: _drugs.map((drug) => _buildInventoryRow(drug)).toList(),
                  ),
                ),
          ),
        )
      ],
    );
  }

  DataRow _buildInventoryRow(Drug drug) {
    final bool isLowStock = drug.quantity < 50;
    return DataRow(
      cells: [
        DataCell(Text(drug.name, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(drug.category)),
        DataCell(
          Row(
            children: [
              Text(drug.quantity.toString()),
              if (isLowStock) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("Low", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ]
            ],
          )
        ),
        DataCell(Text("\$${drug.price.toStringAsFixed(2)}")),
        DataCell(
          Row(
            children: [
              IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20), onPressed: () {}),
              IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20), onPressed: () => _deleteDrug(drug.id!)),
            ],
          )
        ),
      ]
    );
  }
}
