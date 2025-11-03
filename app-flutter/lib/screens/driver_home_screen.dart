import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/ride_model.dart';
import '../providers/auth_provider.dart';
import '../providers/rides_provider.dart';
import '../widgets/app_drawer.dart';
import './offer_ride_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMyRides();
    });
  }


  Future<void> _fetchMyRides() async {

    if (!mounted) return;
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {

      await Provider.of<RidesProvider>(context, listen: false).fetchMyOfferedRides(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Viajes Ofrecidos'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _fetchMyRides,
        child: Consumer<RidesProvider>(
          builder: (ctx, ridesProvider, _) {

            if (ridesProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (ridesProvider.myOfferedRides.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.car_crash_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        'Aún no has ofrecido ningún viaje',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Toca el botón "+" para publicar tu primera ruta y empezar a compartir tus viajes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ridesProvider.myOfferedRides.length,
              itemBuilder: (ctx, i) {
                final ride = ridesProvider.myOfferedRides[i];
                return _buildRideCard(context, ride);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {

          await Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const OfferRideScreen()),
          );

          _fetchMyRides();
        },
        label: const Text('Ofrecer Viaje'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildRideCard(BuildContext context, Ride ride) {
    final reservedSeats = ride.passengers.length;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Viaje programado', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ride.destinationName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text('$reservedSeats / ${ride.totalSeats} cupos reservados', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd/MM/yyyy').format(ride.departureTime.toLocal())),
                Text(DateFormat('hh:mm a', 'es_CO').format(ride.departureTime.toLocal()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pasajeros confirmados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (ride.passengers.isNotEmpty)
                  TextButton(onPressed: () {}, child: const Text('Ver todos')),
              ],
            ),
            if (ride.passengers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Aún no hay pasajeros.', style: TextStyle(color: Colors.grey)),
              )
            else
              ...ride.passengers.take(3).map((passenger) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white)),
                    title: Text(passenger.name),
                    subtitle: const Text('Estudiante'), 
                    trailing: Text('\$${ride.costPerSeat.toStringAsFixed(0)}'),
                  )).toList(),
            
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('INICIAR VIAJE'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

