import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_gps/models/note.dart';
import 'package:note_gps/screens/note_screen.dart';
import 'package:note_gps/services/note_service.dart';

class NoteListView extends StatelessWidget {
  final NoteService noteService;
  final User user;

  NoteListView({required this.noteService, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: noteService.getNotes(user.uid),
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
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.date.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteScreen(note: note)),
                );
              },
            );
          },
        );
      },
    );
  }
}
