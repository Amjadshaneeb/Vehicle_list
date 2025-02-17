import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_list_app/widgets/textfield.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  AddVehicleScreenState createState() => AddVehicleScreenState();
}

class AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int mileage = 0;
  int year = 0;

  @override
  Widget build(BuildContext context) {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Vehicle',
          style:
              GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      label: 'Vehicle Name',
                      onSaved: (value) => name = value!,
                    ),
                    CustomTextField(
                      label: 'Mileage (km/l)',
                      keyboardType: TextInputType.number,
                      onSaved: (value) => mileage = int.parse(value!),
                    ),
                    CustomTextField(
                      label: 'Year of Manufacture',
                      keyboardType: TextInputType.number,
                      onSaved: (value) => year = int.parse(value!),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Add Vehicle',
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Vehicle newVehicle = Vehicle(
                              id: '',
                              name: name,
                              mileage: mileage,
                              year: year,
                            );
                            vehicleProvider.addVehicle(newVehicle);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
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
