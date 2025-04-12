import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BewerberProfilSeite extends StatefulWidget {
  const BewerberProfilSeite({Key? key}) : super(key: key);

  @override
  _BewerberProfilSeiteState createState() => _BewerberProfilSeiteState();
}

class _BewerberProfilSeiteState extends State<BewerberProfilSeite> {
  final _formKey = GlobalKey<FormState>();

  // Controller für Formularfelder
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Lädt vorhandene Profildaten des aktuellen Benutzers aus Firestore
  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc =
            await FirebaseFirestore.instance
                .collection('bewerber_profiles')
                .doc(user.uid)
                .get();
        if (doc.exists) {
          // Daten ins Formular eintragen
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
          _addressController.text = data['address'] ?? '';
          _positionController.text = data['currentPosition'] ?? '';
          _educationController.text = data['education'] ?? '';
          if (data['birthDate'] != null) {
            // Geburtsdatum (Timestamp) ins Textfeld formatieren
            Timestamp timestamp = data['birthDate'];
            _selectedBirthDate = timestamp.toDate();
            _birthDateController.text = _formatDate(_selectedBirthDate!);
          }
        }
      } catch (e) {
        // Fehler beim Laden -> SnackBar oder Log
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden des Profils: $e')),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Hilfsfunktion zur Datumformatierung (TT.MM.JJJJ)
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  // Öffnet den DatePicker und speichert die Auswahl
  Future<void> _pickBirthDate() async {
    DateTime initialDate = _selectedBirthDate ?? DateTime(1990, 1, 1);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedBirthDate = pickedDate;
        // Auswahl im Textfeld anzeigen
        _birthDateController.text = _formatDate(pickedDate);
      });
    }
  }

  // Speichert die aktuellen Formularwerte in Firestore
  Future<void> _saveProfile() async {
    // Validierung aller Formularfelder
    if (!_formKey.currentState!.validate()) {
      return; // abbrechen, falls ungültig
    }
    setState(() {
      _isSaving = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kein angemeldeter Benutzer.');
      // Daten aus den Controllern holen
      Map<String, dynamic> profileData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'address': _addressController.text.trim(),
        'currentPosition': _positionController.text.trim(),
        'education': _educationController.text.trim(),
      };
      if (_selectedBirthDate != null) {
        // DateTime wird von Firestore als Timestamp gespeichert
        profileData['birthDate'] = _selectedBirthDate;
      }
      // Firestore-Dokument erstellen/aktualisieren (Doc-ID = UID des Nutzers)
      await FirebaseFirestore.instance
          .collection('bewerber_profiles')
          .doc(user.uid)
          .set(profileData);
      // Erfolgsmeldung
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil erfolgreich gespeichert.')),
      );
    } catch (e) {
      // Fehlermeldung bei Ausnahme
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Speichern: $e')));
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    // Controller freigeben
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _positionController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bewerberprofil'),
        actions: [
          // Logout-Button (optional)
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Dank StreamBuilder in main.dart erfolgt Rückkehr zum Login automatisch
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(),
              ) // zeigt Ladespinner, bis _loadProfileData fertig
              : SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vorname
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(labelText: 'Vorname'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie Ihren Vornamen ein.';
                          }
                          return null;
                        },
                      ),
                      // Nachname
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(labelText: 'Nachname'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie Ihren Nachnamen ein.';
                          }
                          return null;
                        },
                      ),
                      // Geburtsdatum (mit DatePicker)
                      TextFormField(
                        controller: _birthDateController,
                        decoration: InputDecoration(labelText: 'Geburtsdatum'),
                        readOnly: true,
                        onTap: () => _pickBirthDate(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte wählen Sie Ihr Geburtsdatum aus.';
                          }
                          return null;
                        },
                      ),
                      // Adresse
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: 'Adresse'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie Ihre Adresse ein.';
                          }
                          return null;
                        },
                      ),
                      // Aktuelle Position
                      TextFormField(
                        controller: _positionController,
                        decoration: InputDecoration(
                          labelText: 'Aktuelle Position',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie Ihre aktuelle Position ein.';
                          }
                          return null;
                        },
                      ),
                      // Ausbildungen
                      TextFormField(
                        controller: _educationController,
                        decoration: InputDecoration(labelText: 'Ausbildungen'),
                        // Mehrzeiliges Textfeld für ggf. mehrere Abschlüsse:
                        minLines: 1,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie Ihre Ausbildung(en) ein.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Speichern-Button mit Ladeindikator bei Bedarf
                      SizedBox(
                        width: double.infinity, // Button füllt die Breite
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          child:
                              _isSaving
                                  ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text('Speichern'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
