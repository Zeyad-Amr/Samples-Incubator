import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Directionality(
              textDirection: TextDirection.ltr, child: child!);
        },
        title: 'GNav',
        theme: ThemeData(
          primaryColor: Colors.grey[900],
        ),
        home: Example(),
      ),
    );

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Settings',
      style: optionStyle,
    ),
    Text(
      'Automatic',
      style: optionStyle,
    ),
    Text(
      'Manual',
      style: optionStyle,
    ),
    Text(
      'Developers',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 20,
        title: const Text('Sample Incubator'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              backgroundColor: Colors.grey[900]!,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[500]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              curve: Curves.easeInCubic,
              tabBackgroundGradient: LinearGradient(
                  colors: [Colors.deepPurple[900]!, Colors.blueAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.7, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 500),
              color: Colors.white,
              tabs: [
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
                GButton(
                  icon: Icons.thermostat_auto_rounded,
                  text: 'Automatic',
                ),
                GButton(
                  icon: Icons.thermostat,
                  text: 'Manual',
                ),
                GButton(
                  icon: Icons.developer_mode_rounded,
                  text: 'Developers',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
