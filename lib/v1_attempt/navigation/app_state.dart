import 'dart:async';
import 'package:flutter/material.dart';

enum Roles { user, employee }

class AppState extends ChangeNotifier {
  int _selectedTab = 0;
  bool _loggedIn = false;
  bool isInitialized = false;
  bool _isUnknown = false;
  Roles? _userType;
  String? _offerDetails;
  int? offerId;

  AppState() {
    initialize();
  }

  void initialize() {
    //  Fake initialization/bootstrapping procedure
    Timer(const Duration(seconds: 1), () {
      isInitialized = true;
      notifyListeners();
    });
  }

  int get selectedTab => _selectedTab;
  set selectedTab(int idx) {
    _selectedTab = idx;
    notifyListeners();
  }

  bool get isUnknown => _isUnknown;
  set isUnknown(bool value) {
    _isUnknown == value;
    notifyListeners();
  }

  bool get loggedIn => _loggedIn;
  set loggedIn(bool status) {
    _loggedIn = status;
    notifyListeners();
  }

  Roles? get userType => _userType;
  set userType(Roles? userType) {
    _userType = userType;
    notifyListeners();
  }

  String? get offerDetails => _offerDetails;
  set offerDetails(String? offerDetails) {
    _offerDetails = offerDetails;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    _selectedTab = 0;
    _userType = null;
    _offerDetails = null;

    initialize();
    notifyListeners();
  }

  void _login() {
    _loggedIn = true;
    notifyListeners();
  }

  void loginUser() {
    _userType = Roles.user;
    _login();
  }

  void loginEmployee() {
    _userType = Roles.employee;
    _login();
  }

  bool isLogin() => _loggedIn == true;
  bool isSplash() => isInitialized == false;
  bool isHome() => isLogin() && _selectedTab == 0;
  bool isOffersScreen() => isLogin() && _selectedTab == 1;
  bool isHistoryScreen() => isLogin() && _selectedTab == 2;
  bool isAccountScreen() => isLogin() && _selectedTab == 3;

  AppState.home()
      : _loggedIn = true,
        _selectedTab = 0 {
    initialize();
  }
  AppState.offers()
      : _loggedIn = true,
        _selectedTab = 1 {
    initialize();
  }
  AppState.history()
      : _loggedIn = true,
        _selectedTab = 2 {
    initialize();
  }
  AppState.account()
      : _loggedIn = true,
        _selectedTab = 3 {
    initialize();
  }
  AppState.login() : _loggedIn = false {
    initialize();
  }
}