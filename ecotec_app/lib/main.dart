import 'package:ecotec_app/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     // home: HomeScreen(), deseactivo esta propiedad debido a que uso ahora rutas
      initialRoute: AppRoutes.inicio,
      routes: AppRoutes.rutas,
   // routes: ,
    );
  }
}

