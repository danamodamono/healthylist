import 'package:flutter/material.dart';
import 'package:healthy_list/ad.dart';
import 'package:healthy_list/calender/new_calendar_edit_screen.dart';
import 'package:healthy_list/db/calendar_db1.dart';
import 'package:healthy_list/main.dart';

import 'package:healthy_list/style.dart';
import 'package:healthy_list/utils/select_button.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class NewCalendarPage extends StatefulWidget {
  @override
  State<NewCalendarPage> createState() => _NewCalendarPageState();
}

class _NewCalendarPageState extends State<NewCalendarPage> {
  List<Evaluation> _evaluationList = [];

  final DateTime startTime = DateTime.now();
  final DateTime endTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getAllStamps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "自己評価カレンダー",
          style: TextStyle(fontFamily: BoldFont),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _newStamp(),
        child: Icon(Icons.add),
        tooltip: "追加",
      ),
      body: Column(
        children: [
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: MeetingDataSource(_evaluationListWidget()),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                navigationDirection: MonthNavigationDirection.vertical,
                monthCellStyle: MonthCellStyle(
                  backgroundColor: Colors.black,
                  trailingDatesBackgroundColor: Colors.black12,
                  leadingDatesBackgroundColor: Colors.black12,
                  todayBackgroundColor: Colors.black,
                ),
              ),
              showDatePickerButton: true,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          adArea(),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text('※当日のみ変更可です。'))
        ],
      ),
    );
  }

  _newStamp() {
    //今日のセルが空欄かどうかで分けたい
    if (_evaluationList.length == 0) {
      _addNewStamp();
    } else {
      _editNewStamp();
    }
  }

  _addNewStamp() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NewCalendarEditScreen(
              status: EditStatus.ADD,
            )));
  }

  _editNewStamp() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NewCalendarEditScreen(
              status: EditStatus.EDIT,
            )));
  }

  void _getAllStamps() async{
    _evaluationList = (await calendar.allStamps).cast<Evaluation>();
    setState(() {});
  }

  Widget adArea() {
    int width = MediaQuery.of(context).size.width.floor();
    int height = (MediaQuery.of(context).size.height * 0.1).floor();

    return SizedBox(
      height: height.toDouble(),
      width: width.toDouble(),
      child: Center(
        child: AdManager().getBannerAdWidget(width, height),
      ),
    );
  }



  List<Evaluation> _evaluationListWidget() {
    _evaluationList.add(Evaluation(
        eventName: _evaluationList.strEvaluation,
        from: startTime,
        to: endTime,
        background: Colors.pinkAccent[400]!,
        isAllDay: true,
    ),
    );
    return _evaluationList;
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Evaluation> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Evaluation _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Evaluation meetingData;
    if (meeting is Evaluation) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Evaluation {
  /// Creates a meeting class with required details.
  Evaluation({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
  });

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
