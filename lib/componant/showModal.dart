import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/service/Firestore.dart';
import 'package:pomodoro/service/auth.dart';

class Show {
  AuthService _auth = AuthService();
  FirebaseFirestore instance = FirebaseFirestore.instance;
  void showAddTask(context, Containercolor, myController, Buttoncolor) =>
      showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          context: context,
          isScrollControlled: true,
          backgroundColor: Containercolor,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a Task',
                    ),
                  ),
                  Container(
                    color: Buttoncolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            myController.text = "";

                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () async {
                            final String uid = await _auth.getCurrintUID();

                           

                            create(myController.text, false, uid);

                            Navigator.pop(context);

                            myController.text = "";
                          },
                          child: Text("Save",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          });

  static void showEditTask(
      String id,String uid, context, Containercolor, Buttoncolor, myController) {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Containercolor,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: myController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                Container(
                  color: Buttoncolor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          delete(id,uid);
                          Navigator.pop(context);
                        },
                        child: Text("Delete",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              myController.text = "";

                              Navigator.pop(context);
                            },
                            child: Text("Cancel",
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              update(id,uid, myController.text, false);

                              
                              myController.text = "";

                              Navigator.pop(context);
                            },
                            child: Text("Save",
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
