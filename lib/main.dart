import 'package:chati_fy/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//import 'package:chati_fy/pages/login_page.dart';
import './pages/registration_page.dart';
import './services/navigation_service.dart';
import './services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DBService.instance
        .createUserInDB('0213', 'james', 'James@gmail.com', 'Imageurl..///');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatiFy',
      navigatorKey: NavigationServices.instance.navigatorKey,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(42, 117, 188, 1),
        accentColor: Color.fromRGBO(42, 117, 188, 1),
        backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      ),
      initialRoute: 'login',
      routes: {
        'login': (BuildContext _context) => LoginPage(),
        'register': (BuildContext _context) => RegistrationPage(),
      },
    );
  }
}
