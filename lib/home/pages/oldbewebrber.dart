import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BewerberProfilSeite extends StatefulWidget {
  final String? code;
  final String? state;

  const BewerberProfilSeite({super.key, this.code, this.state});

  @override
  State<BewerberProfilSeite> createState() => _BewerberProfilSeiteState();
}

class _BewerberProfilSeiteState extends State<BewerberProfilSeite> {
  final String cloudFunctionUrl =
      'https://linkedintoken-ctdyrm2sla-uc.a.run.app'; // Deine Cloud Function URL
  final String redirectUri = 'https://nexttalents-15c76.web.app/bewerberProfil';
  final String expectedState = 'abc123xyz';

  Map<String, dynamic>? profileData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkRedirectAndLoadProfile();
  }

  void _checkRedirectAndLoadProfile() async {
    final code = widget.code;
    final state = widget.state;

    if (code != null && state == expectedState) {
      print('🔄 Token-Anfrage via Cloud Function');
      try {
        final response = await http.post(
          Uri.parse(cloudFunctionUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'code': code, 'redirectUri': redirectUri}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('✅ Daten empfangen: $data');

          setState(() {
            profileData = data;
          });
        } else {
          setState(() {
            errorMessage =
                'Cloud Function Fehler: ${response.statusCode} - ${response.body}';
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Fehler beim Laden der Profildaten: $e';
        });
      }
    }
  }

  void _loginWithLinkedIn() {
    final authUrl = Uri.https('www.linkedin.com', '/oauth/v2/authorization', {
      'response_type': 'code',
      'client_id': '782g9jewj0oqze', // Dein LinkedIn Client ID
      'redirect_uri': redirectUri,
      'state': expectedState,
      'scope': 'openid profile email',
    });

    html.window.location.href = authUrl.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bewerberprofil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              errorMessage != null
                  ? Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                  : profileData == null
                  ? ElevatedButton(
                    onPressed: _loginWithLinkedIn,
                    child: const Text('Mit LinkedIn anmelden'),
                  )
                  : Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (profileData!['imageUrl'] != null)
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                profileData!['imageUrl'],
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            '${profileData!['firstName']} ${profileData!['lastName']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profileData!['email'] ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
