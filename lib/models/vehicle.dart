import 'package:flutter/material.dart';

class Vehicle {
   String id;
  final String name;
  final int mileage;
  final int year;

  Vehicle({required this.id, required this.name, required this.mileage, required this.year});

  Color get color {
    int age = DateTime.now().year - year;
    if (mileage >= 15 && age <= 5) return Colors.green;
    if (mileage >= 15 && age > 5) return Colors.amber;
    return Colors.red;
  }

  factory Vehicle.fromMap(Map<String, dynamic> data, String id) {
    return Vehicle(
      id: id,
      name: data['name'],
      mileage: data['mileage'],
      year: data['year'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mileage': mileage,
      'year': year,
    };
  }
}
