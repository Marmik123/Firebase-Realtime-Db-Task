import 'package:firebase_database/firebase_database.dart';
import 'package:rootally_task/app/model/excercise_session.dart';

class DataAccess {
  final DatabaseReference dataRef =
      FirebaseDatabase.instance.reference().child('sessions');

  Query dataFetch() {
    return dataRef.orderByKey();
  }

  static Future<List<Session>> getSessions() async {
    List<Session> sessions = <Session>[];
    Query fetchSession =
        FirebaseDatabase.instance.reference().child('sessions').orderByKey();
    print('QUERY IS $fetchSession');
    await fetchSession.once().then((value) {
      Map<dynamic, dynamic> values = value.value;
      print('MAP IS $values');
      values.forEach((key, value) {
        sessions.add(Session.fromJson(value));
        sessions.forEach((element) {
          print(element.sessionName);
        });
        print('LIST IS $sessions');
      });
    });
    print('LIST BEFORE POPULATING IS $sessions');
    return sessions;
  }
}
