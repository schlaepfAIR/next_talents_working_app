import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_talents_working_app/home/widgets/app_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum UserType { bewerber, firma }

class _RegisterPageState extends State<RegisterPage> {
  UserType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ich bin...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ToggleButtons(
              isSelected: [
                _selectedType == UserType.bewerber,
                _selectedType == UserType.firma,
              ],
              onPressed: (index) {
                setState(() {
                  _selectedType = UserType.values[index];
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Bewerber'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Firma'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_selectedType == UserType.bewerber) const BewerberForm(),
            if (_selectedType == UserType.firma) const FirmenForm(),
          ],
        ),
      ),
    );
  }
}

class BewerberForm extends StatefulWidget {
  const BewerberForm({super.key});

  @override
  State<BewerberForm> createState() => _BewerberFormState();
}

class _BewerberFormState extends State<BewerberForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await userCredential.user?.updateDisplayName(
        '${_firstNameController.text} ${_lastNameController.text}',
      );

      if (!mounted) return;
      Navigator.pushNamed(context, '/bewerberProfil');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = 'Fehler: ${e.code} – ${e.message}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: 'Vorname'),
        ),
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(labelText: 'Nachname'),
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-Mail'),
          keyboardType: TextInputType.emailAddress,
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Passwort'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _register,
          child:
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Registrieren'),
        ),
      ],
    );
  }
}

class FirmenForm extends StatelessWidget {
  const FirmenForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: const [Text('Firmen-Registrierung folgt ...')]);
  }
}
