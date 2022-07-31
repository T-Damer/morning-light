import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TorchController().initialize();
  runApp(const MorningLight());
}

class MorningLight extends StatefulWidget {
  const MorningLight({Key? key}) : super(key: key);

  @override
  _MorningLightState createState() => _MorningLightState();
}

class _MorningLightState extends State<MorningLight> {
  final controller = TorchController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TimeOfDay time = const TimeOfDay(hour: 10, minute: 30);

  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '${hours}:${minutes}',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () async {
                TimeOfDay? newTime =
                    await showTimePicker(context: context, initialTime: time);

                if (newTime == null) return;

                setState(() => time = newTime);
              },
              child: const Text('Select Time'))
        ]),
      ),
    );
  }
}
