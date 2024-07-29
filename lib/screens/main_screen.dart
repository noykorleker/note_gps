import 'package:flutter/material.dart';
import 'package:note_gps/screens/login_screen.dart';
import 'package:note_gps/screens/note_list_view.dart';
import 'package:note_gps/screens/note_map_view.dart';
import 'package:note_gps/screens/note_screen.dart';
import 'package:note_gps/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_gps/services/note_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final noteService = Provider.of<NoteService>(context);

    if (user == null) {
      // Handle the case when the user is not logged in
      return Scaffold(
        body: Center(
          child: Text('User is not logged in'),
        ),
      );
    }

    final List<Widget> _widgetOptions = <Widget>[
      NoteListView(noteService: noteService, user: user),
      NoteMapView(noteService: noteService, user: user),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthenticationService(FirebaseAuth.instance).signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome, ${user.email ?? 'User'}!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
            ],
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteScreen()),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
