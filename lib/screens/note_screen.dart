import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_gps/models/note.dart';
import 'package:note_gps/services/location_service.dart';
import 'package:note_gps/services/note_service.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime _noteDate = DateTime.now();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late NoteService _noteService;
  late LocationService _locationService;
  Position? _currentPosition;
  bool _isLoading = false;
  String? _imageUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _noteService = Provider.of<NoteService>(context, listen: false);
    _locationService = LocationService();

    if (widget.note != null) {
      _loadNote();
    } else {
      _fetchCurrentLocation();
    }
  }

  void _loadNote() {
    setState(() {
      _titleController.text = widget.note!.title;
      _bodyController.text = widget.note!.body;
      _noteDate = widget.note!.date;
      _imageUrl = widget.note!.imageUrl;
    });
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not fetch location: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      if (_currentPosition == null) {
        _fetchCurrentLocation();
        if (_currentPosition == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not fetch location')),
          );
          return;
        }
      }

      GeoPoint geoPoint =
          GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude);

      String? imageUrl;
      if (_image != null) {
        if (_imageUrl != null) {
          await _noteService
              .deleteImage(_imageUrl!); // Delete the old image if exists
        }
        imageUrl = await _noteService.uploadImage(_image!);
      }

      Note note = Note(
        id: widget.note?.id ?? _noteService.generateNoteId(),
        title: _titleController.text,
        body: _bodyController.text,
        date: widget.note?.date ?? DateTime.now(),
        location: geoPoint,
        imageUrl: imageUrl ??
            _imageUrl, // Use the existing image URL if no new image is uploaded
        userId: user.uid,
      );

      if (widget.note == null) {
        await _noteService.addNote(note, user.uid);
      } else {
        await _noteService.updateNote(note, user.uid);
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving note: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteNote() async {
    try {
      if (widget.note != null) {
        if (_imageUrl != null) {
          await _noteService
              .deleteImage(_imageUrl!); // Delete the image if exists
        }
        await _noteService.deleteNote(widget.note!.id, _auth.currentUser!.uid);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting note: $e')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageUrl =
            null; // Clear the existing image URL when a new image is selected
      }
    });
  }

  Future<void> _captureImageWithCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageUrl =
            null; // Clear the existing image URL when a new image is selected
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteNote,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Date: ${_noteDate.toLocal()}'),
              const SizedBox(height: 20),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (_imageUrl != null && _image == null)
                Image.network(
                  _imageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              if (_image != null)
                Image.file(
                  _image!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _pickImageFromGallery,
                    child: const Text('Select from Gallery'),
                  ),
                  ElevatedButton(
                    onPressed: _captureImageWithCamera,
                    child: const Text('Capture Image'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
