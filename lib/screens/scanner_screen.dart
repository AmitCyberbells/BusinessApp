import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:business_app/services/checkin_service.dart';
import 'point_allocation_screen.dart';
import 'dart:convert';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  bool _isScanning = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isProcessing = false;
  MobileScannerController? _scannerController;
  final TextEditingController _uidController = TextEditingController();
  bool _isManualEntry = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissionAndInitialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController?.dispose();
    _uidController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isScanning) {
      _initializeScanner();
    }
  }

  Future<void> _checkPermissionAndInitialize() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _isScanning = true;
        _hasError = false;
      });
      _initializeScanner();
    }
  }

  void _initializeScanner() {
    try {
      _scannerController?.dispose();
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: false,
      );

      if (mounted) {
        setState(() {
          _hasError = false;
          _errorMessage = '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Error initializing camera: $e';
        });
      }
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _isScanning = true;
        _hasError = false;
      });
      _initializeScanner();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Camera permission is required to scan QR codes'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) {
      debugPrint('Already processing a QR code, ignoring new scan');
      return;
    }

    final List<Barcode> barcodes = capture.barcodes;
    debugPrint('Number of barcodes detected: ${barcodes.length}');

    for (final barcode in barcodes) {
      if (barcode.rawValue == null) continue;

      setState(() => _isProcessing = true);
      _scannerController?.stop();
      setState(() => _isScanning = false);

      try {
        debugPrint('Raw QR value: ${barcode.rawValue}');

        // Don't try to decode the QR data - it's encrypted
        if (barcode.rawValue!.isEmpty) {
          throw Exception('Empty QR code data');
        }

        // Attempt check-in with the raw QR data
        final response = await CheckinService.checkInCustomer(
          qrData: barcode.rawValue!,
        );

        if (mounted) {
          debugPrint('Check-in successful');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Customer checked in successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Extract customer information from the response
          final customerData = response['data'] ?? response;
          final customerId = customerData['customer_id']?.toString() ?? '0';
          final customerName = customerData['customer_name'] ?? 'Customer';

          // Navigate to point allocation screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PointAllocationScreen(
                customerId: customerId,
                customerName: customerName,
              ),
            ),
          ).then((_) {
            if (mounted) {
              debugPrint('Returned from point allocation, resetting scanner');
              setState(() {
                _isScanning = true;
                _isProcessing = false;
              });
              _initializeScanner();
            }
          });
        }
      } catch (e) {
        debugPrint('Check-in error occurred: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Check-in failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isScanning = true;
            _isProcessing = false;
          });
          _initializeScanner();
        }
      }
      break;
    }
  }

  void _showScannedResult(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Scanned Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QR Code: $result'),
            const SizedBox(height: 16),
            const Text(
              'Would you like to check in this customer?',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isScanning = true);
              _initializeScanner();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement check-in logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Customer checked in successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F6D88),
            ),
            child: const Text(
              'Check In',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeScanner,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return MobileScanner(
      controller: _scannerController,
      onDetect: _onDetect,
      overlayBuilder: (context, constraints) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 250,
                height: 250,
              ),
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Align QR code within the frame',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                top: 32,
                right: 32,
                child: IconButton(
                  icon: const Icon(
                    LucideIcons.flashlight,
                    color: Colors.white,
                  ),
                  onPressed: () => _scannerController?.toggleTorch(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleUidCheckIn() async {
    if (_uidController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a customer UID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      debugPrint('Attempting check-in with UID: ${_uidController.text}');
      final success = await CheckinService.checkInWithUID(
        customerUid: _uidController.text,
      );

      if (mounted && success) {
        debugPrint('UID check-in successful');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PointAllocationScreen(
              customerId: _uidController.text,
              customerName: "Customer",
            ),
          ),
        ).then((_) {
          if (mounted) {
            setState(() {
              _isProcessing = false;
              _uidController.clear();
            });
          }
        });
      }
    } catch (e) {
      debugPrint('UID check-in error occurred: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Check-in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6D88),
        elevation: 0,
        title: Text(
          _isManualEntry ? 'Manual Check-in' : 'QR Scanner',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isManualEntry)
            IconButton(
              icon: const Icon(LucideIcons.keyboard, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isManualEntry = true;
                  _scannerController?.stop();
                });
              },
            ),
          if (_isManualEntry)
            IconButton(
              icon: const Icon(LucideIcons.qrCode, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isManualEntry = false;
                  _checkPermissionAndInitialize();
                });
              },
            ),
        ],
      ),
      body: _isManualEntry ? _buildManualEntryView() : _buildScannerView(),
    );
  }

  Widget _buildManualEntryView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.userCheck,
            size: 64,
            color: Color(0xFF2F6D88),
          ),
          const SizedBox(height: 24),
          const Text(
            'Enter Customer UID',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F6D88),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter the customer\'s UID to check them in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _uidController,
            decoration: InputDecoration(
              hintText: 'Enter Customer UID',
              prefixIcon: const Icon(LucideIcons.user),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF2F6D88),
                  width: 2,
                ),
              ),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _handleUidCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6D88),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Check In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
