import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthy_list/ad.dart';
import 'package:healthy_list/calender/new_calendar_page.dart';
import 'package:healthy_list/conponents/card_background.dart';
import 'package:healthy_list/db/calendar_db1.dart';
import 'package:healthy_list/db/database.dart';
import 'package:healthy_list/goodeat/pages/sub/goodeat_drink.dart';
import 'package:healthy_list/main.dart';
import 'package:healthy_list/utils/select_button.dart';

enum EditStatus { ADD, EDIT }

class NewCalendarEditScreen extends StatefulWidget {
  final EditStatus status;
  final Stamp? stamp;
  NewCalendarEditScreen({required this.status, this.stamp});

  @override
  _NewCalendarEditScreenState createState() => _NewCalendarEditScreenState();
}

class _NewCalendarEditScreenState extends State<NewCalendarEditScreen> {
  TextEditingController stampController = TextEditingController();
  final DateTime startTime = DateTime.now();
  final DateTime endTime = DateTime.now();
  String _titleText = "";

  @override
  void initState() {
    super.initState();
    if (widget.status == EditStatus.ADD) {
      _titleText = "新規登録";
      stampController.text = "";
    } else {
      _titleText = "編集";
      stampController.text = widget.stamp!.strEvaluation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backToNewCalendarPage(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleText),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              tooltip: "決定",
              onPressed: () => _onWordRegistered(),
              iconSize: 30,
            )
          ],
        ),
        body: Stack(
          children: [
            CardBackground(),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _stampNameInputPart(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: SelectButton(
                      onPressed: () => _inputbutton1(),
                      icon: Icon(Icons.play_arrow),
                      label: "かんぺき",
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: SelectButton(
                      onPressed: () => _inputbutton2(),
                      icon: Icon(Icons.play_arrow),
                      label: "グッド！",
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: SelectButton(
                      onPressed: () => _inputbutton3(),
                      icon: Icon(Icons.play_arrow),
                      label: "まあまあ",
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: SelectButton(
                      onPressed: () => _inputbutton4(),
                      icon: Icon(Icons.play_arrow),
                      label: "だめだめ",
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  adArea(),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _inputbutton1() {
    if(stampController.text == "") {
      stampController.text = "かんぺき";
    } else {
      stampController.clear();
      stampController.text = "かんぺき";
    }
  }

  _inputbutton2() {
    if(stampController.text == "") {
      stampController.text = "グッド！";
    } else {
      stampController.clear();
      stampController.text = "グッド！";
    }
  }

  _inputbutton3() {
    if(stampController.text == "") {
      stampController.text = "まあまあ";
    } else {
      stampController.clear();
      stampController.text = "まあまあ";
    }
  }

  _inputbutton4() {
    if(stampController.text == "") {
      stampController.text = "だめだめ";
    } else {
      stampController.clear();
      stampController.text = "だめだめ";
    }
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

  Widget _stampNameInputPart() {
    return Column(
      children: <Widget>[
        Text(
          "今日の評価は",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: stampController,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.black87,
          ),
        )
      ],
    );
  }

  Future<bool> _backToNewCalendarPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NewCalendarPage()));
    return Future.value(false);
  }

  _onWordRegistered() {
    if (widget.status == EditStatus.ADD) {
      _insertWord();
    } else {
      _updateWord();
    }
  }

  _insertWord() async {
    if (stampController.text == "") {
      Fluttertoast.showToast(
        msg: "名称を入力しないと登録できません",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    var stamp = Stamp(
      id: 0, //自動なのに手入力？
      strEvaluation: stampController.text,
      limitDate: DateTime.now(),
    );

    try {
      await calendar.addStamps(stamp);
      stampController.clear();
      // 登録完了メッセージ
      Fluttertoast.showToast(
        msg: "登録が完了しました",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } on SqliteException catch (e) {
      Fluttertoast.showToast(
        msg: "この名称は既に登録されていますので登録できません",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _updateWord() async {
    if (stampController.text == "") {
      Fluttertoast.showToast(
        msg: "名称を入力しないと登録できません",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    var stamp = Stamp(
      id: 0, //自動なのに手入力？
      strEvaluation: stampController.text,
      limitDate: DateTime.now(),
    );

    try {
      await calendar.updateWord(stamp);
      _backToNewCalendarPage();
      Fluttertoast.showToast(
        msg: "編集が完了しました",
        toastLength: Toast.LENGTH_LONG,
      );
    } on SqliteException catch (e) {
      Fluttertoast.showToast(
        msg: "何らかの問題が発生して登録できませんでした。: $e",
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
  }


}
