import 'package:flutter/material.dart';
import './driver_documents_screen.dart'; 

class DriverSetupVehicleScreen extends StatelessWidget {
  const DriverSetupVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Elige tu vehículo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            _buildVehicleOption(
              context: context,
              title: 'Auto',
              iconData: Icons.directions_car,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const DriverDocumentsScreen(vehicleType: 'auto'), 
                ));
              },
            ),
            const SizedBox(height: 20),
            _buildVehicleOption(
              context: context,
              title: 'Motocicleta',
              iconData: Icons.two_wheeler,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const DriverDocumentsScreen(vehicleType: 'motocicleta'), 
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleOption({
    required BuildContext context,
    required String title,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        leading: Icon(iconData, size: 40, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: onTap,
      ),
    );
  }
}

