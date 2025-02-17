import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firebase_service.dart';

class VehicleProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  final bool _isLoading = false;

  bool get isLoading => _isLoading;

  void fetchVehicles() {
    _firebaseService.getVehicles().listen((vehicles) {
      _vehicles = vehicles;
      notifyListeners();
    });
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _firebaseService.addVehicle(vehicle);
      fetchVehicles(); 
    } catch (e) {
      print("Error adding vehicle: $e");
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _firebaseService.deleteVehicle(vehicleId);
      fetchVehicles();
    } catch (e) {
      print("Error deleting vehicle: $e");
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _firebaseService.updateVehicle(vehicle);
      fetchVehicles(); 
    } catch (e) {
      print("Error updating vehicle: $e");
    }
  }
}
