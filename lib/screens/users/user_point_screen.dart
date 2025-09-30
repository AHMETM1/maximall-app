import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/events.dart';
import '../../models/index.dart' show UserModel, UserPoints;
import '../../services/index.dart' show ServerConfig, Services;

class UserPointScreen extends StatefulWidget {
  @override
  State<UserPointScreen> createState() => _StateUserPoint();
}

class _StateUserPoint extends State<UserPointScreen> {
  final dateWidth = 100;
  final pointWidth = 50;
  final borderWidth = 0.5;

  UserPoints? _userPoints;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  StreamSubscription<EventReloadMyPoints>? _subscription;

  Future<void> getUserPoint() async {
    try {
      final userModel = Provider.of<UserModel>(context, listen: false);
      final points = await httpGet(
          '${ServerConfig().url}/wp-json/api/flutter_user/get_points/?insecure=cool&user_id=${userModel.user!.id}'
              .toUri()!);
      setState(() {
        _userPoints = UserPoints.fromJson(json.decode(points.body));
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getUserPoint();
    });

    _subscription = eventBus.on<EventReloadMyPoints>().listen((event) {
      getUserPoint();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          S.of(context).myPoints,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: getUserPoint,
        child: _userPoints == null
            ? Align(
                alignment: Alignment.center,
                child: kLoadingWidget(context),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Services().renderMyPointsWidget(_userPoints?.points) !=
                                  null &&
                              kPointsOfflineStoreConfig.enabled
                          ? Services()
                              .renderMyPointsWidget(_userPoints?.points)!
                          : ListTile(
                              trailing: Text(
                                _userPoints?.points.toString() ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 35,
                                    ),
                              ),
                              title: Text(
                                S.of(context).myPoints,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                      const Divider(indent: 15.0, endIndent: 15.0),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          S.of(context).events,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          for (var event in _userPoints!.events)
                            ListTile(
                              trailing: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  event.points!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                ),
                              ),
                              title: Text(event.description!),
                              subtitle: Text(
                                event.date!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withValueOpacity(0.6),
                                ),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
