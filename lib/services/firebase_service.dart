import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';

class FirebaseService {
  final CollectionReference _vehicleCollection = FirebaseFirestore.instance.collection('vehicles');

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _vehicleCollection.add(vehicle.toMap());
    } catch (e) {
      throw Exception("Failed to add vehicle: $e");
    }
  }

  Stream<List<Vehicle>> getVehicles() {
    return _vehicleCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _vehicleCollection.doc(vehicleId).delete();
    } catch (e) {
      throw Exception('Failed to delete vehicle: $e');
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _vehicleCollection.doc(vehicle.id).update(vehicle.toMap());
    } catch (e) {
      throw Exception('Failed to update vehicle: $e');
    }
  }
}
