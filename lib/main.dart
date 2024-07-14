import 'package:doctor/controller/baseprovider.dart';
import 'package:doctor/controller/bottombar_controller.dart';
import 'package:doctor/controller/doctor_provider.dart';
import 'package:doctor/firebase_options.dart';
import 'package:doctor/views/screens/home.dart';
import 'package:doctor/views/widget/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DoctorController(),
        ),
        ChangeNotifierProvider(create: (context) => BaseProvider()),
        ChangeNotifierProvider(create: (context) => WidgetController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BottomBar(),
      ),
    );
  }
}
