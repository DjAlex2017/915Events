import 'package:el_paso_events/createTab/createScreen.dart';
import 'package:el_paso_events/eventsTab/events_Screen.dart';
import 'package:el_paso_events/exploreTab/exploreScreen.dart';
import 'package:el_paso_events/homeTab/homeTemp.dart';
import 'package:el_paso_events/profileTab/profileTemp.dart';
import 'package:flutter/material.dart';

class DiscoverElPasoScreen extends StatefulWidget {
  @override
  _DiscoverElPasoScreenState createState() => _DiscoverElPasoScreenState();
}

class _DiscoverElPasoScreenState extends State<DiscoverElPasoScreen> {
  final Color mainColor = Color(0xFFF5E9DC);
  final Color accentColor = Color(0xFF8B4C39);

  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeTab(),
      createTab(onTabChange: _onItemTapped),
      EventsTab(),
      ExploreTab(),
      ProfileTab(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '915 EVENTS',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              'DISCOVER EL PASO',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: accentColor,
              child: Icon(Icons.star, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Create',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
