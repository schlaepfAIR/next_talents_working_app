import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home/pages/bewerber_profil_page.dart';
// import 'login_page.dart';  // Annahme: Es existiert eine Login-Seite

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase initialisieren
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bewerber App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Entscheidet, ob Login- oder Profilseite als Startseite angezeigt wird
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Warten, bis Auth-Status bestimmt ist
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data != null) {
            // Benutzer ist eingeloggt -> Profilseite anzeigen
            return BewerberProfilSeite();
          } else {
            // Kein eingelogger Benutzer -> Login-Seite anzeigen
            // Hier sollte auf die existierende Login-Seite verwiesen werden
            return Scaffold(
              body: Center(child: Text('Bitte loggen Sie sich ein')),
            );
            // In einer realen App würde man z.B. return LoginPage(); ausführen.
          }
        },
      ),
      // Optional: Routen definieren, falls Navigation per Named Routes gewünscht ist
      routes: {
        '/profile': (context) => BewerberProfilSeite(),
        // '/login': (context) => LoginPage(),  // falls LoginPage existiert
      },
    );
  }
}
