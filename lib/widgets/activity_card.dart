import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:provider/provider.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _isOnCooldown = false;
  Duration _cooldown = const Duration();

  Timer? _cooldownTimer;

  void _initData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool isOnCooldown = await FirestoreMethods()
        .isActivityOnCooldown(userProvider.user!, widget.activity);
    setState(() {
      _isOnCooldown = isOnCooldown;
    });
    if (isOnCooldown) {
      _cooldown = await FirestoreMethods()
          .getRemainingActivityCooldown(userProvider.user!, widget.activity);
      startTimer();
    }
  }

  void startTimer() {
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldown.inSeconds == 0) {
        timer.cancel();
        setState(() {
          _isOnCooldown = false;
        });
      } else {
        setState(() {
          _cooldown = _cooldown - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  _logActivity() async {
    setState(() {
      _isOnCooldown = true;
    });
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await FirestoreMethods()
        .logActivityAndIncrementSkill(userProvider.user!, widget.activity);
    _cooldown = widget.activity.cooldown;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    //  Conditionally render either the activity details or a cooldown
    Widget content = InkWell(
      onTap: _logActivity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(widget.activity.icon,
                      color: widget.activity.skillColor, size: 48),
                  Text(
                    '+${widget.activity.reward.value} XP',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: widget.activity.skillColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: Container(),
              ),
              Text(widget.activity.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              if (widget.activity.cooldown.inMinutes < 60)
                Text(
                  'Cooldown: ${widget.activity.cooldown.inMinutes} min',
                  style: Theme.of(context).textTheme.titleSmall,
                )
              else if (widget.activity.cooldown.inHours < 24)
                Text(
                  'Cooldown: ${widget.activity.cooldown.inHours} hr',
                  style: Theme.of(context).textTheme.titleSmall,
                )
              else
                Text(
                  'Cooldown: ${widget.activity.cooldown.inDays} days',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
            ],
          ),
        ),
      ),
    );

    //  Conditionally render the cooldown overlay
    if (_isOnCooldown) {
      content = Stack(
        children: <Widget>[
          content,
          const Positioned.fill(
              child: Center(
                  child: Icon(
            Icons.lock_clock,
            size: 136,
          ))),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(4),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.activity.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      'Cooldown:',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      // Displaying the remaining cooldown time HH:MM:SS
                      '${_cooldown.inHours.toString().padLeft(2, '0')}:${(_cooldown.inMinutes % 60).toString().padLeft(2, '0')}:${(_cooldown.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return content;
  }
}
