

import 'package:faturax/controller/internet_tester_controller.dart';
import 'package:faturax/models/auth/auth_model.dart';
import 'package:faturax/models/items/items_model.dart';
import 'package:faturax/models/product/new_product.dart';
import 'package:faturax/models/product/product_model.dart';
import 'package:faturax/models/ranking/ranking_model.dart';
import 'package:faturax/models/user/user_model.dart';
import 'package:faturax/ui/pages/auth/auth_page.dart';
import 'package:faturax/ui/pages/error_connection_page.dart';
import 'package:faturax/ui/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MultiProvider(
          key: ValueKey(snapshot.data?.uid),
          providers: [
            ChangeNotifierProvider(create: (_) => UserModel()),
            ChangeNotifierProvider(create: (_) => NewProduct()),
            ChangeNotifierProvider(create: (_) => AuthModel()),
            ChangeNotifierProvider(create: (_) => ItemsModel()),
            ChangeNotifierProvider(create: (_) => RankingModel()),
            ChangeNotifierProvider(create: (_) => UserView()),
            ChangeNotifierProvider(create: (_) => InternetTesterController()),
            ChangeNotifierProvider(create: (_) => ProductModel()),
          ],
          child: MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1)),
                child: child!,
              );
            },
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('pt', 'BR')],
            locale: Locale('pt', 'BR'),
            debugShowCheckedModeBanner: false,
            title: 'FaturaX',
            theme: ThemeData(
              textTheme: GoogleFonts.figtreeTextTheme(),
              colorScheme: .fromSeed(seedColor: Colors.deepPurple),
            ),
            home: Consumer<InternetTesterController>(
              builder: (context, data, _) {
                if (!data.status) {
                  return ErrorConnectionPage();
                }
                return snapshot.hasData ? HomePage() : AuthPage();
              },
            ),
          ),
        );
      },
    );
  }
}
