import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(GameLauncherApp());
}

class GameLauncherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(bodyColor: Colors.greenAccent),
      ),
      home: GameLauncherHome(),
    );
  }
}

class GameLauncherHome extends StatelessWidget {
  final List<String> games = [
    'Space Blaster 3000',
    'Cyber Kart 1989',
    'Dungeon DOS X2',
    'Neo Ninja Hunter',
    'Pixel Invaders 64',
    'Toxic Tetris 2',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 600,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border.all(color: Colors.greenAccent, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('RETRO GAME LAUNCHER', textAlign: TextAlign.center),
              SizedBox(height: 20),
              ...games.map((game) => GameTile(title: game)).toList(),
              SizedBox(height: 20),
              Text('Press ESC to exit.'),
            ],
          ),
        ),
      ),
    );
  }
}

class GameTile extends StatelessWidget {
  final String title;
  const GameTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Launching $title... (just kidding!)')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text('START'),
          ),
        ],
      ),
    );
  }
}
