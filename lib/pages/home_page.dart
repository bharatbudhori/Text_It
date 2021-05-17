import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('ChatiFy'),
        textTheme: TextTheme(
          headline5: TextStyle(fontSize: 16),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
      ),
    );
  }
}
