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

  _logActivity() async {
    setState(() {
      _isOnCooldown = true;
    });
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await FirestoreMethods()
        .logActivityAndIncrementSkill(userProvider.user!, widget.activity);
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
                  '${widget.activity.cooldown.inMinutes} minutes',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              else if (widget.activity.cooldown.inHours < 24)
                Text(
                  '${widget.activity.cooldown.inHours} hours',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              else
                Text(
                  '${widget.activity.cooldown.inDays} days',
                  style: Theme.of(context).textTheme.titleMedium,
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
                      'Activity',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      'Cooldown',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      '00:00:00',
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
