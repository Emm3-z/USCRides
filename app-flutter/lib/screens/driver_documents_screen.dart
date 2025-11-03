import 'package:flutter/material.dart';


class DriverDocumentsScreen extends StatelessWidget {

  final String? vehicleType;
  const DriverDocumentsScreen({this.vehicleType, super.key});

  @override
  Widget build(BuildContext context) {

    final isSetupFlow = vehicleType != null;

    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), 
      appBar: AppBar(
        title: const Text('USC Rides'),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Personal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2, 
                crossAxisSpacing: 20, 
                mainAxisSpacing: 20, 
                children: const [
                  _DocumentBox(label: 'Licencia de conducción', icon: Icons.card_membership),
                  _DocumentBox(label: 'Carnet de la universidad', icon: Icons.school),
                  _DocumentBox(label: 'SOAT', icon: Icons.shield_outlined),
                  _DocumentBox(label: 'Tecnomecánica', icon: Icons.qr_code_scanner_outlined),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isSetupFlow ? 'Completando configuración...' : 'Guardando cambios...')),
                  );


                  if (isSetupFlow) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },

                child: Text(isSetupFlow ? 'Siguiente' : 'Guardar Cambios', style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _DocumentBox extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DocumentBox({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26), 
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white54, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

