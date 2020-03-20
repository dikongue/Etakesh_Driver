import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _IsFirstLaunch = "isFirstLaunch";
  final String _IsLoggedIn = "isLoggedIn";
  final String _KnotificationsPrefs = "allowNotifications";
  final String _IsOrderCreated = "isOrderCreated";
  final String _isTimed = "isTimed";
  final String _isOneNotif = "isOneNo";

  /// ------------------------------------------------------------
  /// Method that determine if the app is launched for the first time
  /// ------------------------------------------------------------
  Future<bool> isAppFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsFirstLaunch) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setAppFirstLaunch(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsFirstLaunch, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine is the app if an already an account logged
  /// ------------------------------------------------------------
  Future<bool> isAppLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsLoggedIn) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the app logged In status
  /// ----------------------------------------------------------
  Future<bool> setAppLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsLoggedIn, value);
  }

// Method that save the user decision to allow notifications

  Future<bool> setAllowsNotifications(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_KnotificationsPrefs, value);
  }

// Method that returns the user decision to allow notification

Future<bool> getAllowsNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_KnotificationsPrefs) ?? true;
  }

   /// ----------------------------------------------------------
  /// Method that saves the accepted order of costumer
  /// ----------------------------------------------------------
  Future<bool> setOrderCreate(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_IsOrderCreated, value);
  }

  /// ------------------------------------------------------------
  /// Method that determine if user created an order
  /// ------------------------------------------------------------
  Future<bool> isOrderCreated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_IsOrderCreated) ?? false;
  }

  
  Future<bool> setTime(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_isTimed, value);
  }

  
  Future<bool> isTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isTimed) ?? false;
  }

   Future<bool> isOneNotificatio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isOneNotif) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the the first connection to app status
  /// ----------------------------------------------------------
  Future<bool> setOneNotification(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_isOneNotif, value);
  }


}