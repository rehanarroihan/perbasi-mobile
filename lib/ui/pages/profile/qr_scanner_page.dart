import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perbasitlg/cubit/profile/profile_cubit.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  ProfileCubit _profileCubit = ProfileCubit();

  @override
  void initState() {
    _profileCubit = BlocProvider.of<ProfileCubit>(context);

    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _profileCubit,
      listener: (context, state) {
        if (state is ScanQrCodeInit) {
          controller.pauseCamera();
          LoadingDialog(
            title: 'Silahkan Tunggu',
            description: 'Mengirimkan kode...'
          ).show(context);
        } else if (state is ScanQrCodeSuccessful) {
          Navigator.pop(context);
          controller.resumeCamera();
          AppAlertDialog(
            title: 'QR  Code',
            description: state.message,
            positiveButtonText: 'Ok',
            positiveButtonOnTap: () => Navigator.pop(context)
          ).show(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scan QR Code'),
          actions: [
            IconButton(
              icon: Icon(Icons.switch_camera),
              onPressed: () async {
                await controller?.flipCamera();
              },
            ),
            IconButton(
              icon: Icon(Icons.flash_off),
              onPressed: () async {
                await controller?.toggleFlash();
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildQrView(context))
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      cameraFacing: CameraFacing.back,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
        borderColor: AppColor.primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      _profileCubit.scanQRCode(scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}