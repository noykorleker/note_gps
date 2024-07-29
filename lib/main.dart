import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_gps/firebase_options.dart';
import 'package:note_gps/screens/login_screen.dart';
import 'package:note_gps/screens/main_screen.dart';
import 'package:note_gps/services/authentication_service.dart';
import 'package:note_gps/services/note_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NoteService>(create: (_) => NoteService()),
        Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider<User?>(
          create: (context) =>
              Provider.of<AuthenticationService>(context, listen: false)
                  .authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner:
            false, // Add this line to remove the debug banner
        home: Consumer<User?>(
          builder: (context, user, _) {
            if (user == null) {
              return LoginScreen();
            }
            return MainScreen();
          },
        ),
      ),
    );
  }
}
