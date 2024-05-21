import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/front/add_wiki_page.dart';
import 'package:meme_app/front/home_page.dart';
import 'package:meme_app/front/wiki_meme_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBcQYS6N4JbX2ezFmzE4ncrTMvLf2O94PU",
        authDomain: "meme-app-9e01f.firebaseapp.com",
        projectId: "meme-app-9e01f",
        storageBucket: "meme-app-9e01f.appspot.com",
        messagingSenderId: "1050751346756",
        appId: "1:1050751346756:web:1e47daba969d9763aef411",
        measurementId: "G-NK5JLQ4LLX"
      )
    );
  }
  else{
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDnI0-uBUTC_1UDZsmkKCauZDosFJDaaos",
        appId: "1:1050751346756:android:1bf99759be5177d3aef411", 
        messagingSenderId: "1050751346756", 
        projectId: "meme-app-9e01f"
      )
    );
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 1;
  List<Widget> body = const [
    HomePage(),
    WikiMemePage(),
    AddWikiPage()
  ];
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'TrajanPro'
      ),
      home: Scaffold(
        body: Center(
          child: body[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: 'List Meme',
              icon: Icon(Icons.line_style_rounded)
            ),
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home)
            ),
            BottomNavigationBarItem(
              label: 'Add Wiki',
              icon: Icon(Icons.add_to_photos_rounded)
            )
          ],
          selectedItemColor: Colors.white, 
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.grey[900]
        ),
      ),
    );
  }
}
