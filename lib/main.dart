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
      title: 'Retro Launcher',
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
              SizedBox(
                height: 200,
                width: 200,
                child: Cube(
                    onSceneCreated: (Scene s) {
                      model = Object(
                        scale: Vector3(1.0, 1.0, 1.0),
                        fileName: 'assets/human.obj',
                      );
                      s.world.add(model!);
                      s.camera.zoom = 10;
                      scene = s; // Store the reference for updates
                    }
                ),
              ),
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
