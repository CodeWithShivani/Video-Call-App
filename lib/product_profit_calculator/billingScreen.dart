import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:qr_flutter/qr_flutter.dart';



class CartItem {
  final String barcode;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.barcode,
    required this.name,
    required this.price,
    this.quantity = 1
  });
}

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {

  final Map<String, Map<String, dynamic>> _mockProductDB = {
    "50501234": {"name": "50-50 Biscuit", "price": 5.00},
    "76222108": {"name": "Bourbon", "price": 10.00},
    "8901491101178": { "name": "Lays Classic Salted 52g", "price": 20.00 },
    "8901491101185": { "name": "Lays Classic Salted 28g", "price": 10.00 },
    "8901491101116": { "name": "Kurkure Masala Munch 22g", "price": 5.00 },
    "8901491101123": { "name": "Kurkure Masala Munch 62g", "price": 20.00 },
    "8901725111056": { "name": "Sunfeast Gobbles Chocolate Cake (Single)", "price": 10.00 },
    "8901233011485": { "name": "Cadbury Dairy Milk 13.2g (Mini)", "price": 10.00 },
    "8901233011492": { "name": "Cadbury Dairy Milk 24g", "price": 20.00 },
    "8901233011515": { "name": "Cadbury Dairy Milk 36g", "price": 40.00 },
    "8904063240194": { "name": "Haldiram Bhujia 18g Small Pack", "price": 5.00 },
    "8904063240071": { "name": "Haldiram Bhujia Sev 38g", "price": 10.00 },
    "8904063200051": { "name": "Haldiram Aloo Bhujia 200g", "price": 60.00 },
    "8904004400052": { "name": "Haldiram Bhujia Sev 600g", "price": 150.00 },
    "8908015201233": {"name": "Jeera Papad", "price": 5.00},
    "8901491100026": { "name": "Oreo Chocolate Biscuit 24g (Mini Pack)", "price": 10.00 },
    "8901491100033": { "name": "Oreo Chocolate Biscuit 67g Pack", "price": 30.00 },
    "8901491100040": { "name": "Oreo Chocolate Biscuit 120g Pack", "price": 50.00 },
    "8901491100057": { "name": "Oreo Chocolate Biscuit Family Pack", "price": 100.00 },
  };
  // "8904063240194": {"name": "Namkeen Bhujiya", "price": 5.00},

  final List<CartItem> _cartItems = [];
  bool _isScanningLocked = false;

  /*BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;*/
/*
  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }*/

  // Bluetooth Printer Discovery Setup
 /* void _initBluetooth() async {
    try {
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      debugPrint("Bluetooth Error: $e");
    }
  }*/

  // Barcode Detection Functionality
  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_isScanningLocked) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String code = barcodes.first.rawValue!;

      // Temporary lock to prevent duplicate rapid scans of the same item
      setState(() => _isScanningLocked = true);

      _addProductToCart(code);

      // Cool-down period before allowing next barcode swipe
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isScanningLocked = false);
      });
    }
  }

  void _addProductToCart(String barcode) {
    setState(() {
      // Check if product exists in our catalog database
      if (_mockProductDB.containsKey(barcode)) {
        final prodData = _mockProductDB[barcode]!;

        // If product already in cart, increment quantity
        final existingIndex = _cartItems.indexWhere((item) => item.barcode == barcode);
        if (existingIndex >= 0) {
          _cartItems[existingIndex].quantity++;
        } else {
          // Otherwise append a brand new line item
          _cartItems.add(CartItem(
              barcode: barcode,
              name: prodData["name"],
              price: prodData["price"]
          ));
        }
      } else {
        // Fallback placeholder if barcode doesn't match predefined database
        _cartItems.add(CartItem(barcode: barcode, name: "Unknown Item ($barcode)", price: 12.00));
      }
    });
  }

  double get _totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // UI Component: Modal Sheet Checkout View (Matches bottom section of video)
  void _openCheckoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Checkout", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Divider(),

                  // Device Selection Dropdown for Thermal Hardware pairing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Select Printer:"),
                      /*DropdownButton<BluetoothDevice>(
                        value: _selectedDevice,
                        hint: const Text("Select Device"),
                        items: _devices.map((device) => DropdownMenuItem(
                          value: device,
                          child: Text(device.name ?? "Unknown"),
                        )).toList(),
                        onChanged: (device) async {
                          if (device != null) {
                            await bluetooth.connect(device);
                            setModalState(() => _selectedDevice = device);
                            setState(() => _selectedDevice = device);
                          }
                        },
                      )*/
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Center QR Code generation placeholder payment string
                  Center(
                    child: Column(
                      children: [
                        const Text("Scan to Pay", style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        QrImageView(
                          data: "upi://pay?pa=9554590079@axl&pn=VINEETCHAUDHARY&am=$_totalPrice&cu=INR",
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                        Text("Total Amount: ₹$_totalPrice", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Send Print commands via ESC/POS to thermal engine
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
                      // onPressed: () => _printReceiptViaThermal(),
                      onPressed: () => {},
                      child: const Text("Print Receipt", style: TextStyle(fontSize: 16)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Thermal Printing Commands Strategy Pattern (ESC/POS formatting codes)
  /*void _printReceiptViaThermal() async {
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Printer disconnected! Please connect via dropdown.")),
      );
      return;
    }

    // Alignment Options: 0=Left, 1=Center, 2=Right
    bluetooth.printCustom("Dinesh Shop", 3, 1); // Large Bold Text Center
    bluetooth.printCustom("Salem - 636453", 1, 1);
    bluetooth.printCustom("Ph: +917010674588", 1, 1);
    bluetooth.printCustom("--------------------------------", 1, 1);

    for (var item in _cartItems) {
      String itemLine = "${item.quantity}x ${item.name}";
      String priceLine = (item.price * item.quantity).toStringAsFixed(2);
      bluetooth.printLeftRight(itemLine, priceLine, 1);
    }

    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printCustom("TOTAL: INR ${_totalPrice.toStringAsFixed(2)}", 2, 1);
    bluetooth.printCustom("Thank you, Visit again!!", 1, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.paperCut();
  }*/

  // Main UI Screen Layout (Embedded Scanner on top + Scrollable list below)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("POS Quick Billing"), centerTitle: true),
      body: Column(
        children: [
          // 1. Live Embedded Scanner Viewport
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  onDetect: _onBarcodeDetected,
                ),
                // Camera Scanner Target UI Box overlay
                Container(
                  width: 200,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: _isScanningLocked ? Colors.red : Colors.green, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                if (_isScanningLocked)
                  Positioned(
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      color: Colors.black54,
                      child: const Text("Processing Item...", style: TextStyle(color: Colors.white)),
                    ),
                  )
              ],
            ),
          ),

          // 2. Realtime Scrollable Cart Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Scanned Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("₹${_totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ),

          Expanded(
            child: _cartItems.isEmpty
                ? const Center(child: Text("Cart is empty.\nScan an item's barcode to begin billing.", textAlign: TextAlign.center))
                : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text("₹${item.price.toStringAsFixed(2)} each"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              if (item.quantity > 1) {
                                item.quantity--;
                              } else {
                                _cartItems.removeAt(index);
                              }
                            });
                          },
                        ),
                        Text("${item.quantity}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onPressed: () => setState(() => item.quantity++),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. Persistent Dynamic Footer Bar Button
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14)
              ),
              onPressed: _cartItems.isEmpty ? null : _openCheckoutBottomSheet,
              child: const Text("Review Order & Checkout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}