import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BewerberProfilSeite extends StatefulWidget {
  const BewerberProfilSeite({Key? key}) : super(key: key);

  @override
  _BewerberProfilSeiteState createState() => _BewerberProfilSeiteState();
}

class _BewerberProfilSeiteState extends State<BewerberProfilSeite> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _berufController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfilDaten();
  }

  void _loadProfilDaten() async {
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('bewerber_profiles')
              .doc(user!.uid)
              .get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        _nameController.text = data['name'] ?? '';
        _berufController.text = data['berufswunsch'] ?? '';
      }
    }
  }

  void _saveProfil() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('bewerber_profiles')
          .doc(user!.uid)
          .set({
            'name': _nameController.text,
            'berufswunsch': _berufController.text,
            'email': user!.email,
          });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profil gespeichert')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mein Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _berufController,
                decoration: InputDecoration(labelText: 'Berufswunsch'),
              ),
              SizedBox(height: 32),
              ElevatedButton(onPressed: _saveProfil, child: Text('Speichern')),
            ],
          ),
        ),
      ),
    );
  }
}
