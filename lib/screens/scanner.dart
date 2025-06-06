// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({Key? key}) : super(key: key);

//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen> {
//   late MobileScannerController controller;
//   bool isFlashOn = false;

//   @override
//   void initState() {
//     super.initState();
//     controller = MobileScannerController(
//       facing: CameraFacing.back,
//       torchEnabled: false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Code Scanner'),
//         actions: [
//           IconButton(
//             icon: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
//             onPressed: () async {
//               await controller.toggleTorch();
//               setState(() => isFlashOn = !isFlashOn);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.switch_camera),
//             onPressed: () => controller.switchCamera(),
//           ),
//         ],
//       ),
//       body: MobileScanner(
//         controller: controller,
//         onDetect: (capture) {
//           final List<Barcode> barcodes = capture.barcodes;
//           if (barcodes.isNotEmpty) {
//             HapticFeedback.mediumImpact();
//             final String code = barcodes.first.rawValue ?? 'No data found';
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(code)),
//             );
//           }
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }
