import 'package:flutter/material.dart';

class ObjectifPage extends StatefulWidget {
  const ObjectifPage({super.key});

  @override
  State<ObjectifPage> createState() => _ObjectifPageState();
}

class _ObjectifPageState extends State<ObjectifPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _objectifController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  double _montantAtteint = 300; // à relier plus tard avec les économies réelles

  int _selectedIndex = 2; // 2 = Objectif

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/rapport');
    } else if (index == 2) {
      // Déjà sur cette page
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/compte');
    }
  }

  void _enregistrerObjectif() {
    if (_formKey.currentState!.validate()) {
      setState(() {}); // Met à jour l'interface avec les données saisies
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Objectif enregistré avec succès !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double montantTotal = double.tryParse(_montantController.text) ?? 1;
    double pourcentage = (_montantAtteint / montantTotal).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Objectifs Financiers"),
        backgroundColor: const Color(0xFF3C8CE7),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Créer un nouvel objectif',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _objectifController,
                      decoration: const InputDecoration(labelText: 'Nom de l\'objectif'),
                      validator: (value) => value!.isEmpty ? 'Entrez un objectif' : null,
                    ),
                    TextFormField(
                      controller: _montantController,
                      decoration: const InputDecoration(labelText: 'Montant souhaité (DT)'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Entrez un montant' : null,
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(labelText: 'Date limite (ex: 2025-06-01)'),
                      validator: (value) =>
                          value!.isEmpty ? 'Entrez une date' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _enregistrerObjectif,
                      child: const Text('Enregistrer'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Progression de l\'objectif',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              if (_objectifController.text.isNotEmpty)
                Column(
                  children: [
                    Text(
                      _objectifController.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: pourcentage,
                      minHeight: 20,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_montantAtteint.toStringAsFixed(2)} / ${montantTotal.toStringAsFixed(2)} DT',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Plan : Épargner régulièrement pour atteindre l’objectif avant la date limite.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF3C8CE7),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Rapports'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Objectif'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Compte'),
        ],
      ),
    );
  }
}
