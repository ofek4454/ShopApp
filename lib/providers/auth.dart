import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expairedTime;
  Timer _logOutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expairedTime != null &&
        _expairedTime.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authindication(
      String email, String password, String reqType) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$reqType?key=AIzaSyBvDWL5jgpuWR7rh5n9cWvPf38O48neN2o';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expairedTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expairedTime.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      print('prefs put String');
      prefs.commit();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authindication(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authindication(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expairedTime = null;
    if (_logOutTimer != null) {
      _logOutTimer.cancel();
      _logOutTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.remove('userData');
  }

  void autoLogOut() {
    if (_logOutTimer != null) {
      _logOutTimer.cancel();
    }
    final timeToExpiry = _expairedTime.difference(DateTime.now()).inSeconds;
    _logOutTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  Future<bool> tryAutoLogIn() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(pref.getString('userData')) as Map<String, Object>;
    final expDate = DateTime.parse(userData['expiryDate']);
    if (expDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expairedTime = expDate;
    autoLogOut();
    notifyListeners();
    return true;
  }
}
