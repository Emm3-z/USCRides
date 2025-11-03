import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';


import './passenger_home_screen.dart';
import './driver_home_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final userType = authProvider.userType;

    if (userType == 'conductor') {

      return const DriverHomeScreen();
    } else {

      return const PassengerHomeScreen();
    }
  }
}

