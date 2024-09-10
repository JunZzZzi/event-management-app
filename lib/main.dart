import 'package:flutter/material.dart';
import 'views/events/event_list_page.dart';
import 'services/event_type_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  try {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD0aEqqn424LrcHwJwFlf9aLpfm6XA4drw",
      authDomain: "event-management-app-11e44.firebaseapp.com",
      projectId: "event-management-app-11e44",
      storageBucket: "event-management-app-11e44.appspot.com",
      messagingSenderId: "195143555993",
      appId: "1:195143555993:web:fbec92facb4c2684dbd108",
      measurementId: "G-PPKN5Z2K7X"
    ),
    );
    await EventTypeManager.init();

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    runApp(const MyApp());
  } catch (e) {
    print('Failed to initialize Firebase or EventTypeManager: $e');

  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Event Management APP'),
        '/eventList': (context) => EventListPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to Your Event Management App!'),
            SizedBox(height:20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/eventList');
              },
              child: Text('View Events')
            ),
          ],
        ),
      ),
    );
  }
}

