import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_list_app/screens/edit_vehicle.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';

class VehicleCard extends StatefulWidget {
  final Vehicle vehicle;
  final VehicleProvider vehicleProvider;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.vehicleProvider,
  });

  @override
  VehicleCardState createState() => VehicleCardState();
}

class VehicleCardState extends State<VehicleCard> {
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenHint = prefs.getBool('hasSeenHint') ?? false;

    if (!hasSeenHint) {
      setState(() {
        _showHint = true;
      });
      await prefs.setBool('hasSeenHint', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DismissibleVehicleCard(
          vehicle: widget.vehicle,
          vehicleProvider: widget.vehicleProvider,
          showEditPopup: _showEditPopup,
        ),
        if (_showHint)
          HintOverlay(onDismiss: () => setState(() => _showHint = false)),
      ],
    );
  }

  void _showEditPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditVehiclePopup(
        vehicle: widget.vehicle,
        vehicleProvider: widget.vehicleProvider,
      ),
    );
  }
}

class DismissibleVehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VehicleProvider vehicleProvider;
  final void Function(BuildContext) showEditPopup;

  const DismissibleVehicleCard({
    super.key,
    required this.vehicle,
    required this.vehicleProvider,
    required this.showEditPopup,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(vehicle.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          showEditPopup(context);
          return false;
        } else {
          return _confirmDelete(context);
        }
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          try {
            await vehicleProvider.deleteVehicle(vehicle.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${vehicle.name} deleted')),
              );
            }
          } catch (error) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error deleting vehicle')),
              );
            }
          }
        }
      },
      background: _buildEditBackground(),
      secondaryBackground: _buildDeleteBackground(),
      child: VehicleCardContent(vehicle: vehicle),
    );
  }

  Widget _buildEditBackground() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Delete Vehicle",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Are you sure you want to delete ",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                    TextSpan(
                      text: "${vehicle.name}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const TextSpan(
                      text: "?",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ));
  }
}

class VehicleCardContent extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCardContent({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(Icons.directions_car, color: vehicle.color, size: 40.0),
        title: Text(
          vehicle.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          'Mileage: ${vehicle.mileage} km/l\nYear: ${vehicle.year}',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class HintOverlay extends StatelessWidget {
  final VoidCallback onDismiss;

  const HintOverlay({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: Colors.black26,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.swipe, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(
                  "Swipe right to edit\nSwipe left to delete",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lobster(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
