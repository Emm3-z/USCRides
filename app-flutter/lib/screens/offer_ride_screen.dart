import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/rides_provider.dart';
import '../providers/auth_provider.dart';

class OfferRideScreen extends StatefulWidget {
  const OfferRideScreen({super.key});

  @override
  State<OfferRideScreen> createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  final _formKey = GlobalKey<FormState>();

  final _originController = TextEditingController(text: 'Universidad Santiago de Cali');
  final _destinationController = TextEditingController();
  final _seatsController = TextEditingController();
  final _costController = TextEditingController();


  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;


  Future<void> _selectDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)), 
    );

    if (date == null) return; 


    if (!mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return; 

    setState(() {
      _selectedDate = date;
      _selectedTime = time;
    });
  }


  Future<void> _submitOffer() async {

    final isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos, incluyendo fecha y hora.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);


    final departureDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token!;
      await Provider.of<RidesProvider>(context, listen: false).offerRide(
        token: token,
        originName: _originController.text,
        destinationName: _destinationController.text,
        departureTime: departureDateTime,
        totalSeats: int.parse(_seatsController.text),
        costPerSeat: double.parse(_costController.text),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Viaje ofrecido con éxito!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop(); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al ofrecer viaje: ${e.toString().replaceAll("Exception: ", "")}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {

    _originController.dispose();
    _destinationController.dispose();
    _seatsController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofrecer un Nuevo Viaje'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _originController,
                decoration: const InputDecoration(labelText: 'Origen', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Ingresa un origen' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destino', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Ingresa un destino' : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.grey.shade400)
                ),
                title: const Text('  Fecha y Hora de Salida'),
                subtitle: Text(
                  _selectedDate == null || _selectedTime == null
                      ? '  No seleccionada'
                      : '  ${DateFormat('EEEE, dd MMM, hh:mm a', 'es_CO').format(DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute))}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDateTime,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _seatsController,
                decoration: const InputDecoration(labelText: 'Cupos Disponibles', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Ingresa un número válido de cupos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Costo por Cupo (\$)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Ingresa un costo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _submitOffer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('PUBLICAR VIAJE'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

