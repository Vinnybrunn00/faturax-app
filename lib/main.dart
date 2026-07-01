import 'package:faturax_app/services/current_version.dart';
import 'package:faturax_app/ui/pages/auth/auth_bubble_page.dart';
import 'package:faturax_app/viewmodels/date_picker.dart';
import 'package:faturax_app/repository/next_month_product.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'viewmodels/home_view_model.dart';
import 'controller/internet_tester_controller.dart';
import 'viewmodels/auth_model.dart';
import 'viewmodels/items_model.dart';
import 'viewmodels/product_model.dart';
import 'repository/ranking_repository.dart';
import 'repository/user_repository.dart';
import 'ui/pages/error_connection_page.dart';
import 'ui/pages/home_page.dart';
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
  runApp(const FaturaX());
}

class FaturaX extends StatelessWidget {
  const FaturaX({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MultiProvider(
          key: ValueKey(snapshot.data?.uid),
          providers: [
            ChangeNotifierProvider(create: (_) => UserRepository()),
            ChangeNotifierProvider(create: (_) => DatePicker()),
            ChangeNotifierProvider(create: (_) => AuthModel()),
            ChangeNotifierProvider(create: (_) => ItemsModel()),
            ChangeNotifierProvider(create: (_) => RankingRepository()),
            ChangeNotifierProvider(create: (_) => UserView()),
            ChangeNotifierProvider(create: (_) => InternetTesterController()),
            ChangeNotifierProvider(create: (_) => ProductModel()),
            ChangeNotifierProvider(create: (_) => ProductRepository()),
            ChangeNotifierProvider(create: (_) => NextMonthProduct()),
            ChangeNotifierProvider(create: (_) => CurrentVersion()),
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
            home: Consumer2<InternetTesterController, CurrentVersion>(
              builder: (context, checkNet, currentVersion, _) {
                currentVersion.checkCurrentVersion(context);
                if (!checkNet.status) {
                  return ErrorConnectionPage();
                }
                return snapshot.hasData ? HomePage() : AuthBubblePage();
              },
            ),
          ),
        );
      },
    );
  }
}
