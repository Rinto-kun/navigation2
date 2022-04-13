import 'dart:async';
import 'package:flutter/material.dart';

enum Roles { user, employee }

class AppState extends ChangeNotifier {
  int _selectedTab;
  bool _loggedIn;
  bool isInitialized = false;
  Roles? _userType;
  String? _offerDetails;
  int? offerId;

  // Maybe add the offers db query here?
  // void _init(){}

  AppState()
      : _selectedTab = 4,
        _loggedIn = false {
    initialize();
  }

  int get selectedTab => _selectedTab;
  set selectedTab(int idx) {
    _selectedTab = idx;
    notifyListeners();
  }

  bool get loginStatus => _loggedIn;
  set loginStatus(bool status) {
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

  void initialize() {
    Timer(const Duration(seconds: 5), () {
      isInitialized = true;
    });
    notifyListeners();
  }

  // int? getSelectedBookById() {
  //   if (_selectedBook == null || !books.contains(_selectedBook)) return null;
  //   return books.indexOf(_selectedBook!);
  // }

  // void setSelectedBookById(int id) {
  //   if (id < 0 || id > books.length - 1) {
  //     return;
  //   }
  //   _selectedBook = books[id];
  //   notifyListeners();
  // }
}
