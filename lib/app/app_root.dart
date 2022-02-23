import 'package:flutter/material.dart';
import 'package:unsplash_client_the_sequel/app/home/home_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          color: Colors.white,
          child: const ScreenHome(),
        ),
      ),
    );
  }
}
