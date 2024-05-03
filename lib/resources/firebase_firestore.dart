import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/models/log.dart';
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

  Future<Skill> getOneSkillById(AppUser user, String skillId) async {
    var ref = _firestore
        .collection('skills')
        .doc(user.uid)
        .collection('skills')
        .doc(skillId);
    var snapshot = await ref.get();
    return Skill.fromSnapshot(snapshot);
  }

  Future<void> incrememtSkillXp(AppUser user, Skill skill, int xp) async {
    if (skill.currentXp + xp >= skill.xpToNextLevel) {
      var ref = _firestore
          .collection('skills')
          .doc(user.uid)
          .collection('skills')
          .doc(skill.id);
      await ref.update({
        'currentXp': skill.currentXp + xp - skill.xpToNextLevel,
        'currentLevel': skill.currentLevel + 1,
        'xpToNextLevel':
            skill.xpToNextLevel + skill.difficulty.difficultyXpIncrease,
      });
    } else {
      var ref = _firestore
          .collection('skills')
          .doc(user.uid)
          .collection('skills')
          .doc(skill.id);
      await ref.update({'currentXp': skill.currentXp + xp});
    }
  }

  Future<void> decrementSkillXp(AppUser user, Skill skill, int xp) async {
    if (skill.currentXp - xp < 0) {
      var ref = _firestore
          .collection('skills')
          .doc(user.uid)
          .collection('skills')
          .doc(skill.id);
      await ref.update({
        'currentXp': (skill.xpToNextLevel -
                skill.xpToNextLevel -
                skill.difficulty.difficultyXpIncrease) -
            (xp - skill.currentXp),
        'currentLevel': skill.currentLevel - 1,
        'xpToNextLevel':
            skill.xpToNextLevel - skill.difficulty.difficultyXpIncrease,
      });
    } else {
      var ref = _firestore
          .collection('skills')
          .doc(user.uid)
          .collection('skills')
          .doc(skill.id);
      await ref.update({'currentXp': skill.currentXp - xp});
    }
  }

  Future<void> logActivityAndIncrementSkill(
    AppUser user,
    Activity activity,
  ) async {
    // Log the activity
    var logRef = _firestore
        .collection('activity_logs')
        .doc(user.uid)
        .collection('activity_logs');
    Log newLog = Log(
      activityId: activity.id!,
      skillId: activity.skillId,
      timeStamp: DateTime.now(),
      xp: activity.reward.value,
    );
    await logRef.add(newLog.toJson());

    // Increment the skill's xp
    Skill skill = await getOneSkillById(user, activity.skillId);
    await incrememtSkillXp(user, skill, activity.reward.value);
  }

  Future<void> deleteLogAndDecrementSkill(AppUser user, Log log) async {
    // Delete the log
    var logRef = _firestore
        .collection('activity_logs')
        .doc(user.uid)
        .collection('activity_logs')
        .doc(log.id);
    await logRef.delete();

    // Decrement the skill's xp
    Skill skill = await getOneSkillById(user, log.skillId);
    await decrementSkillXp(user, skill, log.xp);
  }

  Future<List<Log>> getLogs(AppUser user) async {
    var ref = _firestore
        .collection('activity_logs')
        .doc(user.uid)
        .collection('activity_logs');
    var snapshot = await ref.get();
    return snapshot.docs.map((doc) => Log.fromSnapshot(doc)).toList();
  }
}
