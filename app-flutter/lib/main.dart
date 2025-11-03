import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usc_rides_flutter/providers/auth_provider.dart';
import 'package:usc_rides_flutter/providers/rides_provider.dart'; 
import 'package:usc_rides_flutter/screens/auth_screen.dart';
import 'package:usc_rides_flutter/screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; 

// The main function is the starting point for all Flutter apps.
void main() {

  initializeDateFormatting('es_CO', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => RidesProvider()),
      ],
      child: MaterialApp(
        title: 'USC Rides',

        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.indigo, 
          scaffoldBackgroundColor: Colors.white,

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A237E), 
            primary: const Color(0xFF1A237E),
            secondary: Colors.white,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {

            if (auth.isAuthenticated) {
              return const HomeScreen();
            } else {
              return FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) {
                  if (authResultSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return const AuthScreen();
                  }
                },
              );
            }
          },
        ),
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          AuthScreen.routeName: (context) => const AuthScreen(),
        },
      ),
    );
  }
}

