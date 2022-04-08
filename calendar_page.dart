import 'package:flutter/material.dart';
import 'package:healthy_list/ad.dart';
import 'package:healthy_list/style.dart';
import 'package:healthy_list/utils/select_button.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("自己評価カレンダー",style: TextStyle(fontFamily: BoldFont),),
        ),
      body: Column(
        children: [
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: MeetingDataSource(_getDataSource()),
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
              onTap: (CalendarTapDetails details){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('自己評価'),
                        content: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SelectButton(
                                  onPressed: () => _getDataSource(),
                                  icon: Icon(Icons.play_arrow),
                                  label: "かんぺき",
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SelectButton(
                                  onPressed: () => _getDataSource(),
                                  icon: Icon(Icons.play_arrow),
                                  label: "グッド！",
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SelectButton(
                                  onPressed: () => _getDataSource(),
                                  icon: Icon(Icons.play_arrow),
                                  label: "まあまあ",
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SelectButton(
                                  onPressed: () => _getDataSource(),
                                  icon: Icon(Icons.play_arrow),
                                  label: "だめだめ",
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          new TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          )
                        ],
                      );
                    }
                );
              },
            ),
          ),
          SizedBox(height: 20.0,),
          adArea(),
          SizedBox(height: 20.0,)
        ],
      )
    );
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
}

List<Evaluation> _getDataSource() {

  //データをまとめるリスト
  final List<Evaluation> evaluation = <Evaluation> [];

  //データの用意
  final DateTime startTime = DateTime.now();
  final DateTime endTime = DateTime.now();

  //データをリストに追加
  evaluation.add(Evaluation(
      eventName: 'ここに変数を入れたい（かんぺき or グッド！ or まあまあ or だめだめ）',
      from: startTime,
      to: endTime,
      background: Colors.pinkAccent[400]!,
      isAllDay: true));

  // 以下のようにすれば場合分けできるのでは？

  // if(label == 'かんぺき'):
  //     evaluation.add(Evaluation(
  //     eventName: 'かんぺき',
  //     from: startTime,
  //     to: endTime,
  //     background: Colors.pinkAccent[400]!,
  //     isAllDay: true));
  // elif(label == 'グッド！'):
  //     evaluation.add(Evaluation(
  //     eventName: 'グッド！',
  //     from: startTime,
  //     to: endTime,
  //     background: Colors.pinkAccent[400]!,
  //     isAllDay: true));
  // elif(label == 'まあまあ'):
  //     evaluation.add(Evaluation(
  //     eventName: 'まあまあ',
  //     from: startTime,
  //     to: endTime,
  //     background: Colors.pinkAccent[400]!,
  //     isAllDay: true));
  // else:
  //     evaluation.add(Evaluation(
  //     eventName: 'だめだめ',
  //     from: startTime,
  //     to: endTime,
  //     background: Colors.pinkAccent[400]!,
  //     isAllDay: true));

  return evaluation;
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
