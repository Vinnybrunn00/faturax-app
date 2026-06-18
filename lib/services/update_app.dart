import 'dart:io';

import 'package:faturax_app/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class UpdateApp {
  final BuildContext context;

  UpdateApp({required this.context}) {
    _update();
  }

  final ShorebirdUpdater _updater = ShorebirdUpdater();

  Future<void> _checkUpdate() async {
    if (!_updater.isAvailable) return;

    final status = await _updater.checkForUpdate();

    if (status == UpdateStatus.outdated) {
      await _updater.update();
      await _showDialog();
    }
  }

  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.blackBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(
          Icons.system_update_rounded,
          color: AppColor.pupleColor,
          size: 36,
        ),
        title: Text(
          'Atualização disponível',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Uma nova versão está pronta. Feche e abra o app para aplicar.',
          style: TextStyle(
            color: AppColor.greyColor,
            fontSize: 14,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Agora não',
              style: TextStyle(color: AppColor.greyColor),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColor.pupleColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              Navigator.pop(context);
              exit(0);
            },
            child: Text(
              'Fechar app',
              style: TextStyle(color: AppColor.whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  void _update() async {
    await _checkUpdate();
  }
}
