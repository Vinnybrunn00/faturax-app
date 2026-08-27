import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:yaml/yaml.dart';

import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';

void main() async {
  final File file = File('/home/vindev/projects/faturax_app/pubspec.yaml');
  final String content = file.readAsStringSync();

  final yaml = loadYaml(content);

  final String version = yaml['version'];

  final String path =
      '/home/vindev/projects/faturax_app/build/app/outputs/apk/release/app-release.apk';

  final app = FirebaseApp.initializeApp(
    options: AppOptions(
      credential: Credential.fromServiceAccount(
        File('/home/vindev/projects/faturax_app/lib/service-account.json'),
      ),
      projectId: 'fatura-x-a7711',
    ),
  );

  await run('shorebird release android --artifact apk');
  print('\n\n');
  await run('gh release create v$version $path --title "Versão $version"');
  print('\n\n');
  final firestore = app.firestore();
  await firestore.collection('version').doc('v1').update({'version': version});
}
