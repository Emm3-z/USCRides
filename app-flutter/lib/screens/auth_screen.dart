import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usc_rides_flutter/screens/verify_screen.dart';
import '../providers/auth_provider.dart';

enum UserType { pasajero, conductor }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserType _selectedUserType = UserType.pasajero;
  List<bool> _isSelected = [true, false];

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocurrió un error'),
        content: Text(message.replaceAll('Exception: ', '')),
        actions: <Widget>[
          TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop())
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(_emailController.text, _passwordController.text);
      } else {
        final response =
            await Provider.of<AuthProvider>(context, listen: false).register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _selectedUserType,
        );
        

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => VerifyScreen(email: response['email']),
          ),
        );
      }
    } catch (error) {

      if (!mounted) return;
      _showErrorDialog(error.toString());
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _switchAuthMode() => setState(() => _isLogin = !_isLogin);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1A237E),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('USC Rides',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 30),
                    if (!_isLogin)
                      Column(
                        children: [
                          const Text('Quiero registrarme como:',
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 10),
                          ToggleButtons(
                            isSelected: _isSelected,
                            onPressed: (index) {
                              setState(() {
                                _isSelected = [index == 0, index == 1];
                                _selectedUserType = index == 0
                                    ? UserType.pasajero
                                    : UserType.conductor;
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: const Color(0xFF1A237E),
                            color: Colors.white,
                            fillColor: Colors.white,
                            borderColor: Colors.white,
                            selectedBorderColor: Colors.white,
                            children: const [
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('Pasajero')),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('Conductor')),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    if (!_isLogin)
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            labelText: 'Nombre Completo',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none)),
                        validator: (v) =>
                            v!.isEmpty ? 'Ingresa tu nombre' : null,
                      ),
                    if (!_isLogin) const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v!.isEmpty || !v.contains('@') ? 'Email inválido' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Contraseña',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none)),
                      obscureText: true,
                      validator: (v) => v!.isEmpty || v.length < 5
                          ? 'Contraseña muy corta'
                          : null,
                    ),
                    const SizedBox(height: 30),
                    if (_isLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(_isLogin ? 'INICIAR SESIÓN' : 'SIGUIENTE'),
                        ),
                      ),
                    TextButton(
                      onPressed: _switchAuthMode,
                      child: Text(
                          _isLogin
                              ? '¿No tienes cuenta? Regístrate'
                              : 'Ya tengo una cuenta',
                          style: const TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

