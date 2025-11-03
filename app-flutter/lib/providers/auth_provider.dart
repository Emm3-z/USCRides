import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usc_rides_flutter/screens/auth_screen.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userName;
  String? _userType;
  bool? _isDriverSetupComplete; 

  final String _backendBaseUrl = 'http://10.0.2.2:5000/api'; 

  
  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userType => _userType;
  bool? get isDriverSetupComplete => _isDriverSetupComplete;

 
  Future<void> _processAuthResponse(Map<String, dynamic> responseData) {
    _token = responseData['token'];
    _userId = responseData['_id'];
    _userName = responseData['name'];
    _userType = responseData['userType'];
    _isDriverSetupComplete = responseData['driverSetupComplete'] ?? false;
    
    notifyListeners(); 
    return _saveTokenData();
  }


  Future<Map<String, dynamic>> register(
      String name, String email, String password, UserType userType) async {
    final url = Uri.parse('$_backendBaseUrl/auth/register');
    final userTypeValue = userType.toString().split('.').last;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'userType': userTypeValue,
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw Exception(responseData['message']);
      }
      return responseData;
    } catch (error) {
      rethrow;
    }
  }


  Future<void> verifyCode(String email, String code) async {
    final url = Uri.parse('$_backendBaseUrl/auth/verify');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'verificationCode': code}),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw Exception(responseData['message']);
      }
      await _processAuthResponse(responseData);
    } catch (error) {
      rethrow;
    }
  }


  Future<void> login(String email, String password) async {
    final url = Uri.parse('$_backendBaseUrl/auth/login');
    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode({'email': email, 'password': password}));
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) throw Exception(responseData['message']);
      await _processAuthResponse(responseData);
    } catch (error) {
      rethrow;
    }
  }


  Future<void> _saveTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'userName': _userName,
      'userType': _userType,
      'isDriverSetupComplete': _isDriverSetupComplete,
    });
    await prefs.setString('userData', userData);
  }


  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _userName = extractedUserData['userName'];
    _userType = extractedUserData['userType'];
    _isDriverSetupComplete = extractedUserData['isDriverSetupComplete'];
    
    if (_token == null) return false;
    
    notifyListeners();
    return true;
  }
  

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _userName = null;
    _userType = null;
    _isDriverSetupComplete = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    notifyListeners();
  }
}


