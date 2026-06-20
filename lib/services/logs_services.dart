import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LogsServices {
  final BuildContext? context;
  final String message;
  final String type;
  final String? username;

  LogsServices({
    this.context,
    required this.message,
    required this.type,
    this.username,
  }) {
    _exec();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveLog() async {
    final DateTime now = DateTime.now();
    final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
    final String date = '[${format.format(now)}]';

    UserRepository? user;

    if (context != null) {
      user = context!.read<UserRepository>();
    }

    String? name = user?.username ?? username;

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    await _firestore.collection('logs').doc(timeStamp.toString()).set({
      'date': date,
      'type': type,
      'message': name != null ? '$name $message' : message,
      'timestamp': timeStamp,
    });
  }

  void _exec() async {
    await _saveLog();
  }
}
