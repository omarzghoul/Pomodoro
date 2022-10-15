import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pomodoro/service/auth.dart';

FirebaseFirestore instance = FirebaseFirestore.instance;
 AuthService _auth = AuthService();

create(task, stat,uid) {
  instance.collection("UserData").doc(uid).collection("Tasks").add({
    'task': task,
    'stat': stat,
  });
}



delete(id,uid) {
  instance.collection("UserData").doc(uid).collection("Tasks").doc(id).delete();
}

update(id,uid, task, stat) {
  instance.collection("UserData").doc(uid).collection("Tasks").doc(id).update({
    'task': task,
    'stat': stat,
  });
}

Stream<QuerySnapshot> getStream() async* {
    String uid = await _auth.getCurrintUID();

    yield* FirebaseFirestore.instance
        .collection("UserData")
        .doc(uid)
        .collection("Tasks")
        .snapshots();
  }
