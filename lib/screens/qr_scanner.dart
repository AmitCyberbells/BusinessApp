// import 'package:flutter/material.dart';

// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/services.dart';

// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({Key? key}) : super(key: key);

//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen>
//     with WidgetsBindingObserver {
//   late MobileScannerController controller;
//   bool isFlashOn = false;
//   bool isFrontCamera = false;
//   String? scannedData;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     controller = MobileScannerController(
//       facing: CameraFacing.back,
//       torchEnabled: false,
//     );
//     _initializeScanner();
//   }

//   Future<void> _initializeScanner() async {
//     await _checkCameraPermission();
//     try {
//       await controller.start();
//     } catch (e) {
//       print('Error starting scanner: $e');
//       // Show error to user if needed
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error starting camera: $e')),
//       );
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // Handle app lifecycle changes
//     switch (state) {
//       case AppLifecycleState.resumed:
//         controller.start();
//         break;
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.paused:
//       case AppLifecycleState.detached:
//         controller.stop();
//         break;
//       default:
//         break;
//     }
//   }

//   Future<void> _checkCameraPermission() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (status.isDenied) {
//         _showPermissionDeniedDialog();
//       } else if (status.isPermanentlyDenied) {
//         _showOpenSettingsDialog();
//       }
//     }
//   }

//   void _showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Camera Permission Required'),
//         content: const Text('Please grant camera permission to scan QR codes.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _checkCameraPermission();
//             },
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showOpenSettingsDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: Text('Camera Permission Denied'),
//         content: Text('Please enable camera permission in app settings.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               openAppSettings();
//             },
//             child: Text('Open Settings'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF2F6D88),
//         title: const Text(
//           'QR Code Scanner',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             controller.stop();
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               isFlashOn ? Icons.flash_off : Icons.flash_on,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               controller.toggleTorch();
//               setState(() {
//                 isFlashOn = !isFlashOn;
//               });
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               isFrontCamera ? Icons.camera_rear : Icons.camera_front,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               controller.switchCamera();
//               setState(() {
//                 isFrontCamera = !isFrontCamera;
//               });
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 4,
//             child: Stack(
//               children: [
//                 MobileScanner(
//                   controller: controller,
//                   onDetect: (capture) {
//                     final List<Barcode> barcodes = capture.barcodes;
//                     if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
//                       HapticFeedback.mediumImpact();
//                       setState(() {
//                         scannedData = barcodes[0].rawValue;
//                       });
//                       // Optional: Show a success message
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content:
//                               Text('QR Code detected: ${barcodes[0].rawValue}'),
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                   },
//                   errorBuilder: (context, error, child) {
//                     return Center(
//                       child: Text(
//                         'Error starting camera: $error',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     );
//                   },
//                 ),
//                 CustomPaint(
//                   painter: ScannerOverlay(),
//                   child: Container(),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (scannedData != null) ...[
//                   Text(
//                     'Scanned Code:',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     scannedData!,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                 ] else
//                   const Text(
//                     'Align QR code within the frame to scan',
//                     style: TextStyle(fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
// }

// class ScannerOverlay extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFF2F6D88)
//       ..strokeWidth = 3.0
//       ..style = PaintingStyle.stroke;

//     final double scanAreaSize = size.width * 0.7;
//     final double left = (size.width - scanAreaSize) / 2;
//     final double top = (size.height - scanAreaSize) / 2;
//     final double right = left + scanAreaSize;
//     final double bottom = top + scanAreaSize;

//     final cornerLength = scanAreaSize * 0.1;

//     // Draw the scanning area
//     Path path = Path()
//       ..moveTo(left + cornerLength, top)
//       ..lineTo(right - cornerLength, top)
//       ..moveTo(right, top + cornerLength)
//       ..lineTo(right, bottom - cornerLength)
//       ..moveTo(right - cornerLength, bottom)
//       ..lineTo(left + cornerLength, bottom)
//       ..moveTo(left, bottom - cornerLength)
//       ..lineTo(left, top + cornerLength)
//       ..moveTo(left, top)
//       ..lineTo(left + cornerLength, top);

//     // Draw the corners
//     canvas.drawPath(path, paint);

//     // Draw semi-transparent overlay
//     final overlayPaint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill;

//     final overlayPath = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..addRect(Rect.fromLTRB(left, top, right, bottom));

//     canvas.drawPath(overlayPath, overlayPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
