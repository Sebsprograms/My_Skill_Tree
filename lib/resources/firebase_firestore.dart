import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/models/user.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Skill>> skillStream(AppUser user) {
    var ref =
        _firestore.collection('skills').doc(user.uid).collection('skills');
    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Skill.fromSnapshot(doc)).toList());
  }

  Future<List<Skill>> getSkills(AppUser user) async {
    var ref =
        _firestore.collection('skills').doc(user.uid).collection('skills');
    var snapshot = await ref.get();
    return snapshot.docs.map((doc) => Skill.fromSnapshot(doc)).toList();
  }

  Stream<List<Activity>> allActivitiesStream(AppUser user) {
    var ref = _firestore
        .collection('activities')
        .doc(user.uid)
        .collection('activities');
    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Activity.fromSnapshot(doc)).toList());
  }

  Stream<List<Activity>> activitiesForSkillStream(
      AppUser user, String skillId) {
    var ref = _firestore
        .collection('activities')
        .doc(user.uid)
        .collection('activities')
        .where('skillId', isEqualTo: skillId);
    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Activity.fromSnapshot(doc)).toList());
  }

  Future<void> addSkill(AppUser user, Skill skill) async {
    var ref =
        _firestore.collection('skills').doc(user.uid).collection('skills');
    await ref.add(skill.toJson());
  }

  Future<void> addActivity(AppUser user, Activity activity) async {
    var ref = _firestore
        .collection('activities')
        .doc(user.uid)
        .collection('activities');
    await ref.add(activity.toJson());
  }

  Future<void> updateSkill(AppUser user, Skill skill) async {
    var ref = _firestore
        .collection('skills')
        .doc(user.uid)
        .collection('skills')
        .doc(skill.id);
    await ref.update(skill.toJson());
  }

  Future<void> deleteSkill(AppUser user, Skill skill) async {
    var ref = _firestore
        .collection('skills')
        .doc(user.uid)
        .collection('skills')
        .doc(skill.id);
    await ref.delete();
  }

  Future<void> deleteActivity(AppUser user, Activity activity) async {
    var ref = _firestore
        .collection('activities')
        .doc(user.uid)
        .collection('activities')
        .doc(activity.id);
    await ref.delete();
  }
}
