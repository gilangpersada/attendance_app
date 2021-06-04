import 'package:attendance_app/student_ui/student_attend_page.dart';
import 'package:attendance_app/student_ui/student_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool toggleFlash = false;
  bool toggleCamera = false;
  String keyCode;
  GlobalKey qrKey = GlobalKey();
  Barcode result;
  QRViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
              ),
              onQRViewCreated: (QRViewController controller) {
                setState(() {
                  this.controller = controller;
                });
                controller.scannedDataStream.listen((event) {
                  if (mounted) {
                    result = event;
                    keyCode = result.code;
                    controller.dispose();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AttendClass(
                            data: keyCode,
                          );
                        },
                      ),
                    );
                  }
                });
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon:
                        Icon((toggleFlash) ? Icons.flash_off : Icons.flash_on),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleFlash = !toggleFlash;
                      });
                      controller.toggleFlash();
                    },
                  ),
                  IconButton(
                    icon: Icon((toggleCamera)
                        ? Icons.flip_camera_ios
                        : Icons.flip_camera_ios_outlined),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleCamera = !toggleCamera;
                      });
                      controller.flipCamera();
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 30,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.blue[900],
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return StudentPage();
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
