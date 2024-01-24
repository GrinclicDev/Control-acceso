import 'dart:async';

import 'package:barcode_scanner/barcode_scanning_data.dart';
import 'package:barcode_scanner/json/common_data.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_sdk_models.dart';
import 'package:control_acceso_emlaze/domain/datasources/autenticare_datasource.dart';
import 'package:control_acceso_emlaze/presentation/shared/footer_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccessScreen extends StatefulWidget {
  static const name = 'access-screen';
  const AccessScreen({super.key});

  @override
  _AccessScreenState createState() {
    var config = ScanbotSdkConfig(loggingEnabled: true);
    ScanbotBarcodeSdk.initScanbotSdk(config);
    return _AccessScreenState();
  }
}

class _AccessScreenState extends State<AccessScreen> {
  late Timer _timer;

  // final _flashOnController = TextEditingController(text: 'Flash on');
  // final _flashOffController = TextEditingController(text: 'Flash off');
  // final _cancelController = TextEditingController(text: 'Cancel');

  // final _aspectTolerance = 5.00;
  // final _selectedCamera = -1;
  // final _useAutoFocus = true;
  // final _autoEnableFlash = false;
  // static final _possibleFormats = BarcodeFormat.values.toList()
  //   ..removeWhere((e) => e == BarcodeFormat.unknown);

  // List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
    AutenticateDatosurce().loadAccess();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: SizedBox(
              width: 30,
              height: 210,
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '¡Bienvenido!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Escanee el código de barras de la cédula del personal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });

    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future scanCode(int value) async {
    var config = BarcodeScannerConfiguration(
      barcodeFormats: [BarcodeFormat.PDF_417],
      topBarBackgroundColor: Colors.blueAccent,
      finderTextHint: "Please align a barcode in the frame to scan it.",
      cancelButtonTitle: "Cancel",
      flashEnabled: true,
    );
    var result = await ScanbotBarcodeSdk.startBarcodeScanner(config);
    print("Aqui ${result.barcodeItems.map((e) => e.formattedResult)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Control de acceso EMLAZE ERP'),
        backgroundColor: const Color.fromARGB(255, 51, 122, 183),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            onPressed: () {
              AutenticateDatosurce().destroySession();
              context.go('/home/0');
            },
            icon: const Icon(Icons.exit_to_app_rounded),
            color: Colors.white,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/fondo.png'), fit: BoxFit.fill),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: 305,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: Column(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      width: 300,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Indique el tipo de registro',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      int value = 1;
                      scanCode(value);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 51, 122, 183),
                        padding: const EdgeInsets.only(right: 110, left: 110)),
                    child: const Text(
                      'Entrada',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 51, 122, 183),
                        padding: const EdgeInsets.only(right: 102, left: 102)),
                    child: const Text(
                      'Descanso',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 51, 122, 183),
                        padding: const EdgeInsets.only(right: 115, left: 115)),
                    child: const Text(
                      'Salida',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const FooterView(),
          ],
        )),
      ),
    );
  }
}
