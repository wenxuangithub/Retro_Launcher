import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() {
  runApp(GameLauncherApp());
}

class GameLauncherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Layout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.pressStart2pTextTheme()
            .apply(bodyColor: Colors.greenAccent),
      ),
      home: GameLauncherHome(),
    );
  }
}

class GameLauncherHome extends StatefulWidget {
  @override
  _GameLauncherHomeState createState() => _GameLauncherHomeState();
}

class _GameLauncherHomeState extends State<GameLauncherHome>
    with SingleTickerProviderStateMixin {
  final List<String> games = [
    'Space Blaster 3000',
    'Cyber Kart 1989',
    'Dungeon DOS X2',
    'Neo Ninja Hunter',
    'Pixel Invaders 64',
    'Toxic Tetris 2',
  ];

  Object? model;
  late Ticker _ticker;
  Scene? scene;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      if (model != null && scene != null) {
        model!.rotation.y += 5;
        scene!.update();
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Widget retroBox({required Widget child}) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.greenAccent, width: 2),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // LEFT PANEL - SELECTION
          Expanded(
            child: retroBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SELECTION", style: TextStyle(fontSize: 10)),
                  SizedBox(height: 10),
                  ...games.map((game) => GameTile(title: game)).toList(),
                ],
              ),
            ),
          ),

          // MIDDLE PANEL - CONTENT (human.obj)
          Expanded(
            child: retroBox(
              child: Column(
                children: [
                  Text("CONTENT", style: TextStyle(fontSize: 10)),
                  SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Cube(
                        onSceneCreated: (Scene s) {
                          model = Object(
                            scale: Vector3(8.0, 8.0, 8.0),
                            fileName: 'assets/human.obj',
                          );
                          s.world.add(model!);
                          scene = s;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT PANEL - CHAT INTERFACE
          Expanded(
            child: retroBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CHAT", style: TextStyle(fontSize: 10)),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        Text("> User: Hello!", style: TextStyle(fontSize: 10)),
                        Text("> Bot: Welcome to Retro Chat.",
                            style: TextStyle(fontSize: 10)),
                        Text("> User: Launch game.", style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  TextField(
                    style: TextStyle(fontSize: 10, color: Colors.greenAccent),
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      hintStyle: TextStyle(color: Colors.greenAccent.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(fontSize: 10)),
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Text('START', style: TextStyle(fontSize: 8)),
          ),
        ],
      ),
    );
  }
}
