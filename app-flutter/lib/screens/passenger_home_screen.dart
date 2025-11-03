import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/ride_model.dart';
import '../providers/auth_provider.dart';
import '../providers/rides_provider.dart';
import '../widgets/app_drawer.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRides();
    });
  }


  Future<void> _fetchRides() async {

    if (!mounted) return;
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {

      await Provider.of<RidesProvider>(context, listen: false).fetchAvailableRides(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Viaje'),
      ),
      drawer: const AppDrawer(),

      body: RefreshIndicator(
        onRefresh: _fetchRides,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '¿A dónde vamos?',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Viajes Disponibles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: Consumer<RidesProvider>(
                builder: (ctx, ridesProvider, _) {
                  if (ridesProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (ridesProvider.availableRides.isEmpty) {
                    return const Center(child: Text('No hay viajes disponibles en este momento.'));
                  }
                  return ListView.builder(
                    itemCount: ridesProvider.availableRides.length,
                    itemBuilder: (ctx, i) {
                      final ride = ridesProvider.availableRides[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: const CircleAvatar(
                            child: Icon(Icons.directions_car_filled),
                          ),
                          title: Text('${ride.originName} → ${ride.destinationName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Conductor: ${ride.driverName}\n'
                            'Salida: ${DateFormat('dd MMM, hh:mm a', 'es_CO').format(ride.departureTime.toLocal())}\n'
                            'Cupos: ${ride.availableSeats}',
                          ),
                          trailing: Text(
                            '\$${ride.costPerSeat.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                          ),
                          onTap: () {

                            _showBookingConfirmation(context, ride);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showBookingConfirmation(BuildContext context, Ride ride) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Reserva'),
        content: Text('¿Deseas reservar un cupo en el viaje de ${ride.driverName} a ${ride.destinationName}?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Confirmar'),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final ridesProvider = Provider.of<RidesProvider>(context, listen: false);
              try {
                await ridesProvider.bookRide(ride.id, authProvider.token!);
                Navigator.of(ctx).pop(); 
                
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Reserva exitosa!'), backgroundColor: Colors.green),
                );
              } catch (e) {
                Navigator.of(ctx).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

