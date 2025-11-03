import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';


import '../screens/profile_screen.dart'; 
import '../screens/driver_documents_screen.dart'; 
import '../screens/ride_history_screen.dart';
import '../screens/booked_rides_screen.dart';
import '../screens/notifications_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isDriver = authProvider.userType == 'conductor';

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hola, ${authProvider.userName ?? ''}'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.of(context).pop();

              if (isDriver) {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DriverDocumentsScreen()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
              }
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial de viajes'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const RideHistoryScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_online_outlined),
            title: const Text('Viajes reservados'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const BookedRidesScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notificaciones'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const NotificationsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}

