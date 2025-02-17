import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vehicle_list_app/firebase_options.dart';
import 'package:vehicle_list_app/utils/preload.dart';
import 'providers/vehicle_provider.dart';
import 'screens/vehicle_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    preloadFonts(context);
    return ChangeNotifierProvider(
      create: (context) => VehicleProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vehicle List',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const VehicleListScreen(),
      ),
    );
  }
}
