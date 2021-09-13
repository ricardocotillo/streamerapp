import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamerapp/providers/home.provider.dart';
import 'package:streamerapp/views/home.view.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
  ));
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (BuildContext context) => SearchPreferencesProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streamer app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.ralewayTextTheme(
          Theme.of(context).textTheme.apply(
                displayColor: Colors.white,
                bodyColor: Colors.white,
              ),
        ),
      ),
      home: HomeView(),
    );
  }
}
