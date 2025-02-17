import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_list_app/widgets/textfield.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';

class EditVehiclePopup extends StatefulWidget {
  final Vehicle vehicle;
  final VehicleProvider vehicleProvider;

  const EditVehiclePopup(
      {super.key, required this.vehicle, required this.vehicleProvider});

  @override
  EditVehiclePopupState createState() => EditVehiclePopupState();
}

class EditVehiclePopupState extends State<EditVehiclePopup> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late int mileage;
  late int year;

  @override
  void initState() {
    super.initState();
    name = widget.vehicle.name;
    mileage = widget.vehicle.mileage;
    year = widget.vehicle.year;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      color: Colors.white,
      child: AlertDialog(
        title: Text('Edit Vehicle',
        textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
            )),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Vehicle Name',
                initialValue: name,
                onSaved: (value) => name = value!,
              ),
              CustomTextField(
                label: 'Mileage (km/l)',
                initialValue: mileage.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter mileage';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => mileage = int.parse(value!),
              ),
              CustomTextField(
                label: 'Year of Manufacture',
                initialValue: year.toString(),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter year' : null,
                onSaved: (value) => year = int.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: _saveChanges,
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedVehicle = Vehicle(
        id: widget.vehicle.id,
        name: name,
        mileage: mileage,
        year: year,
      );
      widget.vehicleProvider.updateVehicle(updatedVehicle);
      Navigator.pop(context); 
    }
  }
}
