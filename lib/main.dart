import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:next_talents_working_app/theme.dart';
import 'package:next_talents_working_app/home/home_page.dart';
import 'package:next_talents_working_app/home/pages/about_page.dart';
import 'package:next_talents_working_app/home/pages/contact_page.dart';
import 'package:next_talents_working_app/home/pages/register_page.dart';
import 'package:next_talents_working_app/home/pages/how_it_works_page.dart'
    as how;
import 'package:next_talents_working_app/home/pages/bewerber_profil_page.dart';

import 'package:next_talents_working_app/home/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NextTalentsApp());
}

class NextTalentsApp extends StatelessWidget {
  const NextTalentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Talents',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');

        // Bewerberprofil mit optionalen Parametern
        if (uri.path == '/bewerberProfil') {
          final code = uri.queryParameters['code'];
          final state = uri.queryParameters['state'];
          return MaterialPageRoute(
            builder: (_) => BewerberProfilSeite(code: code, state: state),
          );
        }

        // Feste Seiten
        switch (uri.path) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutPage());
          case '/contact':
            return MaterialPageRoute(builder: (_) => const ContactPage());
          case '/how-it-works':
            return MaterialPageRoute(
              builder: (_) => const how.HowItWorksPage(),
            );
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterPage());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          default:
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('404 – Seite nicht gefunden')),
                  ),
            );
        }
      },
    );
  }
}
