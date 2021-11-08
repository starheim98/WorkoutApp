import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  @override
  Widget build(BuildContext context) {
    //NB: fjernet const under her for det skapte trøbbel med 'column'. La også til const bak "TEXT".
     final List<Widget> _widgetOptions = <Widget>[
      const Text(
        'HOME',
        style: optionStyle,
      ),
      column(context),
      const Text(
        'MY PAGE',
        style: optionStyle,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: appbar(_auth),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_manual_record_rounded),
            label: 'New Workout/Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
