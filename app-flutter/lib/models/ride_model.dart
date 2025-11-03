class Passenger {
  final String id;
  final String name;

  Passenger({required this.id, required this.name});

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['_id'] ?? '', 
      name: json['name'] ?? 'Pasajero Desconocido', 
    );
  }
}

class Ride {
  final String id;
  final String originName;
  final String destinationName;
  final DateTime departureTime;
  final int availableSeats;
  final int totalSeats;
  final double costPerSeat;
  final String driverName;
  final List<Passenger> passengers; 

  Ride({
    required this.id,
    required this.originName,
    required this.destinationName,
    required this.departureTime,
    required this.availableSeats,
    required this.totalSeats,
    required this.costPerSeat,
    required this.driverName,
    required this.passengers,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    try {
      var passengersFromJson = json['passengers'] as List? ?? [];
      List<Passenger> passengerList = passengersFromJson.map((p) => Passenger.fromJson(p)).toList();

      
      String driverNameValue = 'Conductor Desconocido';
      if (json['driver'] != null) {
        
        if (json['driver'] is Map<String, dynamic>) {
          driverNameValue = json['driver']['name'] ?? driverNameValue;
        } 
      }

      return Ride(
        id: json['_id'] ?? '',
        originName: json['origin']?['name'] ?? 'Origen Desconocido',
        destinationName: json['destination']?['name'] ?? 'Destino Desconocido',

        departureTime: DateTime.tryParse(json['departureTime'] ?? '') ?? DateTime.now(),
        availableSeats: json['availableSeats'] ?? 0,
        totalSeats: json['totalSeats'] ?? 0,

        costPerSeat: (json['costPerSeat'] as num?)?.toDouble() ?? 0.0,
        driverName: driverNameValue, 
        passengers: passengerList,
      );
    } catch (e) {

      print('Error al parsear el JSON de Ride: $e');
      print('JSON problemático: $json');

      return Ride(
        id: 'error',
        originName: 'Error de Datos',
        destinationName: 'Por favor, actualice',
        departureTime: DateTime.now(),
        availableSeats: 0,
        totalSeats: 0,
        costPerSeat: 0,
        driverName: 'Error',
        passengers: [],
      );
    }
  }
}

