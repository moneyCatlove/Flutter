import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String result = "Loading...";
  final BluetoothDevice device =
      BluetoothDevice(remoteId: const DeviceIdentifier("6F:55:45:34:23:23"));

  @override
  void initState() {
    super.initState();
    connectToDevice(device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(result),
      ),
    );
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      await device.discoverServices();
      for (BluetoothService a in device.servicesList) {
        for (BluetoothCharacteristic c in a.characteristics) {
          if (c.properties.read) {
            List<int> value = await c.read();
          }
        }
      }
    } catch (e) {
      throw Exception("불가능");
    }
  }

  // Future<String> readData() async {
  //   try {
  //     var value = await testRead.read();
  //     return String.fromCharCodes(parseHexString(value.toString()));
  //   } catch (e) {
  //     return "읽기 실패";
  //   }
  // }

  List<int> parseHexString(String hexString) {
    if (hexString.length % 2 != 0) {
      throw FormatException("Invalid hex string length");
    }

    List<int> result = [];
    for (int i = 0; i < hexString.length; i += 2) {
      String byteString = hexString.substring(i, i + 2);
      result.add(int.parse(byteString, radix: 16));
    }

    return result;
  }
}
