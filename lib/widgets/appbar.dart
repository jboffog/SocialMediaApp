import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_media_app/utils/constants.dart';

AppBar header(context) {
  return AppBar(
    title: Text(Constants.appName),
    centerTitle: true,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(Ionicons.notifications_outline),
      )
    ],
  );
}
