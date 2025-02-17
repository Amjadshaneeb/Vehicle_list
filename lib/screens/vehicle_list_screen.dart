import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_list_app/widgets/animation.dart';
import '../providers/vehicle_provider.dart';
import '../widgets/vehicle_card.dart';
import 'add_vehicle_screen.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    vehicleProvider.fetchVehicles();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicles',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: Consumer<VehicleProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.vehicles.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    "No vehicles added yet.",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap the '+' button to add a new vehicle.",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: provider.vehicles.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(provider.vehicles[index].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      try {
                        await vehicleProvider
                            .deleteVehicle(provider.vehicles[index].id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vehicle deleted')),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error deleting vehicle')),
                        );
                      }
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    child: VehicleCard(
                      vehicle: provider.vehicles[index],
                      vehicleProvider: vehicleProvider,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            navigateWithAnimation(context, const AddVehicleScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
