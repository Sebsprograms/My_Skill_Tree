import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  String? id;
  String activityId;
  String skillId;
  DateTime timeStamp;
  int xp;

  Log({
    required this.activityId,
    required this.skillId,
    required this.timeStamp,
    required this.xp,
    this.id,
  });

  static Log fromSnapshot(DocumentSnapshot doc) {
    return Log(
      activityId: doc['activityId'],
      skillId: doc['skillId'],
      timeStamp: doc['timeStamp'].toDate(),
      xp: doc['xp'],
      id: doc.id,
    );
  }

  toJson() {
    return {
      'activityId': activityId,
      'skillId': skillId,
      'timeStamp': timeStamp,
      'xp': xp,
    };
  }
}
