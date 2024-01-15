import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:pomodoro/Model/TaskData.dart';
import 'package:pomodoro/componant/showModal.dart';
import 'package:pomodoro/service/Firestore.dart';
import 'package:pomodoro/service/auth.dart';

class TimerController {
  late Timer _timer;
  int _elapsedSeconds = 0;

  void _startTimer(Function(int minutes, int seconds) updateCallback) {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _elapsedSeconds++;
      int minutes = _elapsedSeconds ~/ 60;
      int seconds = _elapsedSeconds % 60;
      updateCallback(minutes, seconds);
    });
  }

  void _pauseTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  void _resetTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _elapsedSeconds = 0;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void updateTimer(int newMinutes, int newSeconds) {
    setState(() {
      minutes = newMinutes;
      seconds = newSeconds;
    });
  }

  TimerController timerController = TimerController();
  int minutes = 0;
  int seconds = 0;
  String timer = "25:00";
  Map defaultcolors = {
    "primary": Color(0xffF87373),
    "appbar": Color(0xffF24646),
    "Container_countdown": Color(0xffFBA2A2),
    "button_start": Color(0xffCC5C5C),
  };
  Map pomodorocolors = {
    "primary": Color(0xffF87373),
    "appbar": Color(0xffF24646),
    "Container_countdown": Color(0xffFBA2A2),
    "button_start": Color(0xffCC5C5C),
  };
  Map shortBreakcolors = {
    "primary": Color(0xff108992),
    "appbar": Color(0xff0E7D85),
    "Container_countdown": Color(0xff5E9CA0),
    "button_start": Color(0xff0D6E75),
  };
  Map longBreakcolors = {
    "primary": Color(0xff457CA3),
    "appbar": Color(0xff4B7592),
    "Container_countdown": Color(0xff5889AC),
    "button_start": Color(0xff3F7296),
  };
  final myController = TextEditingController();
  AuthService _auth = AuthService();

  Show show = Show();

  void addTime() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: defaultcolors["primary"],
        drawer: Drawer(backgroundColor: Color(0xff3DA3C9)),
        appBar: AppBar(
          title: Center(
              child: Text(
            "Pomodoro",
          )),
          backgroundColor: defaultcolors["appbar"],
          actions: [
            TextButton(
                onPressed: () {
                  _auth.signOut(context);
                },
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              width: double.infinity,
              color: defaultcolors["Container_countdown"],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              //25
                              defaultcolors = pomodorocolors;
                              timer = "$minutes:$seconds";
                            });
                          },
                          child: Text("Pomodoro",
                              style: TextStyle(color: Colors.white)),
                          style: TextButton.styleFrom(
                              backgroundColor: defaultcolors["primary"])),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              //5
                              defaultcolors = shortBreakcolors;
                              timer = "$minutes:$seconds";
                            });
                          },
                          child: Text("Short Break",
                              style: TextStyle(color: Colors.white)),
                          style: TextButton.styleFrom(
                              backgroundColor: defaultcolors["primary"])),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              //15
                              defaultcolors = longBreakcolors;
                              timer = "$minutes:$seconds";
                            });
                          },
                          child: Text(
                            "Long Break",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: defaultcolors["primary"]))
                    ],
                  ),
                  Text(
                    "$minutes:$seconds",
                    style: TextStyle(fontSize: 80, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          timerController._startTimer(updateTimer);
                        },
                        child: Text("START"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultcolors["button_start"],
                          minimumSize: Size(100, 45),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          timerController._pauseTimer();
                        },
                        child: Text("Puse"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultcolors["button_start"],
                          minimumSize: Size(100, 45),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          timerController._resetTimer();
                          updateTimer(0, 0);
                        },
                        child: Text("Reast"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultcolors["button_start"],
                          minimumSize: Size(100, 45),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tasks",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Divider(
              height: 5,
              color: Colors.white,
            ),
            Expanded(
                child: StreamBuilder(
                    stream: getStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      else
                        return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return bulidTask(snapshot.data!.docs[index]);
                          },
                        );
                    })),
            Container(
              margin: EdgeInsets.all(4),
              child: ElevatedButton(
                onPressed: () {
                  show.showAddTask(
                      context,
                      defaultcolors["Container_countdown"],
                      myController,
                      defaultcolors["button_start"]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_box,
                      color: defaultcolors["appbar"],
                    ),
                    Text(
                      "Add Task",
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultcolors["Container_countdown"],
                  minimumSize: Size(double.infinity, 45),
                ),
              ),
            )
          ],
        ));
  }

  Widget bulidTask(DocumentSnapshot data) {
    return ListTile(
      leading: Checkbox(
        value: data["stat"],
        onChanged: (value) async {
          String uid = await _auth.getCurrintUID();
          update(data.id, uid, data["task"], value!);
        },
        activeColor: defaultcolors["button_start"],
      ),
      title: Text(
        data["task"],
        style: TextStyle(
            decoration:
                data["stat"] == true ? TextDecoration.lineThrough : null),
      ),
      trailing: TextButton(
          onPressed: () async {
            String uid = await _auth.getCurrintUID();

            Show.showEditTask(
                data.id,
                uid,
                context,
                defaultcolors["Container_countdown"],
                defaultcolors["button_start"],
                myController);
          },
          child: Icon(
            Icons.more_vert,
            color: Colors.black,
          )),
    );
  }
}
