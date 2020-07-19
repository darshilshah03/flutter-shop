import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;
  var authTimer;
  bool get isAuthenticated
  {
    return token != null;
  }

  String get userId{
    return _userId;
  }

  String get token
  {
    if(_token!=null && _expiryDate!=null && _expiryDate.isAfter(DateTime.now()))
    {
      return _token;
    }
    return null;
  }

  Future<void> signUp (String email,String password) async {
    try {
      final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBtjWTY3JBxAm8amAZbJjyHc-cDe_23Oeo';

      final res = await http.post(url,body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true  
      }));
      final responseData = json.decode(res.body);
      if(responseData['error'] != null)
      {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryDate.toIso8601String()
      });
      prefs.setString('userData',userData); 
    }
    catch(error) {
      throw error;
    }
  }

  Future<void> login (String email,String password) async {
   try{
      final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBtjWTY3JBxAm8amAZbJjyHc-cDe_23Oeo';

      final res = await http.post(url,body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true  
      }));
      final responseData = json.decode(res.body);
      if(responseData['error'] != null)
      {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryDate.toIso8601String()
      });
      prefs.setString('userData',userData); 
    }
    catch(error) {
      throw error;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedData = json.decode(prefs.getString('userData')) as Map<String ,Object>;
    final expiry = DateTime.parse(extractedData['expiryDate']);
    if(expiry.isBefore(DateTime.now()))
      return false;
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiry;
    notifyListeners();
    autoLogout();
    return true;
  }

  void logout() async
  {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if(authTimer!=null)
      authTimer.cancel();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if(authTimer != null)
      authTimer.cancel();
    final time = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: time),logout);
  }
}