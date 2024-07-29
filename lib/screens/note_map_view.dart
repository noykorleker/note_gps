import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:note_gps/models/note.dart';
import 'package:note_gps/screens/note_screen.dart';
import 'package:note_gps/services/note_service.dart';

class NoteMapView extends StatefulWidget {
  final NoteService noteService;
  final User user;
  const NoteMapView({super.key, required this.noteService, required this.user});

  @override
  _NoteMapViewState createState() => _NoteMapViewState();
}

class _NoteMapViewState extends State<NoteMapView> {
  GoogleMapController? _mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  void _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ));
      }
    } catch (e) {
      print('Could not fetch location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: widget.noteService.getNotes(widget.user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No notes yet.'));
        }
        final notes = snapshot.data!;
        Set<Marker> markers = notes.map((note) {
          return Marker(
            markerId: MarkerId(note.id),
            position: LatLng(note.location.latitude, note.location.longitude),
            infoWindow: InfoWindow(
              title: note.title,
              snippet: note.body,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteScreen(note: note)),
                );
              },
            ),
          );
        }).toSet();

        return GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            if (_currentPosition != null) {
              _mapController!.animateCamera(CameraUpdate.newLatLng(
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              ));
            }
          },
          initialCameraPosition: _currentPosition != null
              ? CameraPosition(
                  target: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  zoom: 12,
                )
              : const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 2,
                ),
          markers: markers,
        );
      },
    );
  }
}
