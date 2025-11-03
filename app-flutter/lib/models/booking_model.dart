import './ride_model.dart';

class Booking {
  final String id;
  final Ride ride; 
  final int seatsBooked;
  final String status;

  Booking({
    required this.id,
    required this.ride,
    required this.seatsBooked,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {

    return Booking(
      id: json['_id'],
      ride: Ride.fromJson(json['ride']),
      seatsBooked: json['seatsBooked'],
      status: json['status'],
    );
  }
}

