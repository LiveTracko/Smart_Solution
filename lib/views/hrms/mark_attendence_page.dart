import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({super.key});

  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  String? _lastCode;
  bool _torchOn = false;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // for blue scanning line
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF808080), // grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6DF6),
        leading: const BackButton(color: Color(0xffFFFFFF)),
        title: const Text(
          'Mark Attendance',
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Scan Code',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xffFFFFFF),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              'Please Scan the QR to Mark Attendance',
              style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(179, 255, 243, 243),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // --------- Scanner box ----------
          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: MobileScanner(
                      controller: _controller,
                      onDetect: (capture) {
                        final barcode = capture.barcodes.first;
                        final String? code = barcode.rawValue;

                        if (code == null) return;

                        // avoid multiple detections of same code
                        if (_lastCode == code) return;
                        _lastCode = code;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Scanned: $code')),
                        );
                      },
                    ),
                  ),
                  // white overlay to make it look lighter like design
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffFFFFFF), width: 2),
                    ),
                  ),
                  // animated blue scanning line
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      final dy = _animController.value * 260;
                      return Positioned(
                        top: dy,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: const Color(0xFF2F6DF6),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // --------- Bottom controls ----------
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // big round camera button (just decorative / can be used to re-scan)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _lastCode = null; // allow scanning again
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xffFFFFFF), width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFFFFFF),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                IconButton(
                  iconSize: 30,
                  icon: Icon(
                    _torchOn ? Icons.flash_on : Icons.flash_off,
                    color: Color(0xffFFFFFF),
                  ),
                  onPressed: () async {
                    await _controller.toggleTorch();
                    setState(() => _torchOn = !_torchOn);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
