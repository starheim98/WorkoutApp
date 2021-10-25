import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';

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
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'HOME',
      style: optionStyle,
    ),
    Text(
      'RECORD',
      style: optionStyle,
    ),
    Text(
      'MY PAGE',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('Fitness App'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0, //no dropshadow / flat on the screen
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
              print("User signed out.");
            },
            label: const Text("Logout"),
            icon: const Icon(Icons.person),
          ),

        ],

      ),
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
    );  }
}