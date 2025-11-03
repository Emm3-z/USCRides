import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/rides_provider.dart';
import '../providers/auth_provider.dart';

class BookedRidesScreen extends StatefulWidget {
  const BookedRidesScreen({super.key});

  @override
  State<BookedRidesScreen> createState() => _BookedRidesScreenState();
}

class _BookedRidesScreenState extends State<BookedRidesScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMyBookings();
    });
  }


  Future<void> _fetchMyBookings() async {

    if (!mounted) return;
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {

      await Provider.of<RidesProvider>(context, listen: false).fetchMyBookings(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Viajes Reservados'),
      ),

      body: Consumer<RidesProvider>(
        builder: (ctx, ridesProvider, _) {

          if (ridesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ridesProvider.myBookings.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Aún no has reservado ningún viaje.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ridesProvider.myBookings.length,
            itemBuilder: (ctx, i) {
              final booking = ridesProvider.myBookings[i];
              final ride = booking.ride;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Próximo Viaje a ${ride.destinationName}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 20),

                      _buildDetailRow(Icons.pin_drop_outlined, 'Desde: ${ride.originName}'),
                      _buildDetailRow(Icons.calendar_today_outlined, 'Fecha: ${DateFormat('EEEE, dd MMMM', 'es_CO').format(ride.departureTime.toLocal())}'),
                      _buildDetailRow(Icons.access_time_outlined, 'Hora: ${DateFormat('hh:mm a', 'es_CO').format(ride.departureTime.toLocal())}'),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(Icons.person_pin_circle_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text('Conductor: ${ride.driverName}'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                           TextButton(
                            onPressed: () {}, 
                            child: const Text('Cancelar Cupo', style: TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {}, 
                            child: const Text('Ver Detalles'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }


  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

