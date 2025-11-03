import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/ride_model.dart';
import '../models/booking_model.dart';

class RidesProvider with ChangeNotifier {

  final String _backendBaseUrl = 'http://10.0.2.2:5000/api'; // Para Emulador Android

  List<Ride> _availableRides = [];
  List<Ride> _myOfferedRides = [];
  List<Booking> _myBookings = [];
  bool _isLoading = false;


  List<Ride> get availableRides => _availableRides;
  List<Ride> get myOfferedRides => _myOfferedRides;
  List<Booking> get myBookings => _myBookings;
  bool get isLoading => _isLoading;


  Future<void> offerRide({
    required String token,
    required String originName,
    required String destinationName,
    required DateTime departureTime,
    required int totalSeats,
    required double costPerSeat,
  }) async {
    final url = Uri.parse('$_backendBaseUrl/rides');
    try {

      final origin = {'name': originName, 'latitude': 3.3422, 'longitude': -76.5302};
      final destination = {'name': destinationName, 'latitude': 3.4516, 'longitude': -76.5320};

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'origin': origin,
          'destination': destination,
          'departureTime': departureTime.toIso8601String(),
          'totalSeats': totalSeats,
          'costPerSeat': costPerSeat,
        }),
      );

      if (response.statusCode != 201) {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Error al publicar el viaje');
      }

    } catch (error) {
      rethrow;
    }
  }


  Future<void> fetchMyOfferedRides(String token) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_backendBaseUrl/rides/my-rides');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        _myOfferedRides = responseData.map((data) => Ride.fromJson(data)).toList();
      } else {
        _myOfferedRides = [];
      }
    } catch (error) {
      print('Error en fetchMyOfferedRides: $error'); 
      _myOfferedRides = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 
  Future<void> fetchAvailableRides(String token) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_backendBaseUrl/rides');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        _availableRides = responseData.map((data) => Ride.fromJson(data)).toList();
      } else {
        _availableRides = [];
      }
    } catch (error) {
      print('Error en fetchAvailableRides: $error'); 
      _availableRides = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> bookRide(String rideId, String token) async {
    final url = Uri.parse('$_backendBaseUrl/rides/$rideId/book');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {

        await fetchAvailableRides(token);

        await fetchMyBookings(token);
      } else {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Error al reservar');
      }
    } catch (error) {
      rethrow;
    }
  }
  

  Future<void> fetchMyBookings(String token) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_backendBaseUrl/bookings/my-bookings');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        _myBookings = responseData.map((data) => Booking.fromJson(data)).toList();
      } else {
        _myBookings = [];
      }
    } catch (error) {
      print('Error en fetchMyBookings: $error'); 
      _myBookings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

