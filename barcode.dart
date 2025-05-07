import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _hasDetected = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (barcodeCapture) {
              if (_hasDetected) return;
              final barcode = barcodeCapture.barcodes.first;
              final code = barcode.rawValue;

              if (code != null && code.isNotEmpty) {
                _hasDetected = true;

                Navigator.pop(context, code); // Return scanned code to previous screen
              }
            },
          ),
          _buildScannerOverlay(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Stack(
      children: [
        CustomPaint(painter: BarcodeOverlay()),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final size = MediaQuery.of(context).size;
            final width = size.width * 0.7;
            final height = width * 0.5;
            final left = (size.width - width) / 2;
            final top = (size.height - height) / 2;
            final lineTop = top + (height * _animation.value);

            return Positioned(
              left: left,
              top: lineTop,
              child: Container(
                width: width,
                height: 2,
                color: Colors.greenAccent,
              ),
            );
          },
        ),
        const Center(
          child: Text(
            'Align barcode within the frame',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              shadows: [Shadow(blurRadius: 4, color: Colors.black)],
            ),
          ),
        ),
      ],
    );
  }
}

class BarcodeOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final width = size.width * 0.7;
    final height = width * 0.5;
    final left = (size.width - width) / 2;
    final top = (size.height - height) / 2;
    final rect = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
