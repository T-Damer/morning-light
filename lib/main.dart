import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:timetable/timetable.dart';
import 'package:flutter/services.dart';
import 'package:time_machine/time_machine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
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
  TimetableController<BasicEvent> _controller;

  @override
  void initState() {
    super.initState();

        _controller = TimetableController(
      eventProvider: EventProvider.list([
        BasicEvent(
          id: 0,
          title: 'My Event',
          color: Colors.blue,
          start: LocalDate.today().at(LocalTime(13, 0, 0)),
          end: LocalDate.today().at(LocalTime(15, 0, 0)),
        ),
      ]),

      // Other (optional) parameters:
      initialTimeRange: InitialTimeRange.range(
        startTime: LocalTime(8, 0, 0),
        endTime: LocalTime(20, 0, 0),
      ),
      initialDate: LocalDate.today(),
      visibleRange: VisibleRange.days(3),
      firstDayOfWeek: DayOfWeek.monday,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () => _controller.animateToToday(),
            tooltip: 'Jump to today',
          ),
        ],
        body: Center(
          child: Column(
            children: [
              FutureBuilder<bool?>(
                  future: controller.isTorchActive,
                  builder: (_, snapshot) {
                    final snapshotData = snapshot.data ?? false;

                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                          'Is torch on? ${snapshotData ? 'Yes!' : 'No :('}');
                    }

                    return Container();
                  }),
              MaterialButton(
                  child: const Text('Toggle'),
                  onPressed: () {
                    controller.toggle(intensity: 1);
                    setState(() {});
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
