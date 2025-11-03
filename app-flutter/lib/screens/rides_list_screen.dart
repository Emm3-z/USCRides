import 'package:flutter/material.dart';

class RidesListScreen extends StatelessWidget {
  const RidesListScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¡Bienvenido a USC Rides!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text('Aquí se mostrará la lista de viajes disponibles.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
            },
            child: const Text('Actualizar Viajes'),
          ),
        ],
      ),
    );
  }
}
