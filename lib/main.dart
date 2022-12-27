import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  List<int> dropdowmMenu = [10, 50, 250, 500, 750, 1000];
  int dropdownValue = 500;

  checkLight() async {
    try {
      await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      if (kDebugMode) {
        print("!!! NO FLASH FOUND !!!");
      }
    }
  }

  flashOn() async {
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      if (kDebugMode) {
        print(_.toString());
      }
    }
  }

  flashOFF() async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      if (kDebugMode) {
        print(_.toString());
      }
    }
  }

  sosTimer(int stop) {
    _timer = Timer.periodic(Duration(milliseconds: stop), (Timer t) {
      if (t.tick % 2 == 1) {
        flashOn();
      } else {
        flashOFF();
      }
    });
  }

  onSos(int time) {
    stopTimer();
    sosTimer(time);
  }

  stopTimer() {
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

              elevation: 4,
              child: SizedBox(
                height: 50,

                // decoration: BoxDecoration(color: Colors.grey),
                // alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton(
                    elevation: 3,
                    isExpanded: false,
                    borderRadius: BorderRadius.circular(20),
                    underline: null,
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: dropdowmMenu.map((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text("$items milliseconds"),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        onSos(dropdownValue);
                      });
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  flashOn();
                },
                child: const Text("ON")),
            ElevatedButton(
                onPressed: () {
                  stopTimer();
                  flashOFF();
                },
                child: const Text("OFF")),
          ],
        ),
      ),
    );
  }
}
