import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentVersion with ChangeNotifier {
  CurrentVersion() {
    _load();
  }

  final DocumentReference<Map<String, dynamic>> _collectionV1 =
      FirebaseFirestore.instance.collection('version').doc('v1');

  StreamSubscription<DocumentSnapshot>? _versionSubscription;

  String? _version;
  String? get version => _version;

  Future<void> _getCurrentVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    _version = info.version;
    notifyListeners();
  }

  void checkCurrentVersion(BuildContext context) {
    if (kDebugMode) return;

    _versionSubscription = _collectionV1.snapshots().listen((snapshot) async {
      final Map<String, dynamic>? data = snapshot.data();

      if (data == null) return;

      if (data['version'] != _version) {
        if (!context.mounted) return;
        await _showForceUpdateDialog(context, data['version']);
      }
    });
  }

  void _load() async {
    await _getCurrentVersion();
  }

  @override
  void dispose() {
    _versionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _showForceUpdateDialog(
    BuildContext context,
    String version,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.blackBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(
          Icons.system_update_rounded,
          color: AppColor.purpleColor,
          size: 36,
        ),
        title: Text(
          'Novo App disponível',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Desinstale esta versão e instale a nova.\n\nFeche o app, desinstale e baixe a versão atualizada.',
          style: TextStyle(
            color: AppColor.greyColor,
            fontSize: 14,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        actions: [
          Center(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.purpleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => launchUrl(
                Uri.parse(
                  'https://github.com/Vinnybrunn00/faturax-app/releases/download/v$version/app-release.apk',
                ),
                mode: LaunchMode.externalApplication,
              ),
              icon: Icon(Icons.download_rounded, color: AppColor.whiteColor),
              label: Text(
                'Baixar nova versão',
                style: TextStyle(color: AppColor.whiteColor),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => exit(0),
              child: Text(
                'Fechar app',
                style: TextStyle(color: AppColor.greyColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
